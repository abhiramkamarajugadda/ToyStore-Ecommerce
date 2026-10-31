package com.codegnan.cgecom.repositories;

import static org.assertj.core.api.Assertions.assertThat;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.test.context.ActiveProfiles;

import com.codegnan.cgecom.model.Order;
import com.codegnan.cgecom.model.OrderItem;
import com.codegnan.cgecom.model.Product;
import com.codegnan.cgecom.model.User;

@DataJpaTest
@ActiveProfiles("test")
class RepositoryTest {

    @Autowired private ProductRepository productRepository;
    @Autowired private UserRepository userRepository;
    @Autowired private OrderRepository orderRepository;
    @Autowired private TestEntityManager em;

    @Test
    void searchProductsMatchesNameOrDescriptionIgnoringCase() {
        productRepository.save(new Product(0, "Wooden Train", "Classic set", 799.0, "t.png", "Vehicles"));
        productRepository.save(new Product(0, "Puzzle", "A TRAIN themed puzzle", 299.0, "p.png", "Learning"));
        productRepository.save(new Product(0, "Teddy", "Soft bear", 399.0, "b.png", "Plush"));

        assertThat(productRepository.searchProducts("train")).hasSize(2);
        assertThat(productRepository.findByCategoryIgnoreCase("plush")).extracting(Product::getName).containsExactly("Teddy");
        assertThat(productRepository.existsByName("Puzzle")).isTrue();
    }

    @Test
    void orderCascadesItemsAndListsNewestFirst() {
        User user = new User();
        user.setUsername("buyer");
        user.setPassword("$2a$04$hash");
        user.setRole("USER");
        user.setEmail("buyer@example.com");
        user.setPhoneNumber("9876543210");
        userRepository.save(user);
        Product product = productRepository.save(new Product(0, "Ball", "Red ball", 99.0, "ball.png", "Outdoor"));

        Order first = newOrder(user, product, 1);
        Order second = newOrder(user, product, 2);
        orderRepository.save(first);
        orderRepository.save(second);
        em.flush();
        em.clear();

        List<Order> orders = orderRepository.findByUserOrderByIdDesc(userRepository.findByUsername("buyer"));
        assertThat(orders).hasSize(2);
        assertThat(orders.get(0).getId()).isGreaterThan(orders.get(1).getId());
        assertThat(orders.get(0).getOrderItems()).hasSize(1);
        assertThat(orders.get(0).getOrderItems().get(0).getQuantity()).isEqualTo(2);
    }

    private Order newOrder(User user, Product product, int qty) {
        Order order = new Order();
        order.setUser(user);
        order.setOrderStatus("PAID");
        order.setOrderDate(LocalDateTime.now());
        order.setTotalPrice(BigDecimal.valueOf(product.getPrice() * qty));
        OrderItem item = new OrderItem();
        item.setOrder(order);
        item.setProduct(product);
        item.setPrice(product.getPrice());
        item.setQuantity(qty);
        order.setOrderItems(new java.util.ArrayList<>(List.of(item)));
        return order;
    }
}
