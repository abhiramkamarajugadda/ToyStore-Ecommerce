# ToyStore: E-Commerce Web Application

[![CI](https://github.com/abhiramkamarajugadda/ToyStore-Ecommerce/actions/workflows/ci.yml/badge.svg)](https://github.com/abhiramkamarajugadda/ToyStore-Ecommerce/actions/workflows/ci.yml)

A full-stack toy store built with Spring Boot, Spring MVC, Spring Data JPA, JSP/JSTL and MySQL, with Razorpay payments and HTML welcome emails.

## Live Demo

**Live link:** _coming soon (Render free tier)_

Demo shopper login: `user` / `user123` (a public demo account with no real data). Payments run in Razorpay **test mode**, so use Razorpay test cards; no real money moves. The free server sleeps when idle, so the first visit can take about a minute to wake up.

## Features

- **Accounts:** registration (full name, username, email, phone, address, city, pincode), login, logout and session-based authentication
- **Roles:** `ADMIN` and `USER` roles; admin pages check the session role before allowing access
- **Catalog:** product listing with keyword search and category filter
- **Admin product management:** add, edit and delete products, including image upload (multipart, stored under `uploads/images/`)
- **Cart:** session cart with add, update quantity, remove, clear and a live item count endpoint
- **Checkout and orders:** places an `Order` with its `OrderItem` rows in a single `@Transactional` service call, then shows the order history and order detail pages
- **Razorpay payments:** creates a Razorpay order through the Razorpay Java SDK (`POST /cart/razorpayOrder`); `POST /payment/verify` checks the payment signature with the key secret before the order is saved as `PAID`
- **Admin dashboard:** total revenue, total orders, products and users, plus order status updates
- **User management (admin):** create, edit and delete users
- **Email:** asynchronous HTML welcome email on registration through Spring Mail (`JavaMailSender`)
- **Seed data:** `DataInitializer` creates a default admin and a default user on first start
- **Validation:** Bean Validation (`@Valid`) on the registration form and the product add/edit forms
- **Error handling:** a `@ControllerAdvice` global exception handler renders one error page with the correct HTTP status (400, 404, 413, 500)

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Java 17 |
| Framework | Spring Boot 3.3.6, Spring MVC |
| Persistence | Spring Data JPA, Hibernate, MySQL (`mysql-connector-j`) |
| Views | JSP, JSTL (Tomcat Jasper) |
| Payments | Razorpay Java SDK 1.4.8 |
| Email | Spring Boot Starter Mail |
| Security | BCrypt password hashing (`spring-security-crypto`) |
| Testing | JUnit 5, Mockito, `@WebMvcTest`, `@DataJpaTest`, H2 (test scope), JaCoCo |
| CI/CD | GitHub Actions (`mvn -B verify` on JDK 17, Docker image build) |
| Containers | Multi-stage Dockerfile, Docker Compose with MySQL 8 |
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
  configurtion/      DataInitializer, WebConfig (serves uploaded images), SecurityConfig (BCrypt encoder)
  controllers/       Admin, Cart, Login, Order, Payment, Product, User controllers
  model/             User, Product, Order, OrderItem (JPA entities)
  repositories/      UserRepository, ProductRepository, OrderRepository
  service/iface/     UserService, ProductService, OrderService
  dto/               RegistrationForm (validated registration input)
  exception/         GlobalExceptionHandler, PaymentVerificationException
  service/impl/      Service implementations, CartService, RazorpayService, EmailService
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
| GET | `/cart/payment-success` | Legacy link; redirects to `/orders` (no order is created here) |
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
| POST | `/payment/verify` | Verifies the Razorpay signature, then saves the `PAID` order |

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
   | `ADMIN_PASSWORD` | Password for the seeded `admin` account (defaults to `admin123` for local use only) |
   | `MAIL_ENABLED`, `MAIL_USERNAME`, `MAIL_PASSWORD` | Welcome emails are off unless `MAIL_ENABLED=true`; then a Gmail address and SMTP app password |
   | `PORT` | HTTP port (default `8081`) |
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

`DataInitializer` seeds 12 products, an `admin` account (password from `ADMIN_PASSWORD`) and a demo shopper `user` / `user123`.

## Running with Docker

```bash
cp .env.example .env        # then fill in your own values; .env is git-ignored
docker compose up --build
```

This starts MySQL 8 and the app (multi-stage build: Maven builds the WAR, a slim JRE image runs it). Open `http://localhost:8081`.

## Deploy to Render (free) with Aiven MySQL

Both services have free plans with no card needed.

1. **Database:** create a free MySQL service on [Aiven](https://aiven.io). From its overview page copy the host, port, user (`avnadmin`) and password.
2. **App:** on [Render](https://render.com) choose **New > Blueprint** and pick this repository. `render.yaml` builds the `Dockerfile` on the free plan.
3. Fill in the environment variables Render asks for:
   | Variable | Value |
   |---|---|
   | `SPRING_DATASOURCE_URL` | `jdbc:mysql://<aiven-host>:<port>/defaultdb?sslMode=REQUIRED` |
   | `SPRING_DATASOURCE_USERNAME` | `avnadmin` |
   | `SPRING_DATASOURCE_PASSWORD` | Aiven password |
   | `RAZORPAY_KEY_ID`, `RAZORPAY_KEY_SECRET` | Razorpay **test mode** keys |
   | `APP_BASE_URL` | The Render URL, e.g. `https://toystore-ecommerce.onrender.com` |
   | `ADMIN_PASSWORD` | Generated by Render automatically |
   | `MAIL_ENABLED` | `false` (Render free blocks outgoing SMTP) |
4. Deploy. Hibernate creates the tables and `DataInitializer` seeds the catalog on first start. Render sets `PORT`; the image caps the heap at 300 MB to fit the 512 MB free instance.

Notes: uploaded product images are stored on the container disk, which is reset on each deploy (seeded products use hosted images).

## Tests

```bash
mvn -B verify
```

Runs 34 tests on an in-memory H2 database (no MySQL needed) and writes a JaCoCo coverage report to `target/site/jacoco/`.

| Test class | Type | What it covers |
|---|---|---|
| `UserServiceImplTest` | Mockito unit | BCrypt hashing on create and update, login against the hash, upgrade of legacy plain-text rows |
| `OrderServiceImplTest` | Mockito unit | Order totals (BigDecimal), line items, empty cart and missing user rejected |
| `CartServiceTest` | Unit | Add, merge, increase, decrease, remove, totals and item count |
| `RazorpayServiceTest` | Unit | Valid signature accepted; tampered signature, ids or missing secret rejected |
| `PaymentControllerTest` | `@WebMvcTest` | Valid payment creates a `PAID` order; forged signature or foreign order id returns 400 and creates nothing |
| `LoginControllerTest` | `@WebMvcTest` | Login redirects, registration validation errors, valid registration |
| `UserControllerTest` | `@WebMvcTest` | Visitors and normal users cannot give themselves the `ADMIN` role |
| `RepositoryTest` | `@DataJpaTest` | Product search and category queries, order cascade and ordering |
| `SeededLoginIntegrationTest` | `@SpringBootTest` | Seeded demo accounts are stored as BCrypt hashes and still sign in |

GitHub Actions runs the same `mvn -B verify` on JDK 17 and builds the Docker image on every push.

## Security Notes

- Passwords are hashed with BCrypt. Accounts created before hashing was added are upgraded to a hash on their next successful login.
- An order is marked `PAID` only after `Utils.verifyPaymentSignature` confirms the Razorpay signature with `RAZORPAY_KEY_SECRET` and the Razorpay order id matches the one created in the same session. Invalid signatures get HTTP 400 and no order.
- All credentials and API keys are read from environment variables; none are committed.
- The `admin` password comes from `ADMIN_PASSWORD`; only the `user` demo shopper login is public.
- Only an admin can assign roles; sign-up and profile edits always keep normal users as `USER`.
- Product uploads accept only raster image types (JPG, PNG, WebP, GIF, BMP, AVIF) up to 5 MB.
- Still to do for production: CSRF protection and role checks through Spring Security instead of manual session checks.

## Author

**Abhiram Kamarajugadda**
GitHub: [abhiramkamarajugadda](https://github.com/abhiramkamarajugadda) | Portfolio: [abhiramkamarajugadda.github.io](https://abhiramkamarajugadda.github.io)
