# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Data_Analyst_Beginner  
**Level**: Beginner  
**Database**: `p1_retail_db`

Proyek ini dirancang untuk mendemonstrasikan keterampilan dan teknik SQL yang biasanya digunakan oleh analis data untuk mengeksplorasi, membersihkan, dan menganalisis data penjualan ritel. Proyek ini melibatkan pengaturan basis data penjualan ritel, melakukan analisis data eksplorasi (EDA), dan menjawab pertanyaan bisnis spesifik melalui kueri SQL. Proyek ini dibuat sebagai portofolio saya sebagai Data Analyst untuk menunjukkan kemampuan dalam analisis data dan penguasaan SQL.

## Objectives

1. **Set up a retail sales database**: Membuat dan mengisi database penjualan ritel dengan data penjualan yang disediakan.
2. **Data Cleaning**: Mengidentifikasi dan menghapus catatan yang hilang atau bernilai nol.
3. **Exploratory Data Analysis (EDA)**: Melakukan analisis data eksplorasi dasar untuk memahami kumpulan data.
4. **Business Analysis**: Gunakan SQL untuk menjawab pertanyaan bisnis spesifik dan mendapatkan wawasan dari data penjualan.

## Project Structure

### 1. Database Setup

- **Database Creation**: Proyek dimulai dengan membuat sebuah database bernama `p1_retail_db`.
- **Table Creation**: Sebuah tabel bernama `retail_sales` dibuat untuk menyimpan data penjualan. Struktur tabel mencakup kolom untuk ID transaksi, tanggal penjualan, waktu penjualan, ID pelanggan, jenis kelamin, usia, kategori produk, jumlah yang terjual, harga per unit, harga pokok penjualan (HPP), dan jumlah total penjualan.

```sql
CREATE DATABASE p1_retail_db;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP 
    BY 
    category,
    gender
ORDER BY 1
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift
```

## Findings

- **Customer Demographics**: Dataset ini mencakup pelanggan dari berbagai kelompok usia, dengan penjualan yang didistribusikan di berbagai kategori seperti Pakaian dan Kecantikan.
- **High-Value Transactions**: Beberapa transaksi memiliki jumlah total penjualan lebih dari 1000, yang mengindikasikan pembelian premium.
- **Sales Trends**: Analisis bulanan menunjukkan variasi dalam penjualan, membantu mengidentifikasi musim puncak.
- **Customer Insights**: Analisis mengidentifikasi pelanggan dengan pembelanjaan tertinggi dan kategori produk yang paling populer.

## Reports

- **Sales Summary**: Laporan terperinci yang merangkum total penjualan, demografi pelanggan, dan kinerja kategori
- **Trend Analysis**: Wawasan tentang tren penjualan di berbagai bulan dan shift.
- **Customer Insights**: Laporan tentang pelanggan teratas dan jumlah pelanggan unik per kategori.

## Conclusion

Proyek ini berfungsi sebagai pengenalan komprehensif terhadap SQL untuk analis data, yang mencakup penyiapan basis data, pembersihan data, analisis data eksploratif, dan kueri SQL yang digerakkan oleh bisnis. Temuan dari proyek ini dapat membantu mendorong keputusan bisnis dengan memahami pola penjualan, perilaku pelanggan, dan kinerja produk.


## Author - Muhammad Ridho Nurhayoto

Proyek ini adalah bagian dari portofolio saya, yang menunjukkan keterampilan SQL yang penting untuk peran analis data. 

### Contact

- **Instagram**: [Follow me for daily tips and updates](https://www.instagram.com/nurhayoto10/)
- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/muhammad-ridho-nurhayoto-0921b1324/)


Thank you for your support, and I look forward to connecting with you!
