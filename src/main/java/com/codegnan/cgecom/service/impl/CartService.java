package com.codegnan.cgecom.service.impl;

import java.util.Iterator;
import java.util.List;

import org.springframework.stereotype.Service;

import com.codegnan.cgecom.model.OrderItem;
import com.codegnan.cgecom.model.Product;

/**
 * Session cart operations. The cart itself lives in the HTTP session as a
 * List of OrderItem; this service holds the rules so they can be unit tested.
 */
@Service
public class CartService {

    /** Adds a product, or increases its quantity if it is already in the cart. Quantity is at least 1. */
    public OrderItem addItem(List<OrderItem> cart, Product product, int quantity) {
        if (product == null) {
            throw new IllegalArgumentException("Product not found.");
        }
        int qty = Math.max(quantity, 1);
        OrderItem existing = find(cart, product.getId());
        if (existing != null) {
            existing.setQuantity(existing.getQuantity() + qty);
            return existing;
        }
        OrderItem item = new OrderItem();
        item.setProduct(product);
        item.setPrice(product.getPrice());
        item.setQuantity(qty);
        cart.add(item);
        return item;
    }

    /**
     * Applies an update from the cart page: "increase"/"plus", "decrease"/"minus",
     * "remove"/"delete", or an explicit quantity. A quantity of 0 or less removes the item.
     */
    public void updateItem(List<OrderItem> cart, int productId, String action, Integer quantity) {
        OrderItem target = find(cart, productId);
        if (target == null) {
            return;
        }
        if ("decrease".equalsIgnoreCase(action) || "minus".equalsIgnoreCase(action)) {
            setOrRemove(cart, target, target.getQuantity() - 1);
        } else if ("increase".equalsIgnoreCase(action) || "plus".equalsIgnoreCase(action)) {
            target.setQuantity(target.getQuantity() + 1);
        } else if ("remove".equalsIgnoreCase(action) || "delete".equalsIgnoreCase(action)) {
            cart.remove(target);
        } else if (quantity != null) {
            setOrRemove(cart, target, quantity);
        }
    }

    public boolean removeItem(List<OrderItem> cart, int productId) {
        boolean removed = false;
        for (Iterator<OrderItem> it = cart.iterator(); it.hasNext();) {
            OrderItem item = it.next();
            if (item.getProduct() != null && item.getProduct().getId() == productId) {
                it.remove();
                removed = true;
            }
        }
        return removed;
    }

    public double total(List<OrderItem> cart) {
        return cart.stream().mapToDouble(i -> i.getPrice() * i.getQuantity()).sum();
    }

    public int itemCount(List<OrderItem> cart) {
        return cart.stream().mapToInt(OrderItem::getQuantity).sum();
    }

    private void setOrRemove(List<OrderItem> cart, OrderItem item, int newQty) {
        if (newQty <= 0) {
            cart.remove(item);
        } else {
            item.setQuantity(newQty);
        }
    }

    private OrderItem find(List<OrderItem> cart, int productId) {
        for (OrderItem item : cart) {
            if (item.getProduct() != null && item.getProduct().getId() == productId) {
                return item;
            }
        }
        return null;
    }
}
