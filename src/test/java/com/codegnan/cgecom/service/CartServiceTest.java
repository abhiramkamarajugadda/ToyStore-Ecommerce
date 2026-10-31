package com.codegnan.cgecom.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import java.util.ArrayList;
import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import com.codegnan.cgecom.model.OrderItem;
import com.codegnan.cgecom.model.Product;
import com.codegnan.cgecom.service.impl.CartService;

class CartServiceTest {

    private final CartService cartService = new CartService();
    private List<OrderItem> cart;
    private Product car;
    private Product doll;

    @BeforeEach
    void setUp() {
        cart = new ArrayList<>();
        car = new Product(1, "Race Car", "Toy car", 499.0, "car.png", "Vehicles");
        doll = new Product(2, "Doll", "Toy doll", 250.0, "doll.png", "Dolls");
    }

    @Test
    void addItemMergesQuantityForSameProduct() {
        cartService.addItem(cart, car, 1);
        cartService.addItem(cart, car, 2);

        assertThat(cart).hasSize(1);
        assertThat(cart.get(0).getQuantity()).isEqualTo(3);
        assertThat(cart.get(0).getPrice()).isEqualTo(499.0);
    }

    @Test
    void addItemTreatsNonPositiveQuantityAsOne() {
        cartService.addItem(cart, doll, 0);
        assertThat(cart.get(0).getQuantity()).isEqualTo(1);
    }

    @Test
    void addItemRejectsMissingProduct() {
        assertThatThrownBy(() -> cartService.addItem(cart, null, 1))
                .isInstanceOf(IllegalArgumentException.class);
    }

    @Test
    void updateItemHandlesIncreaseDecreaseAndRemove() {
        cartService.addItem(cart, car, 1);
        cartService.updateItem(cart, 1, "increase", null);
        assertThat(cart.get(0).getQuantity()).isEqualTo(2);

        cartService.updateItem(cart, 1, "minus", null);
        assertThat(cart.get(0).getQuantity()).isEqualTo(1);

        cartService.updateItem(cart, 1, "decrease", null);
        assertThat(cart).isEmpty();
    }

    @Test
    void updateItemWithExplicitQuantity() {
        cartService.addItem(cart, car, 1);
        cartService.updateItem(cart, 1, null, 5);
        assertThat(cart.get(0).getQuantity()).isEqualTo(5);

        cartService.updateItem(cart, 1, null, 0);
        assertThat(cart).isEmpty();
    }

    @Test
    void totalsAndCountAcrossItems() {
        cartService.addItem(cart, car, 2);
        cartService.addItem(cart, doll, 1);

        assertThat(cartService.total(cart)).isEqualTo(1248.0);
        assertThat(cartService.itemCount(cart)).isEqualTo(3);
        assertThat(cartService.removeItem(cart, 1)).isTrue();
        assertThat(cartService.itemCount(cart)).isEqualTo(1);
    }
}
