# ANNUAL SALES ANALYSIS FOR ABC FASHION SHOP

## Introduction
This sales analysis project aims to uncover hidden trends and patterns within ABC Shop's sales data, ultimately helping the store optimize its operations and enhance customer satisfaction. Through meticulous analysis and strategic recommendations, we aim to facilitate the store's journey towards sustained growth and success in the competitive fashion industry.

## Objective
- **Segmentation:** Divide sales data into meaningful segments based on factors such as products, customer types, regions, sales channels, and time periods.
- **Performance Metrics:** Calculate important performance metrics such as YTD (Year to Date) Sales, YTD Profit, YTD Quantity, Profit Margin, Avvarage Sales per Customer and Avvarage Sales per Order.
- **Trend Analysis:** Identify sales trends over time, such as seasonal patterns, cyclical trends, and long-term growth or decline. This helps in forecasting and planning.
- **Comparative Analysis:** Compare sales performance across different product categories, customer segments, sales channels, and regions to identify areas of strength and areas needing improvement.
- **Customer Analysis:** Analyze customer behavior, preferences, purchasing patterns, and lifetime value. Identify most valuable and loyal customers.
- **Geographical Analysis:** Analyze sales performance across different regions to identify growth opportunities and adapt strategies based on local market trends.


## Data Review


