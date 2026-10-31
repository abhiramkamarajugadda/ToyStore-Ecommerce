package com.codegnan.cgecom.controllers;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyList;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.model;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.request;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.view;

import java.util.ArrayList;
import java.util.List;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.test.web.servlet.MockMvc;

import com.codegnan.cgecom.model.Order;
import com.codegnan.cgecom.model.OrderItem;
import com.codegnan.cgecom.model.Product;
import com.codegnan.cgecom.model.User;
import com.codegnan.cgecom.service.iface.OrderService;
import com.codegnan.cgecom.service.impl.RazorpayService;

@WebMvcTest(PaymentController.class)
class PaymentControllerTest {

    @Autowired private MockMvc mockMvc;
    @MockBean private RazorpayService razorpayService;
    @MockBean private OrderService orderService;

    private MockHttpSession sessionWithCart(String razorpayOrderId) {
        MockHttpSession session = new MockHttpSession();
        User user = new User();
        user.setUsername("user");
        OrderItem item = new OrderItem();
        item.setProduct(new Product(1, "Ball", "Red ball", 99.0, "ball.png", "Outdoor"));
        item.setPrice(99.0);
        item.setQuantity(1);
        List<OrderItem> cart = new ArrayList<>(List.of(item));
        session.setAttribute("loggedInUser", user);
        session.setAttribute("cartItems", cart);
        session.setAttribute("razorpayOrderId", razorpayOrderId);
        return session;
    }

    @Test
    void validSignatureCreatesPaidOrderAndClearsCart() throws Exception {
        MockHttpSession session = sessionWithCart("order_1");
        when(razorpayService.verifyPaymentSignature("order_1", "pay_1", "good")).thenReturn(true);
        when(orderService.placeOrder(any(User.class), anyList(), eq("PAID"))).thenReturn(new Order());

        mockMvc.perform(post("/payment/verify").session(session)
                        .param("razorpayPaymentId", "pay_1")
                        .param("razorpayOrderId", "order_1")
                        .param("razorpaySignature", "good"))
                .andExpect(status().isOk())
                .andExpect(view().name("payment-success"))
                .andExpect(model().attributeExists("order"))
                .andExpect(request().sessionAttributeDoesNotExist("cartItems"));

        verify(orderService).placeOrder(any(User.class), anyList(), eq("PAID"));
    }

    @Test
    void invalidSignatureIsRejectedWithoutCreatingOrder() throws Exception {
        MockHttpSession session = sessionWithCart("order_1");
        when(razorpayService.verifyPaymentSignature("order_1", "pay_1", "forged")).thenReturn(false);

        mockMvc.perform(post("/payment/verify").session(session)
                        .param("razorpayPaymentId", "pay_1")
                        .param("razorpayOrderId", "order_1")
                        .param("razorpaySignature", "forged"))
                .andExpect(status().isBadRequest())
                .andExpect(view().name("error"));

        verify(orderService, never()).placeOrder(any(), anyList(), any());
    }

    @Test
    void orderIdFromAnotherSessionIsRejected() throws Exception {
        MockHttpSession session = sessionWithCart("order_1");

        mockMvc.perform(post("/payment/verify").session(session)
                        .param("razorpayPaymentId", "pay_1")
                        .param("razorpayOrderId", "order_OTHER")
                        .param("razorpaySignature", "whatever"))
                .andExpect(status().isBadRequest());

        verify(razorpayService, never()).verifyPaymentSignature(any(), any(), any());
        verify(orderService, never()).placeOrder(any(), anyList(), any());
    }
}
