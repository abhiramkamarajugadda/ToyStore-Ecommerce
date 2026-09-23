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
        if (user != null && user.getPassword().equals(password)) {
            return user;
        }
        return null; // Authentication failed
    }
    
    public User createUser(String username, String password, String role,String phoneNumber,String email) {
        User user = new User();
        user.setUsername(username);
        user.setPassword(password); 
        user.setRole(role);
        user.setPhone_number(phoneNumber);   
        user.setEmail(email);
        return userRepository.save(user);
    }
    
  
    @Override
    public User getUserById(int id) {
        // We use findById() and return the user or throw an exception if not found
        return userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found with id: " + id));
    }

    @Override
    public void updateUser(int id, String username, String password, String role,String phoneNumber,String email) {
        User user = getUserById(id);  // Get the user to update
        user.setUsername(username);
        user.setPassword(password);  // In a real application, hash the password
        user.setRole(role);
        user.setPhone_number(phoneNumber);   
        user.setEmail(email);
        userRepository.save(user);  // Save the updated user back to the database
    }

    @Override
    public void deleteUser(int id) {
        User user = getUserById(id);  // Fetch the user to delete
        userRepository.delete(user);  // Delete the user from the database
    }

    @Override
    public List<User> getAllUsers() {
        return userRepository.findAll();  // Return the list of all users
    }
    
    
}
