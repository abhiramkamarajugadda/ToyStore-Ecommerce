# ToyStore: E-Commerce Web Application

A full-stack toy store built with Spring Boot, Spring MVC, Spring Data JPA, JSP/JSTL and MySQL, with Razorpay payments and HTML welcome emails.

## Features

- **Accounts:** registration (full name, username, email, phone, address, city, pincode), login, logout and session-based authentication
- **Roles:** `ADMIN` and `USER` roles; admin pages check the session role before allowing access
- **Catalog:** product listing with keyword search and category filter
- **Admin product management:** add, edit and delete products, including image upload (multipart, stored under `uploads/images/`)
- **Cart:** session cart with add, update quantity, remove, clear and a live item count endpoint
- **Checkout and orders:** places an `Order` with `OrderItem` rows, then shows the order history and order detail pages
- **Razorpay payments:** creates a Razorpay order through the Razorpay Java SDK (`POST /cart/razorpayOrder`) and records the order as `PAID` on success
- **Admin dashboard:** total revenue, total orders, products and users, plus order status updates
- **User management (admin):** create, edit and delete users
- **Email:** asynchronous HTML welcome email on registration through Spring Mail (`JavaMailSender`)
- **Seed data:** `DataInitializer` creates a default admin and a default user on first start

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Java 17 |
| Framework | Spring Boot 3.3.6, Spring MVC |
| Persistence | Spring Data JPA, Hibernate, MySQL (`mysql-connector-j`) |
| Views | JSP, JSTL (Tomcat Jasper) |
| Payments | Razorpay Java SDK 1.4.8 |
| Email | Spring Boot Starter Mail |
| Build | Maven (WAR packaging, Maven Wrapper included) |

## Architecture

Layered Spring MVC application:

```text
JSP views  ->  Controllers  ->  Services (interface + impl)  ->  Spring Data JPA repositories  ->  MySQL
                                     |
                                     +-> RazorpayService (payments), EmailService (Spring Mail)
```

```text
src/main/java/com/codegnan/cgecom/
  configurtion/      DataInitializer, WebConfig (serves uploaded images)
  controllers/       Admin, Cart, Login, Order, Payment, Product, User controllers
  model/             User, Product, Order, OrderItem (JPA entities)
  repositories/      UserRepository, ProductRepository, OrderRepository
  service/iface/     UserService, ProductService, OrderService
  service/impl/      Service implementations, RazorpayService, EmailService, PaymentService
src/main/java/com/codegnan/cgecom/JspwithbootApplication.java   Spring Boot entry point (@EnableAsync)
src/main/webapp/WEB-INF/views/                        JSP pages
```

## Routes

| Method | Path | Description |
|---|---|---|
| GET | `/` | Landing page |
| GET, POST | `/login` | Login page and login submit |
| GET, POST | `/register` | Register page and registration submit |
| GET | `/logout` | End the session |
| GET | `/products` | Product list (`search`, `category` query params) |
| GET, POST | `/products/add` | Add product (admin) |
| GET, POST | `/products/edit/{id}` | Edit product (admin) |
| GET | `/products/delete/{id}` | Delete product (admin) |
| GET | `/cart` | View cart |
| GET | `/cart/count` | Cart item count (JSON) |
| GET, POST | `/cart/add` | Add a product to the cart |
| GET, POST | `/cart/update` | Update quantity |
| GET, POST | `/cart/remove/{productId}` | Remove an item |
| GET, POST | `/cart/clear` | Empty the cart |
| GET, POST | `/cart/checkout` | Place the order |
| POST | `/cart/razorpayOrder` | Create a Razorpay order (JSON) |
| GET | `/cart/payment-success` | Save the paid order and show confirmation |
| GET | `/orders` | Order history for the logged-in user |
| GET | `/orders/{id}` | Order detail |
| GET | `/admin/dashboard` | Admin dashboard |
| POST | `/admin/orders/status/{id}` | Update order status (admin) |
| GET | `/users` | List users (admin) |
| GET, POST | `/users/create` | Create user (admin) |
| GET | `/users/edit/{id}` | Edit user form (admin) |
| POST | `/users/update/{id}` | Update user (admin) |
| GET | `/users/delete/{id}` | Delete user (admin) |
| GET | `/payment/checkout` | Payment page for an amount |
| POST | `/payment/verify` | Payment callback page |

## Data Model

| Entity | Table | Key fields | Relationships |
|---|---|---|---|
| `User` | `users` | id, username (unique), full_name, password, role, email, phone_number, address, city, pincode | One user has many orders |
| `Product` | `product` | id, name, description, price, image_path, category | Referenced by order items |
| `Order` | `orders` | id, user_id, totalPrice, orderStatus, order_date | Many-to-one user, one-to-many order items |
| `OrderItem` | `order_items` | id, order_id, product_id, quantity, price | Many-to-one order and product |

Tables are created by Hibernate (`spring.jpa.hibernate.ddl-auto=update`).

## Getting Started

**Prerequisites:** JDK 17, MySQL 8, Maven (or the included Maven Wrapper: `sh mvnw spring-boot:run`).

1. Clone the repository.
   ```bash
   git clone https://github.com/abhiramkamarajugadda/ToyStore-Ecommerce.git
   cd ToyStore-Ecommerce
   ```
2. Create the database.
   ```sql
   CREATE DATABASE ecomtoy;
   ```
3. Set these environment variables (see `.env.example`); `application.properties` reads them and never stores real values:
   | Variable | Purpose |
   |---|---|
   | `DB_USERNAME`, `DB_PASSWORD` | MySQL credentials |
   | `RAZORPAY_KEY_ID`, `RAZORPAY_KEY_SECRET` | Razorpay test API keys (the key ID is also sent to the checkout page) |
   | `MAIL_USERNAME`, `MAIL_PASSWORD` | Gmail address and SMTP app password for welcome emails |
   ```bash
   export DB_USERNAME=root DB_PASSWORD=your_mysql_password
   export RAZORPAY_KEY_ID=rzp_test_xxx RAZORPAY_KEY_SECRET=your_secret
   export MAIL_USERNAME=you@gmail.com MAIL_PASSWORD=your_app_password
   ```
4. Run the application. The project contains two `@SpringBootApplication` classes, so name the main class explicitly.
   ```bash
   mvn spring-boot:run -Dspring-boot.run.main-class=com.codegnan.cgecom.JspwithbootApplication
   ```
5. Open `http://localhost:8081`.

The seeded logins created by `DataInitializer` (an `admin` and a `user` account) are demo-only defaults for local testing; change or remove them before any real use.

## Author

**Abhiram Kamarajugadda**
GitHub: [abhiramkamarajugadda](https://github.com/abhiramkamarajugadda) | Portfolio: [abhiramkamarajugadda.github.io](https://abhiramkamarajugadda.github.io)
