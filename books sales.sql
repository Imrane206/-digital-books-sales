use sales;

create table book_sales(
indexx int,	
publishing_year float,	
book_name varchar(255),	
author varchar(455),	
language_code varchar(255),	
author_rating varchar(255),	
book_average_rating	float,
book_ratings_count int,	
genre varchar(255),	
gross_sales	float,
publisher_revenue float,	
sale_price float,	
sales_rank int,	
Publisher varchar(255),	
units_sold int
);


LOAD DATA INFILE 'C:/ProgramData/MySQL/Books_Data_Clean.csv' INTO TABLE book_sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


select book_name , publishing_year , book_ratings_count
from book_sales
where book_name is not null
order by  book_ratings_count desc
limit 10;

#count of each genre

select genre, count(*) as genre_count
from book_sales
where genre is not null
group by genre
order by count(*) desc;


#the top ranked books by unit_sold

select book_name, sales_rank , units_sold
from book_sales
limit 10;

#ranking books by each author_rating, top 5 of each author_level

WITH rnk_bookby_authorlevel as (select author_rating, book_name, book_average_rating,
DENSE_RANK() OVER(PARTITION BY author_rating order by book_average_rating desc) as rank_by_author_level
from book_sales
where book_name is not null)
select* from rnk_bookby_authorlevel
where rank_by_author_level=1;

#if you want to read a book I recommand you to read 'the foundation trilogy' ,'words of radiance', 'voyager','last sacrifice' my data analysis say these hhhhh 

#ranking the publisher corporation depending of the most book sold 

select publisher , sum(units_sold) as total_unit_sold
FROM book_sales
group by publisher
order by sum(units_sold) desc;

#the average sale price of each publisher 

select publisher , ROUND(avg(sale_price),2) as avg_sale_price
from book_sales
group by publisher 
order by avg(sale_price) desc;

#the average rating of each publisher 

select publisher , ROUND(avg(book_average_rating),2) AS avg_rating
from book_sales
group by publisher 
order by ROUND(avg(book_average_rating),2) desc;

#the average rating count of each publisher 

select publisher , ROUND(avg(book_ratings_count),2) AS avg_rating_count
from book_sales
group by publisher 
order by ROUND(avg(book_ratings_count),2) desc;

#the top 1 book by rating count of each publisher 

with rnk_rating_book as (select publisher, book_name , book_ratings_count, 
dense_rank() over(partition by publisher order by book_ratings_count desc) as rnk_rating_count
from book_sales
where book_name is not null)

select* from rnk_rating_book
where rnk_rating_count=1;

#the top 1 book by gross sales of each publisher corporation

with rnk_selling_book as (select publisher, book_name , gross_sales, 
dense_rank() over(partition by publisher order by gross_sales desc) as rnk_selling_revenue
from book_sales
where book_name is not null)

select* from rnk_selling_book
where rnk_selling_revenue=1;

#the most selling book of each publisher corporation 

with rnk_selling_book as (select publisher, book_name , units_sold, 
dense_rank() over(partition by publisher order by units_sold  desc) as rnk_selling_book
from book_sales
)

select* from rnk_selling_book
where rnk_selling_book=1;

#the lowest book sold of each publisher 

with rnk_selling_book as (select publisher, book_name , units_sold, 
dense_rank() over(partition by publisher order by units_sold  asc) as rnk_selling_book
from book_sales
)

select* from rnk_selling_book
where rnk_selling_book=1;







