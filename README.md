# 🧸 ToyStore --- E-Commerce Web Application

> **Play • Learn • Grow**\
> A modern toy-store e-commerce web application built with Java, Spring
> Boot, JSP/JSTL, Spring Data JPA, and MySQL.

## 📌 Project Overview

**ToyStore** is a web-based e-commerce application designed to provide a
simple and user-friendly platform for browsing toys, managing a shopping
cart, placing orders, making online payments, and receiving
order-related notifications.

The application follows a layered Spring Boot architecture with JSP/JSTL
for the web interface, Spring MVC for request handling, Spring Data
JPA/Hibernate for database access, and MySQL for persistent data
storage.

## ✨ Key Features

### 👤 User Management

-   User registration and login
-   User authentication
-   Profile and address management
-   Role-based access for users and administrators

### 🧸 Product Management

-   Browse available toys
-   View product details
-   Organize products by category
-   Product search and filtering
-   Admin product management
-   Stock/inventory management

### 🛒 Cart & Order Management

-   Add products to cart
-   Update product quantities
-   Remove products from cart
-   Place orders
-   View order history
-   Track order status

### 💳 Online Payment

-   Razorpay payment gateway integration
-   Secure online payment processing
-   Payment status handling
-   Transaction-related information

### 📧 Email Notifications

-   Order confirmation emails
-   Payment/order updates
-   Account-related notifications

### 👨‍💼 Admin Management

-   Manage users
-   Manage products and categories
-   View and process orders
-   Track payments
-   Manage inventory
-   View application information and reports

## 🏗️ System Architecture

``` text
Client / User → JSP Views → Spring MVC Controller → Service Layer
                                      ↓
                              Repository Layer
                                      ↓
                                  MySQL DB

External Services: Razorpay (Payments) | Spring Mail (Notifications)
```

## 🔄 Application Workflow

``` text
Registration / Login
        ↓
Browse / Search Products
        ↓
Select Product → Add to Cart
        ↓
Review Cart → Place Order
        ↓
Razorpay Payment
        ↓
Order Confirmation + Email
        ↓
Order Processing
        ↓
Delivery / Order Tracking
```

## 🛠️ Technology Stack

  Layer                  Technology
  ---------------------- -----------------------------------
  Programming Language   Java 17
  Backend                Spring Boot 3.3.6
  Web Framework          Spring MVC
  View                   JSP / JSTL
  ORM                    Hibernate / JPA
  Data Access            Spring Data JPA
  Database               MySQL
  Payment                Razorpay Java SDK 1.4.8
  Email                  Spring Boot Starter Mail
  Build Tool             Maven
  Development            Spring Tool Suite / IntelliJ IDEA
  Version Control        Git / GitHub

## 🗄️ Database Design

The application uses MySQL for persistent storage. The main business
entities are organized around users, products, categories, orders, order
items, payments, and delivery information.

``` text
User 1 ───── M Order
Order 1 ──── M OrderItem
Product M ─── 1 Category
OrderItem M ─ 1 Product
Order 1 ───── 1 Payment
Order 1 ───── 1 Delivery
```

## 📂 Project Structure

``` text
ToyStore/
├── src/
│   ├── main/
│   │   ├── java/
│   │   ├── resources/
│   │   └── webapp/
│   │       └── WEB-INF/
│   │           └── views/
│   └── test/
├── pom.xml
├── .gitignore
└── README.md
```

> Exact package and JSP folder names may differ according to the project
> source structure.

## ⚙️ Prerequisites

-   JDK 17
-   Maven
-   MySQL Server
-   Git (optional)
-   Spring Tool Suite or IntelliJ IDEA

## 🚀 Getting Started

### 1. Clone the repository

``` bash
git clone <YOUR_GITHUB_REPOSITORY_URL>
cd ToyStore
```

### 2. Create the MySQL database

``` sql
CREATE DATABASE toystore;
```

If your application uses another database name, use that name in the
configuration.

### 3. Configure MySQL

Update `application.properties` with your local database credentials:

``` properties
spring.datasource.url=jdbc:mysql://localhost:3306/toystore
spring.datasource.username=root
spring.datasource.password=YOUR_PASSWORD
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
```

### 4. Configure Razorpay

Use your own Razorpay credentials and keep the secret outside GitHub:

``` properties
razorpay.key.id=YOUR_RAZORPAY_KEY
razorpay.key.secret=YOUR_RAZORPAY_SECRET
```

### 5. Configure Email

Configure the mail server settings required by the application's Spring
Mail integration. Do not commit passwords or app passwords.

### 6. Build the project

``` bash
mvn clean install
```

### 7. Run the application

``` bash
mvn spring-boot:run
```

Then open the local URL configured by the application.

## 🔐 Security Notes

-   Never commit database passwords.
-   Never commit Razorpay secret keys.
-   Never commit email passwords or app passwords.
-   Prefer environment variables or local configuration for secrets.
-   Keep IDE and build files out of version control.

## 🧪 Testing

Run the available tests with:

``` bash
mvn test
```

## 📦 Build

The project is configured with **WAR packaging** and the Spring Boot
Maven plugin.

``` bash
mvn clean package
```

The generated WAR file is placed in the `target/` directory.

## 🌟 Future Enhancements

-   Responsive mobile application
-   Wishlist functionality
-   Product reviews and ratings
-   More payment and shipping options
-   Advanced inventory management
-   Personalized toy recommendations
-   Analytics dashboard
-   Cloud deployment

## 📸 Screenshots

Add your screenshots to an `images/` folder and reference them like
this:

``` markdown
![Home Page](images/home.png)
![Products](images/products.png)
![Cart](images/cart.png)
![Payment](images/payment.png)
![Admin Dashboard](images/admin-dashboard.png)
```

## 🎯 Learning Outcomes

This project demonstrates practical experience with Java, Spring Boot,
Spring MVC, JSP/JSTL, Spring Data JPA, Hibernate, MySQL, layered
architecture, Razorpay integration, Spring Mail, Maven, and Git/GitHub.

## 👨‍💻 Author

**Haaseth Abhiram**\
ToyStore --- *Play • Learn • Grow* 🧸

## 📄 License

This project is intended for educational and portfolio purposes. Add
your preferred open-source license here if you plan to distribute it
publicly.
