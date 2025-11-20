CREATE DATABASE IF NOT EXISTS smallbusiness;
USE smallbusiness;

CREATE TABLE addresses (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    street VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    postcode INT NOT NULL
);

CREATE TABLE clients (
    client_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    email VARCHAR(50) NOT NULL,
    address_id INT,
    FOREIGN KEY (address_id) REFERENCES addresses(address_id)
);

CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    email VARCHAR(50) NOT NULL
);

CREATE TABLE suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    email VARCHAR(50) NOT NULL,
    address_id INT,
    FOREIGN KEY (address_id) REFERENCES addresses(address_id)   
);

CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    method ENUM('В брой', 'Карта', 'Банков превод') NOT NULL
);

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    sku VARCHAR(50) NOT NULL UNIQUE,
    barcode VARCHAR(50),
    unit VARCHAR(20) NOT NULL,
    category_id INT,
    supplier_id INT,
    cost DECIMAL(10,2) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

CREATE TABLE warehouse (
    warehouse_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 0,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT,
    employee_id INT,
    order_date DATE NOT NULL,
    payment_id INT,
    shipping_address_id INT,
    status ENUM('В процес', 'Изпратена', 'Доставена', 'Отказана', 'Закъсняла') DEFAULT 'В процес',
    FOREIGN KEY (client_id) REFERENCES clients(client_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (payment_id) REFERENCES payments(payment_id),
    FOREIGN KEY (shipping_address_id) REFERENCES addresses(address_id)   
);

CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT,
    qty INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE shipping (
    shipping_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    courier VARCHAR(50) NOT NULL,
    shipping_price DECIMAL(10,2) NOT NULL,
    shipped_at DATE,
    delivered_at DATE,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE deliveries (
    delivery_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_id INT,
    product_id INT,
    qty INT NOT NULL,
    cost_price DECIMAL(10,2) NOT NULL,
    delivered_at DATE NOT NULL,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO addresses (street, city, postcode) VALUES
('ул. Иван Вазов 10', 'София', 1000),
('ул. Пирин 22', 'Пловдив', 4000),
('бул. Христо Ботев 15', 'Варна', 9000),
('ул. Бенковски 8', 'Бургас', 8000),
('ул. Искър 3', 'София', 1000),
('ул. Калиакра 9', 'Русе', 7000);

INSERT INTO clients (first_name, last_name, phone, email, address_id) VALUES
('Иван', 'Петров', '0888123456', 'ivan.petrov@gmail.com', 1),
('Мария', 'Георгиева', '0899123456', 'maria.geo@abv.bg', 2),
('Георги', 'Димитров', '0888333444', 'georgi.d@gmail.com', 3),
('Анна', 'Стоянова', '0877555666', 'anna.s@mail.bg', 4),
('Николай', 'Костов', '0899888777', 'nikolay.k@outlook.com', 5);

INSERT INTO employees (first_name, last_name, phone, email) VALUES
('Петър', 'Иванов', '0888000011', 'p.ivanov@smallbiz.bg'),
('Елена', 'Маринова', '0899000022', 'e.marinova@smallbiz.bg');

INSERT INTO suppliers (name, phone, email, address_id) VALUES
('TechSupply Ltd.', '029912233', 'contact@techsupply.com', 6),
('OfficePro', '024445555', 'sales@officepro.bg', 1),
('EcoFoods', '0888222333', 'info@ecofoods.bg', 2);

INSERT INTO categories (name) VALUES
('Електроника'),
('Офис материали'),
('Хранителни продукти');

INSERT INTO payments (method) VALUES
('В брой'),
('Карта'),
('Банков превод');

INSERT INTO products (name, sku, barcode, unit, category_id, supplier_id, cost, price) VALUES
('USB мишка Logitech', 'SKU001', '1234567890123', 'бр.', 1, 1, 25.00, 39.99),
('Клавиатура Logitech K120', 'SKU002', '1234567890456', 'бр.', 1, 1, 30.00, 49.99),
('Печатна хартия A4 500л', 'SKU003', '1234567890789', 'пакет', 2, 2, 4.50, 8.90),
('Папка с копче', 'SKU004', '1234567890111', 'бр.', 2, 2, 1.00, 2.20),
('Органичен мед 500g', 'SKU005', '1234567890222', 'бр.', 3, 3, 7.50, 12.90),
('Био чай от лайка', 'SKU006', '1234567890333', 'бр.', 3, 3, 3.00, 5.90);

INSERT INTO warehouse (product_id, quantity) VALUES
(1, 15),
(2, 5),
(3, 25),
(4, 8),
(5, 12),
(6, 3);

INSERT INTO orders (client_id, employee_id, order_date, payment_id, shipping_address_id, status) VALUES
(1, 1, '2024-01-15', 2, 1, 'Доставена'),
(2, 1, '2024-03-20', 1, 2, 'Доставена'),
(3, 2, '2024-06-12', 3, 3, 'Изпратена'),
(4, 2, '2024-07-01', 1, 4, 'В процес'),
(5, 1, '2023-12-05', 2, 5, 'Отказана'),
(1, 2, '2025-02-10', 1, 1, 'В процес'),
(3, 1, '2025-04-02', 2, 3, 'Доставена'),
(2, 2, '2025-05-15', 3, 2, 'Закъсняла'),
(4, 1, '2025-06-08', 1, 4, 'В процес'),
(5, 1, '2025-07-25', 2, 5, 'Изпратена');

INSERT INTO order_items (order_id, product_id, qty, unit_price) VALUES
(1, 1, 2, 39.99),
(1, 3, 1, 8.90),
(2, 2, 1, 49.99),
(3, 5, 3, 12.90),
(4, 6, 1, 5.90),
(5, 4, 10, 2.20),
(6, 1, 1, 39.99),
(7, 3, 2, 8.90),
(8, 2, 2, 49.99),
(9, 5, 1, 12.90),
(10, 6, 2, 5.90);

INSERT INTO deliveries (supplier_id, product_id, qty, cost_price, delivered_at) VALUES
(1, 1, 20, 25.00, '2023-09-15'),
(1, 2, 15, 30.00, '2024-02-10'),
(2, 3, 50, 4.50, '2024-04-01'),
(3, 5, 30, 7.50, '2025-01-12'),
(3, 6, 40, 3.00, '2022-11-20');

INSERT INTO shipping (order_id, courier, shipping_price, shipped_at, delivered_at) VALUES
(1, 'Econt', 5.00, '2024-01-16', '2024-01-17'),
(2, 'Speedy', 4.50, '2024-03-21', '2024-03-23'),
(3, 'Econt', 6.00, '2024-06-13', NULL),
(7, 'Econt', 5.00, '2025-04-03', '2025-04-05'),
(10, 'Speedy', 4.00, '2025-07-26', NULL);

SELECT email, phone, first_name, last_name FROM clients;
SELECT * FROM warehouse WHERE quantity < 10;
SELECT * FROM orders WHERE order_date >= DATE_SUB('2025-11-13', INTERVAL 10 MONTH);
SELECT * FROM products WHERE price > (SELECT AVG(price) FROM products);
SELECT first_name, last_name, city FROM clients, addresses WHERE addresses.city = 'София';
SELECT * FROM orders WHERE status <> 'Доставена';
SELECT DISTINCT name FROM orders, products WHERE order_date>= DATE_SUB('2025-11-13', INTERVAL 6 MONTH);
SELECT first_name, last_name FROM clients, orders WHERE count(client_id) > 5;

DROP DATABASE smallbusiness;