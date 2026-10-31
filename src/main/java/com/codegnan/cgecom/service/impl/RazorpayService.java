package com.codegnan.cgecom.service.impl;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.razorpay.Order;
import com.razorpay.RazorpayClient;
import com.razorpay.RazorpayException;
import com.razorpay.Utils;

/** Razorpay order creation and payment signature verification. Keys come from env vars. */
@Service
public class RazorpayService {

    private final String razorpayKey;
    private final String razorpaySecret;

    public RazorpayService(@Value("${razorpay.key:}") String razorpayKey,
                           @Value("${razorpay.secret:}") String razorpaySecret) {
        this.razorpayKey = razorpayKey;
        this.razorpaySecret = razorpaySecret;
    }

    public String getKeyId() {
        return razorpayKey;
    }

    public Order createOrder(double amount, String currency, String receipt) throws RazorpayException {
        RazorpayClient client = new RazorpayClient(razorpayKey, razorpaySecret);
        JSONObject options = new JSONObject();
        options.put("amount", Math.round(amount * 100)); // Razorpay expects the smallest currency unit
        options.put("currency", currency);
        options.put("receipt", receipt);
        return client.orders.create(options);
    }

    /**
     * Verifies the checkout signature (HMAC SHA256 of "order_id|payment_id" with the key secret)
     * using the Razorpay SDK. Returns false for missing values, a missing secret or a bad signature.
     */
    public boolean verifyPaymentSignature(String orderId, String paymentId, String signature) {
        if (isBlank(razorpaySecret) || isBlank(orderId) || isBlank(paymentId) || isBlank(signature)) {
            return false;
        }
        JSONObject attributes = new JSONObject();
        attributes.put("razorpay_order_id", orderId);
        attributes.put("razorpay_payment_id", paymentId);
        attributes.put("razorpay_signature", signature);
        try {
            return Utils.verifyPaymentSignature(attributes, razorpaySecret);
        } catch (RazorpayException e) {
            return false;
        }
    }

    private static boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}
