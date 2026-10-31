package com.codegnan.cgecom.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

/** Registration form bound from login.jsp and validated with Bean Validation. */
public class RegistrationForm {

    @Size(max = 100, message = "Full name must be at most 100 characters.")
    private String fullName;

    @NotBlank(message = "Username is required.")
    @Size(min = 3, max = 50, message = "Username must be 3 to 50 characters.")
    private String username;

    @NotBlank(message = "Email is required.")
    @Email(message = "Please enter a valid email address.")
    private String email;

    @NotBlank(message = "Phone number is required.")
    @Pattern(regexp = "^\\+?[0-9]{10,13}$", message = "Please enter a valid phone number (10 to 13 digits).")
    private String phoneNumber;

    @Size(max = 500, message = "Address must be at most 500 characters.")
    private String address;

    @Size(max = 100, message = "City must be at most 100 characters.")
    private String city;

    @Pattern(regexp = "^$|^[0-9]{6}$", message = "Pincode must be 6 digits.")
    private String pincode;

    @NotBlank(message = "Password is required.")
    @Size(min = 6, max = 72, message = "Password must be 6 to 72 characters.")
    private String password;

    private String confirmPassword;

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }
    public String getPincode() { return pincode; }
    public void setPincode(String pincode) { this.pincode = pincode; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getConfirmPassword() { return confirmPassword; }
    public void setConfirmPassword(String confirmPassword) { this.confirmPassword = confirmPassword; }
}
