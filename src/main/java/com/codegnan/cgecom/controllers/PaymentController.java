package com.codegnan.cgecom.controllers;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.codegnan.cgecom.exception.PaymentVerificationException;
import com.codegnan.cgecom.model.Order;
import com.codegnan.cgecom.model.OrderItem;
import com.codegnan.cgecom.model.User;
import com.codegnan.cgecom.service.iface.OrderService;
import com.codegnan.cgecom.service.impl.RazorpayService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/payment")
public class PaymentController {

    static final String SESSION_RAZORPAY_ORDER_ID = "razorpayOrderId";

    private final RazorpayService razorpayService;
    private final OrderService orderService;

    public PaymentController(RazorpayService razorpayService, OrderService orderService) {
        this.razorpayService = razorpayService;
        this.orderService = orderService;
    }

    @GetMapping("/checkout")
    public String checkout(@RequestParam double amount, HttpSession session, Model model) throws Exception {
        com.razorpay.Order order = razorpayService.createOrder(amount, "INR", "receipt_" + System.currentTimeMillis());
        session.setAttribute(SESSION_RAZORPAY_ORDER_ID, order.get("id"));
        model.addAttribute("razorpayOrderId", order.get("id"));
        model.addAttribute("amount", order.get("amount"));
        model.addAttribute("razorpayKey", razorpayService.getKeyId());
        return "checkout";
    }

    /**
     * Called by the Razorpay checkout handler. The order is only saved as PAID after the
     * signature verifies against RAZORPAY_KEY_SECRET and the order id matches the one this
     * session created. Anything else is rejected with HTTP 400 and no order is created.
     */
    @PostMapping("/verify")
    public String verifyPayment(@RequestParam String razorpayPaymentId,
                                @RequestParam String razorpayOrderId,
                                @RequestParam String razorpaySignature,
                                HttpSession session,
                                Model model) {
        Object expectedOrderId = session.getAttribute(SESSION_RAZORPAY_ORDER_ID);
        if (expectedOrderId == null || !expectedOrderId.equals(razorpayOrderId)) {
            throw new PaymentVerificationException("The payment does not match an order created in this session.");
        }
        if (!razorpayService.verifyPaymentSignature(razorpayOrderId, razorpayPaymentId, razorpaySignature)) {
            throw new PaymentVerificationException("Invalid payment signature.");
        }
        session.removeAttribute(SESSION_RAZORPAY_ORDER_ID);

        User user = (User) session.getAttribute("loggedInUser");
        @SuppressWarnings("unchecked")
        List<OrderItem> cartItems = (List<OrderItem>) session.getAttribute("cartItems");
        if (user != null && cartItems != null && !cartItems.isEmpty()) {
            Order order = orderService.placeOrder(user, new ArrayList<>(cartItems), "PAID");
            session.removeAttribute("cartItems");
            model.addAttribute("order", order);
        }
        model.addAttribute("paymentId", razorpayPaymentId);
        model.addAttribute("message", "Your payment was verified and processed successfully via Razorpay!");
        return "payment-success";
    }
}
