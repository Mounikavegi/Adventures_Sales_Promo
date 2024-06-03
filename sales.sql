-- Cleansed DIM_Customers Table --
SELECT 
  c.customerkey AS CustomerKey, 
  c.firstname AS [First Name], 
  c.lastname AS [Last Name], 
  c.firstname + ' ' + lastname AS [Full Name], 
  -- Combined First and Last Name
  CASE c.gender WHEN 'M' THEN 'Male' WHEN 'F' THEN 'Female' END AS Gender,
  c.datefirstpurchase AS DateFirstPurchase, 
  G.City -- Joined in Customer City from Geography Table
FROM dbo.DimCustomer AS C
  INNER JOIN dbo.DimGeography AS G
  ON C.GeographyKey=G.GeographyKey 
ORDER BY 
  CustomerKey ASC -- Ordered List by CustomerKey
------------------------------------------------
-- Cleansed DIM_Date Table --
SELECT 
  [DateKey], 
  [FullDateAlternateKey] AS Date, 
  [EnglishDayNameOfWeek] AS Day, 
  [EnglishMonthName] AS Month, 
  Left([EnglishMonthName], 3) AS MonthShort,   -- Useful for front end date navigation and front end graphs. 
  [MonthNumberOfYear] AS MonthNo, 
  [CalendarQuarter] AS Quarter, 
  [CalendarYear] AS Year --[CalendarSemester], 
FROM  dbo.DimDate
where CalendarYear >=2020
------------------------------------------------
-- Cleansed FACT_Sales Table --
SELECT 
  [ProductKey], 
  [OrderDateKey], 
  [DueDateKey], 
  [ShipDateKey], 
  [CustomerKey], 
  [SalesOrderNumber],
  [SalesAmount] --  ,
FROM dbo.FactInternetSales
WHERE LEFT (OrderDateKey,4) >= YEAR(GETDATE()) -3 -- Ensures we always only bring two years of date from extraction.
ORDER by OrderDateKey ASC
------------------------------------------------
-- Cleansed DIM_Products Table --
SELECT 
  p.[ProductKey], 
  p.[ProductAlternateKey] AS ProductItemCode, 
  p.[EnglishProductName] AS [Product Name], 
  ps.EnglishProductSubcategoryName AS [Sub Category], -- Joined in from Sub Category Table
  pc.EnglishProductCategoryName AS [Product Category], -- Joined in from Category Table
  p.[Color] AS [Product Color], 
  p.[Size] AS [Product Size], 
  p.[ProductLine] AS [Product Line],
  p.[ModelName] AS [Product Model Name], 
  p.[EnglishDescription] AS [Product Description],
  ISNULL (p.Status, 'Outdated') AS [Product Status] 
FROM dbo.DimProduct as p
  LEFT JOIN dbo.DimProductSubcategory AS ps ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
  LEFT JOIN dbo.DimProductCategory AS pc ON ps.ProductCategoryKey = pc.ProductCategoryKey 
order by 
  p.ProductKey asc
