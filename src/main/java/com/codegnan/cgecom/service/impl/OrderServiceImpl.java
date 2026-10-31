package com.codegnan.cgecom.service.impl;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;

import java.util.List;
import java.util.Optional;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.codegnan.cgecom.model.Order;
import com.codegnan.cgecom.model.OrderItem;
import com.codegnan.cgecom.model.User;
import com.codegnan.cgecom.repositories.OrderRepository;
import com.codegnan.cgecom.service.iface.OrderService;

@Service
public class OrderServiceImpl implements OrderService {

    private final OrderRepository orderRepository;

    public OrderServiceImpl(OrderRepository orderRepository) {
        this.orderRepository = orderRepository;
    }

    /**
     * Creates the order and all its line items in one transaction: either the whole
     * order is saved or nothing is (cascade persists the OrderItem rows).
     */
    @Override
    @Transactional
    public Order placeOrder(User user, List<OrderItem> cartItems, String status) {
        if (user == null) {
            throw new IllegalArgumentException("A signed-in user is required to place an order.");
        }
        if (cartItems == null || cartItems.isEmpty()) {
            throw new IllegalStateException("Your cart is empty.");
        }
        Order order = new Order();
        order.setUser(user);
        order.setOrderStatus(status);
        order.setOrderDate(LocalDateTime.now());
        BigDecimal total = BigDecimal.ZERO;
        List<OrderItem> items = new ArrayList<>();
        for (OrderItem cartItem : cartItems) {
            if (cartItem.getProduct() == null) {
                continue;
            }
            OrderItem item = new OrderItem();
            item.setOrder(order);
            item.setProduct(cartItem.getProduct());
            item.setPrice(cartItem.getPrice());
            item.setQuantity(cartItem.getQuantity());
            total = total.add(BigDecimal.valueOf(cartItem.getPrice()).multiply(BigDecimal.valueOf(cartItem.getQuantity())));
            items.add(item);
        }
        if (items.isEmpty()) {
            throw new IllegalStateException("Your cart has no valid products.");
        }
        order.setOrderItems(items);
        order.setTotalPrice(total);
        return orderRepository.save(order);
    }

    @Override
    @Transactional
    public void saveOrder(Order order) {
        orderRepository.save(order);
    }

    @Override
    public List<Order> getAllOrders() {
        return orderRepository.findAllByOrderByIdDesc();
    }

    @Override
    public List<Order> getOrdersByUser(User user) {
        return orderRepository.findByUserOrderByIdDesc(user);
    }

    @Override
    public Order getOrderById(int id) {
        Optional<Order> order = orderRepository.findById(id);
        return order.orElse(null);
    }

    @Override
    @Transactional
    public void updateOrderStatus(int orderId, String status) {
        Optional<Order> optionalOrder = orderRepository.findById(orderId);
        if (optionalOrder.isPresent()) {
            Order order = optionalOrder.get();
            order.setOrderStatus(status);
            orderRepository.save(order);
        }
    }

    @Override
    public double getTotalRevenue() {
        List<Order> orders = orderRepository.findAll();
        double total = 0;
        for (Order o : orders) {
            if (o.getTotalPrice() != null) {
                total += o.getTotalPrice().doubleValue();
            }
        }
        return total;
    }

    @Override
    public long getTotalOrdersCount() {
        return orderRepository.count();
    }
}