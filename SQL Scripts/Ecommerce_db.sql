use e_commerce;
SHOW TABLES;
#check data
SELECT * FROM Customers LIMIT 10;
SELECT * FROM Products LIMIT 10;
SELECT * FROM Categories LIMIT 10;
SELECT * FROM Orders LIMIT 10;
SELECT * FROM Payments LIMIT 10;
#Verify the Number of Records
SELECT COUNT(*) FROM Customers;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM categories;
select count(*) from orders;
select count(*) from payments;
# Add Primary Keys
ALTER TABLE Customers
ADD PRIMARY KEY (customer_id);

ALTER TABLE Products
ADD PRIMARY KEY (product_id);

ALTER TABLE Categories
ADD PRIMARY KEY (category_id);

ALTER TABLE Orders
ADD PRIMARY KEY (order_id);

ALTER TABLE Payments
ADD PRIMARY KEY (payment_id);
# Add Foreign Keys
ALTER TABLE Products
ADD CONSTRAINT fk_products_category
FOREIGN KEY (category_id)
REFERENCES Categories(category_id);
ALTER TABLE Orders
ADD CONSTRAINT fk_orders_customer
FOREIGN KEY (customer_id)
REFERENCES Customers(customer_id);
ALTER TABLE Orders
ADD CONSTRAINT fk_orders_product
FOREIGN KEY (product_id)
REFERENCES Products(product_id);
ALTER TABLE Payments
ADD CONSTRAINT fk_payments_order
FOREIGN KEY (order_id)
REFERENCES Orders(order_id);
# to check overall data
select * from customers;
select * from orders;
select * from payments;
select * from products;
select * from categories;
# Total revenue
SELECT SUM(total_amount) AS Total_Revenue
FROM Orders;
#Average order value
SELECT AVG(total_amount) AS Avg_Order_Value
FROM Orders;
#Highest order amount
SELECT MAX(total_amount) AS Highest_Order
FROM Orders;
#Orders above ₹5000
SELECT *
FROM Orders
WHERE total_amount > 5000;
#Customers from Hyderabad
SELECT *
FROM Customers
WHERE city='Hyderabad';
#Orders in January
SELECT *
FROM Orders
WHERE MONTH(order_date)=1;
#Completed payments
SELECT *
FROM Payments
WHERE payment_status='Completed';
#Revenue by customer
SELECT
customer_id,
SUM(total_amount) Revenue
FROM Orders
GROUP BY customer_id;
#Orders by city
SELECT
city,
COUNT(*) Customers
FROM Customers
GROUP BY city;
#Products by category
SELECT
category_id,
COUNT(*) Products
FROM Products
GROUP BY category_id;
#Monthly revenue
SELECT
MONTH(order_date) Month,
SUM(total_amount) Revenue
FROM Orders
GROUP BY MONTH(order_date);
#Payment method count
SELECT
payment_method,
COUNT(*) Total
FROM Payments
GROUP BY payment_method;
#Customers spending more than ₹20,000
SELECT
customer_id,
SUM(total_amount) Revenue
FROM Orders
GROUP BY customer_id
HAVING Revenue>20000;
#Products sold more than 20 units
SELECT
product_id,
SUM(quantity) Qty
FROM Orders
GROUP BY product_id
HAVING Qty>20;
#Customer names with orders
SELECT
c.customer_name,
o.order_id,
o.total_amount
FROM Customers c
JOIN Orders o
ON c.customer_id=o.customer_id;
#Product names with orders
#Category revenue
SELECT
c.category_name,
SUM(o.total_amount) Revenue
FROM Categories c
JOIN Products p
ON c.category_id=p.category_id
JOIN Orders o
ON p.product_id=o.product_id
GROUP BY c.category_name;
#Customers without orders
SELECT
c.customer_name
FROM Customers c
LEFT JOIN Orders o
ON c.customer_id=o.customer_id
WHERE o.order_id IS NULL;
#Products never sold
SELECT
p.product_name
FROM Products p
LEFT JOIN Orders o
ON p.product_id=o.product_id
WHERE o.order_id IS NULL;
#Top 10 customers
SELECT
    c.customer_id,
    c.customer_name,
    SUM(o.total_amount) AS Revenue
