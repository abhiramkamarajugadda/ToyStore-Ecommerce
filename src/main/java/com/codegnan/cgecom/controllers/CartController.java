package com.codegnan.cgecom.controllers;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.codegnan.cgecom.model.Order;
import com.codegnan.cgecom.model.OrderItem;
import com.codegnan.cgecom.model.Product;
import com.codegnan.cgecom.model.User;
import com.codegnan.cgecom.service.iface.OrderService;
import com.codegnan.cgecom.service.iface.ProductService;
import com.codegnan.cgecom.service.iface.UserService;
import com.codegnan.cgecom.service.impl.CartService;
import com.codegnan.cgecom.service.impl.RazorpayService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping({"/cart", "/cart/"})
public class CartController {

    private final ProductService productService;
    private final OrderService orderService;
    private final UserService userService;
    private final RazorpayService razorpayService;
    private final CartService cartService;

    public CartController(ProductService productService, OrderService orderService, UserService userService,
                          RazorpayService razorpayService, CartService cartService) {
        this.productService = productService;
        this.orderService = orderService;
        this.userService = userService;
        this.razorpayService = razorpayService;
        this.cartService = cartService;
    }

    @GetMapping({"", "/"})
    public String viewCart(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            redirectAttributes.addFlashAttribute("error", "Please sign in with your credentials to access your shopping cart.");
            return "redirect:/login";
        }

        List<OrderItem> cartItems = getCartItemsFromSession(session);
        double subtotal = cartService.total(cartItems);

