package com.codegnan.cgecom.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import jakarta.mail.internet.MimeMessage;

@Service
public class EmailService {

    @Autowired(required = false)
    private JavaMailSender mailSender;

    @Value("${spring.mail.username:haaseth143@gmail.com}")
    private String senderEmail;

    /**
     * Send a general HTML email
     */
    @Async
    public void sendEmail(String to, String subject, String body) {
        if (mailSender == null || to == null || to.trim().isEmpty()) {
            System.err.println("Notice: MailSender not configured or recipient email empty. Skipped sending email to: " + to);
            return;
        }

        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            helper.setFrom(senderEmail, "ToyStore Official");
            helper.setTo(to.trim());
            helper.setSubject(subject);
            helper.setText(body, true); // true means HTML enabled
            mailSender.send(message);
            System.out.println("Email successfully sent to: " + to + " | Subject: " + subject);
        } catch (Exception e) {
            System.err.println("Error sending email to " + to + ": " + e.getMessage());
        }
    }

    /**
     * Send a beautifully branded ToyStore Welcome Email to a newly registered user
     */
    @Async
    public void sendWelcomeEmail(String toEmail, String fullName, String username) {
        if (toEmail == null || toEmail.trim().isEmpty()) {
            return;
        }

        String displayName = (fullName != null && !fullName.trim().isEmpty()) ? fullName.trim() : username;
        String subject = "Welcome to ToyStore, " + displayName + "! 🚀🧸";

        String htmlBody = "<!DOCTYPE html>"
            + "<html>"
            + "<head>"
            + "<meta charset='UTF-8'>"
            + "<meta name='viewport' content='width=device-width, initial-scale=1.0'>"
            + "<style>"
            + "  body { margin: 0; padding: 0; background-color: #f1f5f9; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif; }"
            + "  .container { max-width: 580px; margin: 20px auto; background: #ffffff; border-radius: 16px; overflow: hidden; box-shadow: 0 4px 16px rgba(0,0,0,0.08); }"
            + "  .header { background: linear-gradient(135deg, #4f46e5 0%, #ec4899 100%); padding: 36px 24px; text-align: center; color: #ffffff; }"
            + "  .header h1 { margin: 0 0 8px; font-size: 26px; font-weight: 800; letter-spacing: -0.5px; }"
            + "  .header p { margin: 0; font-size: 15px; opacity: 0.95; }"
            + "  .content { padding: 32px 28px; color: #334155; line-height: 1.6; font-size: 15px; }"
            + "  .welcome-badge { display: inline-block; background-color: #e0e7ff; color: #4338ca; font-weight: 700; font-size: 12px; padding: 4px 12px; border-radius: 999px; margin-bottom: 16px; text-transform: uppercase; letter-spacing: 0.5px; }"
            + "  .card-box { background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 12px; padding: 20px; margin: 24px 0; }"
            + "  .card-row { display: flex; justify-content: space-between; padding: 6px 0; border-bottom: 1px dashed #e2e8f0; font-size: 14px; }"
            + "  .card-row:last-child { border-bottom: none; }"
            + "  .coupon-box { background: linear-gradient(135deg, #fffbeb 0%, #fef3c7 100%); border: 2px dashed #f59e0b; border-radius: 12px; padding: 18px; text-align: center; margin: 24px 0; }"
            + "  .coupon-code { font-size: 20px; font-weight: 800; color: #b45309; letter-spacing: 2px; padding: 4px 12px; background: #ffffff; border-radius: 6px; display: inline-block; margin-top: 6px; }"
            + "  .btn-cta { display: inline-block; background: #4f46e5; color: #ffffff !important; text-decoration: none; padding: 14px 28px; border-radius: 10px; font-weight: 700; font-size: 15px; text-align: center; box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3); }"
            + "  .footer { background-color: #f8fafc; padding: 24px; text-align: center; font-size: 12px; color: #64748b; border-top: 1px solid #e2e8f0; }"
            + "</style>"
            + "</head>"
            + "<body>"
            + "  <div class='container'>"
            + "    <div class='header'>"
            + "      <div style='font-size: 42px; margin-bottom: 8px;'>🧸🚀</div>"
            + "      <h1>Welcome to ToyStore!</h1>"
            + "      <p>The magical home for toys, games, and STEM adventures</p>"
            + "    </div>"
            + "    <div class='content'>"
            + "      <div class='welcome-badge'>✨ Account Activated</div>"
            + "      <p style='font-size: 17px; margin-top: 0;'>Hi <strong>" + displayName + "</strong>,</p>"
            + "      <p>Thank you for creating an account with <strong>ToyStore</strong>! We are thrilled to welcome you to our family. Your account has been registered successfully and is ready to explore hundreds of amazing toys.</p>"
            + "      <div class='card-box'>"
            + "        <div style='font-weight: 700; font-size: 14px; color: #1e293b; margin-bottom: 10px;'>📋 Account Overview:</div>"
            + "        <div class='card-row'><strong>Full Name:</strong> <span>" + (fullName != null && !fullName.isEmpty() ? fullName : username) + "</span></div>"
            + "        <div class='card-row'><strong>Username:</strong> <span>" + username + "</span></div>"
            + "        <div class='card-row'><strong>Email:</strong> <span>" + toEmail + "</span></div>"
            + "        <div class='card-row'><strong>Membership:</strong> <span>ToyStore Club Member 🌟</span></div>"
            + "      </div>"
            + "      <div class='coupon-box'>"
            + "        <div style='font-weight: 700; color: #92400e; font-size: 15px;'>🎁 Exclusive Welcome Gift for You!</div>"
            + "        <div style='font-size: 13px; color: #b45309; margin: 4px 0;'>Enjoy <strong>20% OFF</strong> on your first order with coupon code:</div>"
            + "        <div class='coupon-code'>FESTIVE20</div>"
            + "      </div>"
            + "      <div style='text-align: center; margin: 30px 0 10px;'>"
            + "        <a href='http://localhost:8081/products' class='btn-cta'>Start Exploring Toys &rarr;</a>"
            + "      </div>"
            + "    </div>"
            + "    <div class='footer'>"
            + "      <p style='margin: 0 0 6px;'>Need help with an order or product? Simply reply to this email or visit our help desk.</p>"
            + "      <p style='margin: 0;'>&copy; " + java.time.Year.now().getValue() + " ToyStore India. All rights reserved.</p>"
            + "    </div>"
            + "  </div>"
            + "</body>"
            + "</html>";

        sendEmail(toEmail, subject, htmlBody);
    }
}