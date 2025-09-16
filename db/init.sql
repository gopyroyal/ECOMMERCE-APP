
CREATE DATABASE IF NOT EXISTS ecommerce CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ecommerce;

CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  name VARCHAR(100) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS products (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  price DECIMAL(10,2) NOT NULL,
  image_url VARCHAR(512),
  stock INT DEFAULT 0,
  category VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS orders (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  total DECIMAL(10,2) NOT NULL,
  status VARCHAR(50) DEFAULT 'PENDING',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS order_items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL,
  price_each DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(id),
  FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE TABLE IF NOT EXISTS cart (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL DEFAULT 1,
  UNIQUE KEY (user_id, product_id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (product_id) REFERENCES products(id)
);

INSERT IGNORE INTO users (email, password_hash, name) VALUES
('demo1@example.com', '$2b$10$abcdefghijklmnopqrstuv', 'Demo User 1'),
('demo2@example.com', '$2b$10$abcdefghijklmnopqrstuv', 'Demo User 2');

INSERT IGNORE INTO products (name, description, price, image_url, stock, category) VALUES
('Running Shoes', 'Comfortable running shoes for everyday training.', 3999.00, 'PRODUCT_IMAGE_URL_PLACEHOLDER/running-shoes.png', 50, 'Sports'),
('Cricket Bat', 'English willow cricket bat.', 6999.00, 'PRODUCT_IMAGE_URL_PLACEHOLDER/cricket-bat.png', 20, 'Sports'),
('Yoga Mat', 'Non-slip yoga mat for home workouts.', 1299.00, 'PRODUCT_IMAGE_URL_PLACEHOLDER/yoga-mat.png', 80, 'Fitness'),
('Dumbbell Set', 'Adjustable dumbbell pair, 2kg-10kg.', 4999.00, 'PRODUCT_IMAGE_URL_PLACEHOLDER/dumbbells.png', 35, 'Fitness'),
('Backpack', 'Durable backpack for daily commute.', 1999.00, 'PRODUCT_IMAGE_URL_PLACEHOLDER/backpack.png', 60, 'Accessories'),
('Football', 'Size-5 match quality football.', 1499.00, 'PRODUCT_IMAGE_URL_PLACEHOLDER/football.png', 45, 'Sports'),
('Basketball', 'Indoor/outdoor composite leather basketball.', 1599.00, 'PRODUCT_IMAGE_URL_PLACEHOLDER/basketball.png', 30, 'Sports'),
('Tennis Racket', 'Lightweight graphite racket.', 3499.00, 'PRODUCT_IMAGE_URL_PLACEHOLDER/tennis-racket.png', 25, 'Sports'),
('Cycling Helmet', 'Aerodynamic helmet with vents.', 2799.00, 'PRODUCT_IMAGE_URL_PLACEHOLDER/cycling-helmet.png', 40, 'Cycling'),
('Water Bottle', 'Insulated steel bottle, 750ml.', 899.00, 'PRODUCT_IMAGE_URL_PLACEHOLDER/water-bottle.png', 100, 'Accessories'),
('Trail Shoes', 'Rugged trail running shoes.', 4499.00, 'PRODUCT_IMAGE_URL_PLACEHOLDER/trail-shoes.png', 35, 'Sports'),
('Gym Gloves', 'Padded gloves for lifting.', 799.00, 'PRODUCT_IMAGE_URL_PLACEHOLDER/gym-gloves.png', 70, 'Fitness'),
('Jersey', 'Breathable sports jersey.', 1199.00, 'PRODUCT_IMAGE_URL_PLACEHOLDER/jersey.png', 55, 'Apparel'),
('Shorts', 'Quick-dry training shorts.', 999.00, 'PRODUCT_IMAGE_URL_PLACEHOLDER/shorts.png', 65, 'Apparel'),
('Earbuds', 'Wireless earbuds for workouts.', 2499.00, 'PRODUCT_IMAGE_URL_PLACEHOLDER/earbuds.png', 25, 'Electronics');
