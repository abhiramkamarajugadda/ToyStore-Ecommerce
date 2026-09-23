package com.codegnan.cgecom.service.iface;

import java.util.List;
import com.codegnan.cgecom.model.User;

public interface UserService {
    User authenticate(String username, String password);
    User saveUser(User user);
    User createUser(String username, String password, String role, String phoneNumber, String email);
    User createUser(String fullName, String username, String password, String role, String phoneNumber, String email, String address, String city, String pincode);
    User getUserById(int id);
    User getUserByUsername(String username);
    void deleteUser(int id);
    List<User> getAllUsers();
    void updateUser(int id, String username, String password, String role, String phoneNumber, String email);
    void updateUser(int id, String fullName, String username, String password, String role, String phoneNumber, String email, String address, String city, String pincode);
    long getTotalUsersCount();
    boolean isUsernameTaken(String username);
}
