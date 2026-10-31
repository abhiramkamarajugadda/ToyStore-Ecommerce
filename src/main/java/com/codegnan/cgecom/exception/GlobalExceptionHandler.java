package com.codegnan.cgecom.exception;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.resource.NoResourceFoundException;

/**
 * Central error handling for all MVC controllers: logs the failure and renders
 * a friendly error page with the right HTTP status instead of a stack trace.
 */
@ControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    @ExceptionHandler(PaymentVerificationException.class)
    public ModelAndView handlePaymentVerification(PaymentVerificationException ex) {
        log.warn("Payment verification failed: {}", ex.getMessage());
        return errorView(HttpStatus.BAD_REQUEST, "Payment verification failed",
                "We could not verify this payment, so no order was placed. " + ex.getMessage());
    }

    @ExceptionHandler({IllegalArgumentException.class, IllegalStateException.class})
    public ModelAndView handleBadRequest(RuntimeException ex) {
        log.warn("Bad request: {}", ex.getMessage());
        return errorView(HttpStatus.BAD_REQUEST, "Request could not be processed", ex.getMessage());
    }

    @ExceptionHandler(MaxUploadSizeExceededException.class)
    public ModelAndView handleUploadTooLarge(MaxUploadSizeExceededException ex) {
        return errorView(HttpStatus.PAYLOAD_TOO_LARGE, "File too large",
                "The uploaded image is larger than the allowed limit.");
    }

    @ExceptionHandler(NoResourceFoundException.class)
    public ModelAndView handleNotFound(NoResourceFoundException ex) {
        return errorView(HttpStatus.NOT_FOUND, "Page not found",
                "The page you are looking for does not exist.");
    }

    @ExceptionHandler(Exception.class)
    public ModelAndView handleUnexpected(Exception ex) {
        log.error("Unexpected error", ex);
        return errorView(HttpStatus.INTERNAL_SERVER_ERROR, "Something went wrong",
                "An unexpected error occurred. Please try again.");
    }

    private ModelAndView errorView(HttpStatus status, String title, String message) {
        ModelAndView mv = new ModelAndView("error");
        mv.setStatus(status);
        mv.addObject("status", status.value());
        mv.addObject("errorTitle", title);
        mv.addObject("errorMessage", message);
        return mv;
    }
}
