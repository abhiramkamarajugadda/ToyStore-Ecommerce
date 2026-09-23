package com.codegnan.cgecom.service.iface;

import java.util.List;
import com.codegnan.cgecom.model.Order;
import com.codegnan.cgecom.model.User;

public interface OrderService {
    void saveOrder(Order order);
    List<Order> getAllOrders();
    List<Order> getOrdersByUser(User user);
    Order getOrderById(int id);
    void updateOrderStatus(int orderId, String status);
    double getTotalRevenue();
    long getTotalOrdersCount();
}
