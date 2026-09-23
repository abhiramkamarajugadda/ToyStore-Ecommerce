package com.codegnan.cgecom.service.impl;
import org.springframework.stereotype.Service;
import com.codegnan.cgecom.model.Order;
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
}