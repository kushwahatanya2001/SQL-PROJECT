--create database
CREATE DATABASE onlinebookdb;

--switch to the database
\C onlinebookstore;

--create tables
DROP TABLE IF EXISTS BOOKS;
CREATE TABLE BOOKS(
 BOOK_ID SERIAL PRIMARY KEY,
 TITLE VARCHAR(100),
 AUTHOR VARCHAR(100),
 GENRE VARCHAR(50),
 PUBLISHED_YEAR INT,
 PRICE NUMERIC (10,2),
 STOCK INT
);

DROP TABLE IF EXISTS CUSTOMERS;
CREATE TABLE CUSTOMERS(
CUSTOMER_ID SERIAL PRIMARY KEY,
NAME VARCHAR(50),
EMAIL VARCHAR(100),
PHONE VARCHAR(50),
CITY VARCHAR(50),
COUNTRY VARCHAR(150)
);

DROP TABLE IF EXISTS ORDERS;
CREATE TABLE ORDERS(
ORDER_ID SERIAL PRIMARY KEY,
CUSTOMER_ID INT REFERENCES CUSTOMERS(CUSTOMER_ID),
BOOK_ID INT REFERENCES BOOKS(BOOK_ID),
ORDER_DATE DATE,
QUANTITY INT,
TOTAL_AMOUNT NUMERIC (10,2)
);

SELECT*FROM BOOKS;
SELECT*FROM CUSTOMERS;
SELECT* FROM ORDERS;

-- 1) retrieve all books in a "fiction" genre:
SELECT* FROM BOOKS 
WHERE GENRE='Fiction';

-- 2) find books published after the year 1950:
SELECT* FROM ORDERS
WHERE PUBLISHED_YEAR> 1950;

--3) list all customers from canada:
SELECT*FROM CUSTOMERS
WHERE COUNTRY='Canada';

--4) show the orders placed in November 2023:
SELECT*FROM orders
WHERE ORDER_DATE BETWEEN '2023-11-01'AND '2023-11-30';

--5) retrieve total stock of book available:
SELECT SUM(STOCK) AS TOTAL_STOCK
FROM BOOKS;

--6) find the detail of the most expensive book:
SELECT*FROM BOOKS 
ORDER BY PRICE DESC LIMIT 1;

--7) show all the customers who ordered more tha 1 quqntity of a book:
SELECT* FROM ORDERS
WHERE QUANTITY>1;

--8) retrieve all the orders where the total amount exceed $20:
SELECT* FROM ORDERS
WHERE TOTAL_AMOUNT>20;

--9) list all the genre available in book store:
SELECT DISTINCT GENRE
FROM BOOKS;

--10) find the book with the lowest stock:
SELECT* FROM BOOKS
ORDER BY STOCK
LIMIT 1;

--11) calculate the total revenue genrated from all the orders:
SELECT SUM(TOTAL_AMOUNT) AS TOTAL_REVENUE
FROM ORDERS;

--12) retrieve total number of books sold in each genre:
SELECT b.genre,SUM(o.quantity) AS TOTAL_BOOKS_SOLD
FROM ORDERS o
JOIN BOOKS b ON o.BOOK_ID = b.BOOK_ID
GROUP BY b.genre;

--12) find the average price of books in the "fantasy" genre:
SELECT AVG(PRICE) AS AVERAGE_PRICE
FROM BOOKS
WHERE GENRE='Fantasy';

--13) list the customers who have placed  at least 2 orders:
SELECT o.CUSTOMER_ID,c.name,COUNT(o.ORDER_ID)
FROM ORDERS o
JOIN CUSTOMERS c ON o.CUSTOMER_ID = c.CUSTOMER_ID
GROUP BY o.CUSTOMER_ID,c.name
HAVING COUNT(o.ORDER_ID)>=2;

--14) find the most frequently ordered book:
SELECT o.BOOK_ID, b.TITLE , COUNT(o.ORDER_ID)
FROM ORDERS o
JOIN BOOKS b on O. BOOK_ID = b.BOOK_ID
GROUP BY o.BOOK_ID ,b.TITLE
ORDER BY COUNT(ORDER_ID) DESC LIMIT 1;

--15) show the top 3 most expensive  books of 'fantasy' genre:
SELECT * FROM BOOKS
WHERE GENRE= 'Fantasy'
ORDER BY PRICE  DESC LIMIT 3;

--16) retrieve total quantity of books sold by each author:
SELECT b.AUTHOR,SUM(o.QUANTITY) AS TOTAL_QUANTITY
FROM ORDERS o
JOIN BOOKS b ON o.BOOK_ID= b.BOOK_ID
GROUP BY b.AUTHOR;

--17) list the cities where the customer spend over $30 are located:
SELECT DISTINCT c.CITY,o.TOTAL_AMOUNT
FROM ORDERS o
JOIN CUSTOMERS c ON o.CUSTOMER_ID= c.CUSTOMER_ID
WHERE o.TOTAL_AMOUNT>30;

--18) find the customers who spend the most on orders:
SELECT c.CUSTOMER_ID,c.NAME ,SUM(o.TOTAL_AMOUNT) AS TOTAL_SPEND
FROM ORDERS o
JOIN CUSTOMERS c ON o.CUSTOMER_ID= c.CUSTOMER_ID
GROUP BY c.CUSTOMER_ID,c.NAME
ORDER BY TOTAL_SPEND DESC;

--19) calculate the stock remaining after fullfilling all orders:
SELECT b.BOOK_ID,b.TITLE,b.STOCK, COALESCE(SUM(o.QUANTITY),0) AS ORDER_QUANTITY,
b.STOCK- COALESCE(SUM(o.QUANTITY),0) AS REMAINING_STOCK
FROM BOOKS b
LEFT JOIN ORDERS o on o.BOOK_ID= b.BOOk_ID
GROUP BY b.BOOK_ID
ORDER BY b.BOOK_ID;