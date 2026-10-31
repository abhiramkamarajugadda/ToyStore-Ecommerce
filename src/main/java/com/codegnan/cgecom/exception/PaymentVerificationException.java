package com.codegnan.cgecom.exception;

/** Thrown when a Razorpay payment signature or order id does not verify. */
public class PaymentVerificationException extends RuntimeException {
    public PaymentVerificationException(String message) {
        super(message);
    }
}
