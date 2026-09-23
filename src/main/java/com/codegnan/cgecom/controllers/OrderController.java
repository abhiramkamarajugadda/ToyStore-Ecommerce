package com.codegnan.cgecom.controllers;

import java.util.List;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.codegnan.cgecom.model.Order;
import com.codegnan.cgecom.model.User;
import com.codegnan.cgecom.service.iface.OrderService;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/orders")
public class OrderController {

    private final OrderService orderService;

    public OrderController(OrderService orderService) {
        this.orderService = orderService;
    }

    @GetMapping
    public String viewMyOrders(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            redirectAttributes.addFlashAttribute("error", "Please sign in to view your order history.");
            return "redirect:/login";
        }

        List<Order> userOrders = orderService.getOrdersByUser(loggedInUser);
        model.addAttribute("orders", userOrders);
        return "orders";
    }

    @GetMapping("/{id}")
    public String viewOrderReceipt(@PathVariable int id, 
                                  HttpSession session, 
                                  Model model, 
                                  RedirectAttributes redirectAttributes) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            redirectAttributes.addFlashAttribute("error", "Please sign in to view this order.");
            return "redirect:/login";
        }

        Order order = orderService.getOrderById(id);
        if (order == null) {
            redirectAttributes.addFlashAttribute("error", "Order not found.");
            return "redirect:/orders";
        }

        // Check if the user is owner of the order or ADMIN
        if (!"ADMIN".equals(loggedInUser.getRole()) && order.getUser().getId() != loggedInUser.getId()) {
            redirectAttributes.addFlashAttribute("error", "Unauthorized access to order.");
            return "redirect:/orders";
        }

        model.addAttribute("order", order);
        return "checkout-success";
    }
}
