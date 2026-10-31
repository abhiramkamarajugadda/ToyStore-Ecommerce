package com.codegnan.cgecom.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import com.codegnan.cgecom.model.Order;
import com.codegnan.cgecom.model.OrderItem;
import com.codegnan.cgecom.model.Product;
import com.codegnan.cgecom.model.User;
import com.codegnan.cgecom.repositories.OrderRepository;
import com.codegnan.cgecom.service.impl.OrderServiceImpl;

@ExtendWith(MockitoExtension.class)
class OrderServiceImplTest {

    @Mock
    private OrderRepository orderRepository;

    @InjectMocks
    private OrderServiceImpl orderService;

    private OrderItem item(Product p, int qty) {
        OrderItem i = new OrderItem();
        i.setProduct(p);
        i.setPrice(p == null ? 0 : p.getPrice());
        i.setQuantity(qty);
        return i;
    }

    @Test
    void placeOrderBuildsItemsAndExactTotal() {
        when(orderRepository.save(any(Order.class))).thenAnswer(inv -> inv.getArgument(0));
        User user = new User();
        Product a = new Product(1, "Blocks", "Set", 199.99, "a.png", "Learning");
        Product b = new Product(2, "Kite", "Kite", 50.10, "b.png", "Outdoor");

        Order order = orderService.placeOrder(user, List.of(item(a, 3), item(b, 1)), "PAID");

        assertThat(order.getUser()).isSameAs(user);
        assertThat(order.getOrderStatus()).isEqualTo("PAID");
        assertThat(order.getOrderDate()).isNotNull();
        assertThat(order.getOrderItems()).hasSize(2).allMatch(i -> i.getOrder() == order);
        assertThat(order.getTotalPrice()).isEqualByComparingTo(new BigDecimal("650.07"));
    }

    @Test
    void placeOrderSkipsItemsWithoutProduct() {
        when(orderRepository.save(any(Order.class))).thenAnswer(inv -> inv.getArgument(0));
        Product a = new Product(1, "Blocks", "Set", 100.0, "a.png", "Learning");
        List<OrderItem> cart = new ArrayList<>(List.of(item(a, 1), item(null, 2)));

        Order order = orderService.placeOrder(new User(), cart, "COMPLETED");

        assertThat(order.getOrderItems()).hasSize(1);
        assertThat(order.getTotalPrice()).isEqualByComparingTo("100");
    }

    @Test
    void placeOrderRejectsEmptyCart() {
        assertThatThrownBy(() -> orderService.placeOrder(new User(), List.of(), "PAID"))
                .isInstanceOf(IllegalStateException.class);
        verify(orderRepository, never()).save(any());
    }

    @Test
    void placeOrderRequiresUser() {
        Product a = new Product(1, "Blocks", "Set", 100.0, "a.png", "Learning");
        assertThatThrownBy(() -> orderService.placeOrder(null, List.of(item(a, 1)), "PAID"))
                .isInstanceOf(IllegalArgumentException.class);
    }
}