FROM Orders o
INNER JOIN Customers c
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
ORDER BY Revenue DESC
LIMIT 10;
#Top products
SELECT
    p.product_id,
    p.product_name,
    p.price,
    SUM(o.quantity) AS Qty
FROM Orders o
INNER JOIN Products p
    ON p.product_id = o.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.price
ORDER BY Qty DESC limit 10;
#Customer type
SELECT
c.customer_id,c.customer_name,
SUM(o.total_amount) Revenue,
CASE
WHEN SUM(o.total_amount)>50000 THEN 'Premium'
WHEN SUM(o.total_amount)>20000 THEN 'Gold'
ELSE 'Regular'
END Customer_Type
FROM customers c inner join orders o on c.customer_id=o.customer_id
GROUP BY c.customer_id;
#Customers above average spending
SELECT *
FROM Orders o inner join customers c on o.customer_id=c.customer_id
WHERE total_amount>
(
SELECT AVG(total_amount)
FROM Orders
);
#Most expensive product
SELECT *
FROM Products
WHERE price>
(
SELECT avg(price)
FROM Products
);
SELECT *
FROM Products
WHERE price=
(
SELECT MAX(price)
FROM Products
);
#High-value customers
WITH Revenue AS
(
SELECT
c.customer_id,c.customer_name,
SUM(o.total_amount) Revenue
FROM customers c inner join orders o on c.customer_id=o.customer_id
GROUP BY c.customer_id
)

SELECT *
FROM Revenue
WHERE Revenue>30000;
#Yearly sales
SELECT
YEAR(order_date),
SUM(total_amount)
FROM Orders
GROUP BY YEAR(order_date);
#Monthly sales
SELECT
MONTHNAME(order_date),
SUM(total_amount)
FROM Orders
GROUP BY MONTH(order_date),
MONTHNAME(order_date)
ORDER BY MONTH(order_date);
 #Daily sales
 select date(order_date),sum(total_amount)
 from orders group by date(order_date) order by date(order_date) desc limit 10;
 #Revenue by payment method
 SELECT
payment_method,
SUM(payment_amount) Revenue
FROM Payments
GROUP BY payment_method;
#Revenue by state
SELECT
c.state,
SUM(o.total_amount) Revenue
FROM Customers c
JOIN Orders o
ON c.customer_id=o.customer_id
GROUP BY c.state;
#Top 5 categories
 SELECT
ca.category_name,
SUM(o.total_amount) Revenue
FROM Categories ca
JOIN Products p
ON ca.category_id=p.category_id
JOIN Orders o
ON p.product_id=o.product_id
GROUP BY ca.category_name
ORDER BY Revenue DESC
LIMIT 5;
 #Average quantity ordered
 SELECT AVG(quantity)
FROM Orders;
#average discount given
SELECT avg(discount)
FROM Orders;
#Highest revenue city
SELECT
c.city,
SUM(o.total_amount) Revenue
FROM Customers c
JOIN Orders o
ON c.customer_id=o.customer_id
GROUP BY c.city
ORDER BY Revenue DESC
LIMIT 1;
#Customers with more than 10 orders
select 
c.customer_id,c.customer_name,
count(*) order_count from customers c
inner join orders o on c.customer_id =o.customer_id
group by c.customer_id having order_count>10;
#Average product price by category
SELECT
category_id,product_name,
AVG(price) Average_Price
FROM Products
GROUP BY category_id,product_name;
#revenue by month and category
SELECT
MONTH(o.order_date) AS Month,
c.category_name,
SUM(o.total_amount) AS Revenue
FROM Orders o
JOIN Products p ON o.product_id = p.product_id
JOIN Categories c ON p.category_id = c.category_id
GROUP BY MONTH(o.order_date), c.category_name
ORDER BY Month, Revenue DESC;


