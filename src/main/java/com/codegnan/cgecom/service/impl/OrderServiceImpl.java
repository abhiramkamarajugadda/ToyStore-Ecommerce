package com.codegnan.cgecom.service.impl;

import java.util.List;
import java.util.Optional;
import org.springframework.stereotype.Service;
import com.codegnan.cgecom.model.Order;
import com.codegnan.cgecom.model.User;
import com.codegnan.cgecom.repositories.OrderRepository;
import com.codegnan.cgecom.service.iface.OrderService;

@Service
public class OrderServiceImpl implements OrderService {

    private final OrderRepository orderRepository;

    public OrderServiceImpl(OrderRepository orderRepository) {
        this.orderRepository = orderRepository;
    }

    @Override
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