**About the dataset** ([Data Source](https://github.com/linhdan2109/Portfolio_Projects/blob/main/Sales%20analysis/Sales.xlsx))
- This is a dataset about ABC fashion shop's sales data. It contains customer orders from 2012 to 2016.
- This data set is in .xlsx format and has 4 sheets: "Sales Orders", "Custormers", "Regions" and "Products".
  - Preview of _"Sales Orders"_ table: This table has 7994 observations and 12 atributes.


| OrderNumber | OrderDate | Customer Name Index | Channel     | Currency Code | Warehouse Code | Delivery Region Index | Product Description Index | Order Quantity | Unit Price | Line Total | Total Unit Cost  |
|-------------|-----------|---------------------|-------------|---------------|----------------|-----------------------|---------------------------|----------------|------------|------------|------------------|
| SO - 000101 | 1/1/2012  | 15                  | Distributor | AUD           | NXH382         | 41                    | 6                         | 3              | 218.12     | 654.37     | 111.24           |
| SO - 000102 | 1/2/2012  | 11                  | Wholesale   | AUD           | GUT930         | 31                    | 5                         | 8              | 437.73     | 3,501.87   | 372.07           |
| SO - 000103 | 1/2/2012  | 12                  | Export      | AUD           | GUT930         | 34                    | 5                         | 4              | 197.28     | 789.11     | 86.80            |
| SO - 000104 | 1/2/2012  | 6                   | Export      | AUD           | AXW291         | 17                    | 3                         | 2              | 258.32     | 516.64     | 162.74           |
| SO - 000105 | 1/2/2012  | 7                   | Wholesale   | AUD           | AXW291         | 18                    | 3                         | 3              | 202.49     | 607.47     | 164.02           |
| SO - 000106 | 1/2/2012  | 16                  | Wholesale   | AUD           | NXH382         | 45                    | 7                         | 3              | 115.39     | 346.17     | 49.62            |
| SO - 000107 | 1/3/2012  | 1                   | Distributor | AUD           | AXW291         | 1                     | 1                         | 2              | 132.51     | 265.02     | 59.63            |
| SO - 000108 | 1/3/2012  | 16                  | Distributor | AUD           | NXH382         | 45                    | 7                         | 3              | 201.74     | 605.23     | 169.47           |
| SO - 000109 | 1/3/2012  | 17                  | Wholesale   | AUD           | NXH382         | 48                    | 7                         | 3              | 431.03     | 1,293.10   | 245.69           |
| SO - 000110 | 1/3/2012  | 15                  | Wholesale   | AUD           | NXH382         | 42                    | 6                         | 2              | 217.38     | 434.76     | 134.77           |
| SO - 000111 | 1/3/2012  | 1                   | Export      | AUD           | AXW291         | 3                     | 1                         | 5              | 22.33      | 111.67     | 13.85            |
| SO - 000112 | 1/4/2012  | 9                   | Distributor | AUD           | AXW291         | 25                    | 4                         | 9              | 697.54     | 6,277.90   | 306.92           |
| SO - 000113 | 1/4/2012  | 18                  | Export      | AUD           | NXH382         | 51                    | 7                         | 1              | 116.88     | 116.88     | 71.30            |
| SO - 000114 | 1/4/2012  | 16                  | Export      | AUD           | NXH382         | 46                    | 7                         | 3              | 28.29      | 84.87      | 24.05            |
| SO - 000115 | 1/4/2012  | 8                   | Distributor | AUD           | AXW291         | 22                    | 3                         | 8              | 436.99     | 3,495.91   | 349.59           |
| SO - 000116 | 1/4/2012  | 20                  | Wholesale   | AUD           | FLR025         | 56                    | 8                         | 2              | 123.58     | 247.16     | 77.85            |
| SO - 000117 | 1/4/2012  | 18                  | Wholesale   | AUD           | NXH382         | 51                    | 7                         | 6              | 137.72     | 826.33     | 100.54           |
| SO - 000118 | 1/4/2012  | 2                   | Export      | AUD           | AXW291         | 4                     | 1                         | 3              | 109.43     | 328.30     | 43.77            |
| ...         | ...       | ...                 | ...         | ...           | ...            | ...                   | ...                       | ...            | ...        | ...        | ...              |




 - Preview of _"Customer"_ table: This table has 20 observations and 2 atributes.


| Customer Index | Customer Names  |
|----------------|-----------------|
| 1              | Avon Corp       |
| 2              | WakeFern        |
| 3              | Elorac, Corp    |
| 4              | ETUDE Ltd       |
| 5              | Procter Corp    |
| 6              | PEDIFIX, Corp   |
| 7              | New Ltd         |
| 8              | Medsep Group    |
| 9              | Ei              |
| 10             | 21st Ltd        |
| 11             | Apollo Ltd      |
| 12             | Medline         |
| 13             | Ole Group       |
| 14             | Linde           |
| 15             | Rochester Ltd   |
| 16             | 3LAB, Ltd       |
| 17             | Pure Group      |
| 18             | Eminence Corp   |
| 19             | Qualitest       |
|20              | Pacific Ltd     |



  - Preview of _"Regions"_ table: This table has 58 observations and 5 atributes.


| Index | Territory       | City           | Country   | Full                                        |
|-------|-----------------|----------------|-----------|---------------------------------------------|
| 1     | New South Wales | Sydney         | Australia | Sydney, New South Wales, Australia          |
| 2     | New South Wales | Albury         | Australia | Albury, New South Wales, Australia          |
| 3     | New South Wales | Armidale       | Australia | Armidale, New South Wales, Australia        |
| 4     | New South Wales | Bathurst       | Australia | Bathurst, New South Wales, Australia        |
| 5     | New South Wales | Broken Hill    | Australia | Broken Hill, New South Wales, Australia     |
| 6     | New South Wales | Cessnock       | Australia | Cessnock, New South Wales, Australia        |
| 7     | New South Wales | Coffs Harbour  | Australia | Coffs Harbour, New South Wales, Australia   |
| 8     | New South Wales | Dubbo          | Australia | Dubbo, New South Wales, Australia           |
| 9     | New South Wales | Gosford        | Australia | Gosford, New South Wales, Australia         |
| 10    | New South Wales | Goulburn       | Australia | Goulburn, New South Wales, Australia        |
| 11    | New South Wales | Grafton        | Australia | Grafton, New South Wales, Australia         |
| 12    | New South Wales | Griffith       | Australia | Griffith, New South Wales, Australia        |
| 13    | New South Wales | Lake Macquarie | Australia | Lake Macquarie, New South Wales, Australia  |
| 14    | New South Wales | Lismore        | Australia | Lismore, New South Wales, Australia         |
| 15    | New South Wales | Maitland       | Australia | Maitland, New South Wales, Australia        |
| 16    | New South Wales | Newcastle      | Australia | Newcastle, New South Wales, Australia       |
| 17    | New South Wales | Nowra          | Australia | Nowra, New South Wales, Australia           |
| 18    | New South Wales | Orange         | Australia | Orange, New South Wales, Australia          |
| ...   | ...             | ...            | ...       | ...                                         |



  - Preview of _"Products"_ table: This table has 8 observations and 2 atributes.

| Index | Product Name  |
|-------|---------------|
| 1     | Shirts        |
| 2     | Pants         |
| 3     | Sunglasses    |
| 4     | Jeans         |
| 5     | Hats          |
| 6     | Socks         |
| 7     | Dress Shirts  |
| 8     | Shoes         |


 ## Data Cleaning 

In this stage, I will load the dataset into Power BI and use Power Query and Dax fucntion to cleaning the data.Effective data cleaning is essential for obtaining meaningful insights and making informed decisions. Here's an overview of my data cleaning process:
- Remove missing values if there are any.
- Remove duplicates if there are any.
- Make sure the data is in the correct data type.
- Correct inconsistencies in data, such as typos, variations in capitalization, or discrepancies in categorical values.
- Create _'Profit'_ column useful for analysis.
- Create new metrics such as _'Sales Last Year', 'Profit Last Year', ..._ for analysis.
- Create a _'Date'_ table to reference dates in your model and analyze data based on these dates.
- Remove columns that is not informative.


## Data Modeling


Data Modeling is one of the features used to connect multiple data sources in BI tool using a relationship. A relationship defines how data sources are connected with each other and you can create interesting data visualizations on multiple data sources.


_Here is our Data Model_

![image](https://github.com/linhdan2109/Portfolio_Projects/assets/85982220/4c4cb8dd-c452-4ed7-9b25-66194f598e2a)



 ## Data analysis


**Create a Power BI dashboard**


Creating an annual sales dashboard in Power BI can be a transformative endeavor, enabling us to gain deeper insights into our sales performance and trends over the course of a year. By meticulously crafting a dashboard that effectively presents key sales metrics, we can make informed decisions and optimize our business strategy. ([Click here to download the dashboard in Power BI](https://github.com/linhdan2109/Portfolio_Projects/blob/main/Sales%20analysis/Sales%20Dashboard.pbix))


_This is the annual sales dashboard in 2016_


![image](https://github.com/linhdan2109/Portfolio_Projects/assets/85982220/a05ad7bd-3a45-4c50-9dd3-7ae6df6bc2ed)