        model.addAttribute("cartItems", cartItems);
        model.addAttribute("subtotal", subtotal);
        model.addAttribute("totalPrice", subtotal);
        model.addAttribute("totalItemsCount", cartService.itemCount(cartItems));
        return "cart";
    }

    @GetMapping("/count")
    @ResponseBody
    public Map<String, Object> getCartCount(HttpSession session) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        Map<String, Object> res = new HashMap<>();
        if (loggedInUser == null) {
            res.put("count", 0);
            return res;
        }
        res.put("count", cartService.itemCount(getCartItemsFromSession(session)));
        return res;
    }

    @RequestMapping(value = "/add", method = {RequestMethod.GET, RequestMethod.POST})
    public String addToCart(@RequestParam int productId,
                            @RequestParam(defaultValue = "1") int quantity,
                            @RequestParam(required = false, defaultValue = "false") boolean ajax,
                            @RequestParam(required = false) String redirectUrl,
                            HttpSession session,
                            RedirectAttributes redirectAttributes) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            redirectAttributes.addFlashAttribute("error", "Please sign in with your credentials to add items to your cart.");
            return "redirect:/login";
        }

        Product product = productService.getProductById(productId);
        if (product == null) {
            redirectAttributes.addFlashAttribute("error", "Product not found.");
            return "redirect:" + (redirectUrl != null && !redirectUrl.isEmpty() ? redirectUrl : "/products");
        }

        List<OrderItem> cartItems = getCartItemsFromSession(session);
        cartService.addItem(cartItems, product, quantity);
        session.setAttribute("cartItems", cartItems);
        redirectAttributes.addFlashAttribute("success", "Added \"" + product.getName() + "\" to your cart!");

        if (redirectUrl != null && !redirectUrl.trim().isEmpty()) {
            return "redirect:" + redirectUrl;
        }
        return "redirect:/products";
    }

    @RequestMapping(value = "/update", method = {RequestMethod.GET, RequestMethod.POST})
    public String updateCart(@RequestParam int productId,
                             @RequestParam(required = false) Integer quantity,
                             @RequestParam(required = false) String action,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            redirectAttributes.addFlashAttribute("error", "Please sign in with your credentials to update your cart.");
            return "redirect:/login";
        }

        List<OrderItem> cartItems = getCartItemsFromSession(session);
        cartService.updateItem(cartItems, productId, action, quantity);
        session.setAttribute("cartItems", cartItems);
        redirectAttributes.addFlashAttribute("info", "Cart updated successfully.");
        return "redirect:/cart";
    }

    @RequestMapping(value = {"/remove/{productId}", "/remove", "/delete/{productId}", "/delete"}, method = {RequestMethod.GET, RequestMethod.POST})
    public String removeItem(@PathVariable(required = false) Integer productId,
                             @RequestParam(required = false) Integer id,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            redirectAttributes.addFlashAttribute("error", "Please sign in with your credentials to manage your cart.");
            return "redirect:/login";
        }

        int targetId = productId != null ? productId : (id != null ? id : -1);
        if (targetId != -1) {
            List<OrderItem> cartItems = getCartItemsFromSession(session);
            cartService.removeItem(cartItems, targetId);
            session.setAttribute("cartItems", cartItems);
            redirectAttributes.addFlashAttribute("info", "Item removed from cart.");
        }
        return "redirect:/cart";
    }

    @RequestMapping(value = "/clear", method = {RequestMethod.GET, RequestMethod.POST})
    public String clearCart(HttpSession session, RedirectAttributes redirectAttributes) {
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            redirectAttributes.addFlashAttribute("error", "Please sign in with your credentials to clear your cart.");
            return "redirect:/login";
        }
        session.removeAttribute("cartItems");
        redirectAttributes.addFlashAttribute("info", "Your cart has been cleared.");
        return "redirect:/cart";
    }

    /** Direct 1-click order (no online payment). Saved in one transaction by OrderService. */
    @RequestMapping(value = "/checkout", method = {RequestMethod.GET, RequestMethod.POST})
    public String checkout(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        User sessionUser = (User) session.getAttribute("loggedInUser");
        if (sessionUser == null) {
            redirectAttributes.addFlashAttribute("error", "Please sign in to proceed with checkout.");
            return "redirect:/login";
        }
        List<OrderItem> cartItems = getCartItemsFromSession(session);
        if (cartItems.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Your cart is currently empty.");
            return "redirect:/products";
        }

        Order order = orderService.placeOrder(currentUser(sessionUser), new ArrayList<>(cartItems), "COMPLETED");
        session.removeAttribute("cartItems");
        model.addAttribute("order", order);
        return "checkout-success";
    }

    /**
     * Kept for old links only. Paid orders are now created exclusively by POST /payment/verify
     * after the Razorpay signature has been verified, so this page never creates an order.
     */
    @GetMapping("/payment-success")
    public String showPaymentSuccessPage(RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute("info", "Payments are confirmed only after Razorpay signature verification.");
        return "redirect:/orders";
    }

    @PostMapping("/razorpayOrder")
    @ResponseBody
    public Map<String, Object> createRazorpayOrder(HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        User sessionUser = (User) session.getAttribute("loggedInUser");
        if (sessionUser == null) {
            response.put("error", "Please sign in with your credentials before making payment.");
            return response;
        }
        try {
            List<OrderItem> cartItems = getCartItemsFromSession(session);
            if (cartItems.isEmpty()) {
                throw new IllegalStateException("Cart is empty");
            }
            double totalPrice = cartService.total(cartItems);
            com.razorpay.Order razorpayOrder = razorpayService.createOrder(totalPrice, "INR", "OrderReceipt#" + System.currentTimeMillis());
            // Remember the gateway order id so /payment/verify can reject payments for any other order.
            session.setAttribute(PaymentController.SESSION_RAZORPAY_ORDER_ID, razorpayOrder.get("id"));
            response.put("id", razorpayOrder.get("id"));
            response.put("amount", razorpayOrder.get("amount"));
            response.put("currency", razorpayOrder.get("currency"));
            response.put("key", razorpayService.getKeyId());
        } catch (Exception e) {
            response.put("error", "Failed to initialize payment gateway: " + e.getMessage());
        }
        return response;
    }

    private User currentUser(User sessionUser) {
        User fresh = userService.getUserById(sessionUser.getId());
        return fresh != null ? fresh : sessionUser;
    }

    @SuppressWarnings("unchecked")
    private List<OrderItem> getCartItemsFromSession(HttpSession session) {
        List<OrderItem> cartItems = (List<OrderItem>) session.getAttribute("cartItems");
        if (cartItems == null) {
            cartItems = new ArrayList<>();
            session.setAttribute("cartItems", cartItems);
        }
        return cartItems;
    }
}
