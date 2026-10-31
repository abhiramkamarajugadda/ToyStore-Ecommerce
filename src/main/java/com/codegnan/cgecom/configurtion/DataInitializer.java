package com.codegnan.cgecom.configurtion;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import com.codegnan.cgecom.model.Product;
import com.codegnan.cgecom.model.User;
import com.codegnan.cgecom.repositories.ProductRepository;
import com.codegnan.cgecom.repositories.UserRepository;

@Component
public class DataInitializer implements CommandLineRunner {

    private final UserRepository userRepository;
    private final ProductRepository productRepository;

    private final PasswordEncoder passwordEncoder;
    private final String adminPassword;
    private final String userPassword;

    public DataInitializer(UserRepository userRepository, ProductRepository productRepository,
                           PasswordEncoder passwordEncoder,
                           @Value("${app.demo.admin-password:admin123}") String adminPassword,
                           @Value("${app.demo.user-password:user123}") String userPassword) {
        this.userRepository = userRepository;
        this.productRepository = productRepository;
        this.passwordEncoder = passwordEncoder;
        this.adminPassword = adminPassword;
        this.userPassword = userPassword;
    }

    @Override
    public void run(String... args) throws Exception {
        // Seed default Admin & User if not present
        if (!userRepository.existsByUsername("admin")) {
            User admin = new User();
            admin.setUsername("admin");
            admin.setPassword(passwordEncoder.encode(adminPassword)); // set ADMIN_PASSWORD in production
            admin.setRole("ADMIN");
            admin.setEmail("admin@toystore.com");
            admin.setPhone_number("9876543210");
            userRepository.save(admin);
        }

        if (!userRepository.existsByUsername("user")) {
            User customer = new User();
            customer.setUsername("user");
            customer.setPassword(passwordEncoder.encode(userPassword)); // public demo shopper account
            customer.setRole("USER");
            customer.setEmail("customer@toystore.com");
            customer.setPhone_number("9876543211");
            userRepository.save(customer);
        }

        // Seed Toy Store products safely (without deleting existing ordered items)
        seedProductIfNotExists(
            "LEGO Technic RC High-Speed Stunt Racer",
            "Remote-controlled motorized tracked vehicle with huge tracks and high acceleration. 324 pieces.",
            4999.00,
            "https://images.unsplash.com/photo-1585366119957-e9730b6d0f60?w=700&auto=format&fit=crop&q=80",
            "Building & Construction"
        );

        seedProductIfNotExists(
            "Marvel Avengers Iron Man Electronic Action Figure",
            "12-inch deluxe titan hero figure with lights, sound effects, and repulsor blaster accessories.",
            1899.00,
            "https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?w=700&auto=format&fit=crop&q=80",
            "Action & Vehicles"
        );

        seedProductIfNotExists(
            "Giant Fluffy Cuddle Teddy Bear (3 Feet)",
            "Ultra-soft, huggable giant plush bear made with hypoallergenic materials and premium stitched paws.",
            1499.00,
            "https://images.unsplash.com/photo-1559454403-b8fb88521f11?w=700&auto=format&fit=crop&q=80",
            "Plush & Dolls"
        );

        seedProductIfNotExists(
            "STEM Solar Robotics & Space Exploration Kit",
            "12-in-1 solar-powered educational robotics building kit for aspiring young scientists and engineers.",
            2499.00,
            "https://images.unsplash.com/photo-1535378620166-273708d44e4c?w=700&auto=format&fit=crop&q=80",
            "Educational & STEM"
        );

        seedProductIfNotExists(
            "4WD High-Speed Off-Road RC Monster Truck",
            "1:16 scale all-terrain remote control rock crawler with shock absorbers and 2.4GHz wireless control.",
            2999.00,
            "https://images.unsplash.com/photo-1594787318286-3d835c1d207f?w=700&auto=format&fit=crop&q=80",
            "Action & Vehicles"
        );

        seedProductIfNotExists(
            "Monopoly Deluxe Edition Family Board Game",
            "Classic property trading board game with wooden houses, golden tokens, and banking accessories.",
            1299.00,
            "https://images.unsplash.com/photo-1610890716171-6b1bb98ffd09?w=700&auto=format&fit=crop&q=80",
            "Board Games & Puzzles"
        );

        seedProductIfNotExists(
            "Princess Dream Villa Playset with Furniture",
            "Multi-story colorful dollhouse with 4 rooms, interactive accessories, lights, and mini figurines.",
            3299.00,
            "https://images.unsplash.com/photo-1581557991964-125469da3b8a?w=700&auto=format&fit=crop&q=80",
            "Plush & Dolls"
        );

        seedProductIfNotExists(
            "Montessori Wooden Rainbow Arch Stacker",
            "Eco-friendly non-toxic wooden building blocks for creative stacking, balance, and fine motor skills.",
            899.00,
            "https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?w=700&auto=format&fit=crop&q=80",
            "Educational & STEM"
        );

        seedProductIfNotExists(
            "Hot Wheels Track Builder Super Loop Kit",
            "Customizable track system with multi-loop stunt ramps and 2 die-cast race cars included.",
            1699.00,
            "https://images.unsplash.com/photo-1563720223185-11003d516935?w=700&auto=format&fit=crop&q=80",
            "Action & Vehicles"
        );

        seedProductIfNotExists(
            "1000-Piece Magical Fantasy Kingdom Jigsaw Puzzle",
            "High-definition interlocking puzzle made from recycled board with glare-free matte finish.",
            749.00,
            "https://images.unsplash.com/photo-1560807707-8cc77767d783?w=700&auto=format&fit=crop&q=80",
            "Board Games & Puzzles"
        );

        seedProductIfNotExists(
            "Nerf Elite 2.0 Motorized Rapid Blaster",
            "Includes 20 official foam darts, tactical rails, and motorized rapid-fire dart launching action.",
            2199.00,
            "https://images.unsplash.com/photo-1566576912321-d58ddd7a6088?w=700&auto=format&fit=crop&q=80",
            "Outdoor & Sports"
        );

        seedProductIfNotExists(
            "Musical Baby Learning Activity Piano Cube",
            "Interactive multi-functional activity toy with light-up drum pads, animal sounds, and melody keys.",
            1199.00,
            "https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=700&auto=format&fit=crop&q=80",
            "Educational & STEM"
        );
    }

    private void seedProductIfNotExists(String name, String description, double price, String imagePath, String category) {
        if (!productRepository.existsByName(name)) {
            productRepository.save(new Product(0, name, description, price, imagePath, category));
        }
    }
}
