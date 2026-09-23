package com.codegnan.cgecom.service.impl;

import java.util.List;
import org.springframework.stereotype.Service;
import com.codegnan.cgecom.model.User;
import com.codegnan.cgecom.repositories.UserRepository;
import com.codegnan.cgecom.service.iface.UserService;

@Service
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;

    public UserServiceImpl(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public User authenticate(String username, String password) {
        User user = userRepository.findByUsername(username);
        if (user != null && user.getPassword() != null && user.getPassword().equals(password)) {
            return user;
        }
        return null; // Authentication failed
    }
    
    @Override
    public User saveUser(User user) {
        return userRepository.save(user);
    }
    
    @Override
    public User createUser(String username, String password, String role, String phoneNumber, String email) {
        return createUser(username, username, password, role, phoneNumber, email, null, null, null);
    }

    @Override
    public User createUser(String fullName, String username, String password, String role, String phoneNumber, String email, String address, String city, String pincode) {
        User user = new User();
        user.setFullName(fullName != null ? fullName : username);
        user.setUsername(username);
        user.setPassword(password); 
        user.setRole(role != null ? role.toUpperCase() : "USER");
        user.setPhone_number(phoneNumber);   
        user.setEmail(email);
        user.setAddress(address);
        user.setCity(city);
        user.setPincode(pincode);
        return userRepository.save(user);
    }
    
    @Override
    public User getUserById(int id) {
        return userRepository.findById(id).orElse(null);
    }

    @Override
    public User getUserByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    @Override
    public void updateUser(int id, String username, String password, String role, String phoneNumber, String email) {
        updateUser(id, username, username, password, role, phoneNumber, email, null, null, null);
    }

    @Override
    public void updateUser(int id, String fullName, String username, String password, String role, String phoneNumber, String email, String address, String city, String pincode) {
        User user = getUserById(id);
        if (user != null) {
            user.setFullName(fullName != null ? fullName : username);
            user.setUsername(username);
            if (password != null && !password.trim().isEmpty()) {
                user.setPassword(password);
            }
            if (role != null && !role.trim().isEmpty()) {
                user.setRole(role.toUpperCase());
            }
            user.setPhone_number(phoneNumber);   
            user.setEmail(email);
            if (address != null) user.setAddress(address);
            if (city != null) user.setCity(city);
            if (pincode != null) user.setPincode(pincode);
            userRepository.save(user);
        }
    }

    @Override
    public void deleteUser(int id) {
        if (userRepository.existsById(id)) {
            userRepository.deleteById(id);
        }
    }

    @Override
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    @Override
    public long getTotalUsersCount() {
        return userRepository.count();
    }

    @Override
    public boolean isUsernameTaken(String username) {
        return userRepository.existsByUsername(username);
    }
}
