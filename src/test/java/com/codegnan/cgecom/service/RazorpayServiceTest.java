package com.codegnan.cgecom.service;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.Test;

import com.codegnan.cgecom.service.impl.RazorpayService;
import com.razorpay.Utils;

class RazorpayServiceTest {

    private static final String SECRET = "unit_test_secret";

    @Test
    void acceptsSignatureComputedWithKeySecret() throws Exception {
        RazorpayService service = new RazorpayService("rzp_test_key", SECRET);
        String signature = Utils.getHash("order_ABC|pay_XYZ", SECRET);

        assertThat(service.verifyPaymentSignature("order_ABC", "pay_XYZ", signature)).isTrue();
    }

    @Test
    void rejectsTamperedSignatureOrIds() throws Exception {
        RazorpayService service = new RazorpayService("rzp_test_key", SECRET);
        String signature = Utils.getHash("order_ABC|pay_XYZ", SECRET);

        assertThat(service.verifyPaymentSignature("order_ABC", "pay_OTHER", signature)).isFalse();
        assertThat(service.verifyPaymentSignature("order_ABC", "pay_XYZ", "deadbeef")).isFalse();
        assertThat(service.verifyPaymentSignature("order_ABC", "pay_XYZ", "")).isFalse();
    }

    @Test
    void rejectsEverythingWhenSecretMissing() throws Exception {
        RazorpayService service = new RazorpayService("rzp_test_key", "");
        String signature = Utils.getHash("order_ABC|pay_XYZ", SECRET);

        assertThat(service.verifyPaymentSignature("order_ABC", "pay_XYZ", signature)).isFalse();
    }
}
