--Beginner

--1.List the top 10 orders with the highest sales from the EachOrderBreakdown table.
Select * from EachOrderBreakdown ORDER BY Sales DESC 
OFFSET 0 ROWS FETCH FIRST 10 ROWS ONLY;

--2.Show the number of orders for each product category in the EachOrderBreakdown table.

Select Catergory,COUNT(*) AS NumberOfOrders from EachOrderBreakdown Group BY Catergory;

--3.Find the total profit for each sub-category in the EachOrderBreakdown table.

Select SubCategory,SUM(Profit) AS TotalProfit from EachOrderBreakdown Group BY SubCategory Order BY TotalProfit DESC;


--Intermediate

--1.Identify the customer with the highest total sales across all orders.
SELECT  TOP 1 a.CustomerName, SUM(b.sales) AS TotalSales
FROM OrdersList AS a
JOIN EachOrderBreakdown AS b ON a.OrderID = b.OrderID
GROUP BY a.CustomerName ORDER BY TotalSales DESC ;

--2.Find the month with the highest average sales in the OrdersList table.

SELECT TOP 1 Month(OrderDate) as Month, AVG(sales) AS Avg_Sale from OrdersList a join EachOrderBreakdown b
ON a.OrderID=b.OrderID  Group BY Month(OrderDate) ORDER BY Avg_Sale DESC 

--3.Find out the average quantity ordered by customers whose first name starts with an alphabet 's'?

Select AVG(Quantity) as Avg_Quantity from OrdersList a join EachOrderBreakdown b
ON a.OrderID=b.OrderID 
WHERE LEFT(a.CustomerName,1)= 'S'


--Advanced
--1.Find out how many new customers were acquired in the year 2014?
Select COUNT(*) from (SELECT CustomerName,MIN(OrderDate) AS FirstOrderDate from OrdersList 
GROUP BY CustomerName HAVING YEAR(MIN(OrderDate)) = '2014' ) AS a


--2.Calculate the percentage of total profit contributed by each sub-category to the overall profit.
SELECT SubCategory, (SUM(Profit)/(SELECT SUM(Profit) from EachOrderBreakdown))*100 as Profit_Percentage from EachOrderBreakdown Group by SubCategory;

--3.Find the average sales per customer, considering only customers who have made more than one order.

WITH CustomerAvgSales AS(
SELECT CustomerName,COUNT(DISTINCT(ol.OrderID)) AS NumberOfOrders,AVG(Sales) AS AvgSales 
From OrdersList ol JOIN EachOrderBreakDown ob ON
ol.OrderID = ob.OrderID 
GROUP BY CustomerName 
)
SELECT CustomerName,AvgSales FROM CustomerAvgSales WHERE NumberOfOrders>1

--4.Identify the top-performing subcategory in each category based on total sales. Include the sub-category name, total sales, 
--and a ranking of sub-category within each category.

SELECT Catergory,SubCategory,SUM(Sales) as TotalSales,
RANK() OVER(PARTITION BY Catergory ORDER BY SUM(Sales) DESC) AS SubCategoryRank
FROM EachOrderBreakdown
GROUP BY Catergory,SubCategory