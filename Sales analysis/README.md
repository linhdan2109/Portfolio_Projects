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

In this stage, I will load the dataset into **Power BI** and use _Power Query and Dax fucntion_ to cleaning the data. Effective data cleaning is essential for obtaining meaningful insights and making informed decisions. Here's an overview of my data cleaning process:
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


### Create a Power BI dashboard


Creating an annual sales dashboard in Power BI can be a transformative endeavor, enabling us to gain deeper insights into our sales performance and trends over the course of a year. By meticulously crafting a dashboard that effectively presents key sales metrics, we can make informed decisions and optimize our business strategy. ([Click here to download the dashboard in Power BI](https://github.com/linhdan2109/Portfolio_Projects/blob/main/Sales%20analysis/Sales%20Dashboard.pbix))


_This is the annual sales dashboard in 2016_


![image](https://github.com/linhdan2109/Portfolio_Projects/assets/85982220/a05ad7bd-3a45-4c50-9dd3-7ae6df6bc2ed)


### Descriptive Analytics: Overall annual sales of ABC Shop in 2016
- _Performance metrics:_
  - _Total Sales:_ 1.96M USD (0.86% yoy increase)
  - _Total Profit:_ 0.72M USD (0.88% yoy decrease)
  - _Total Quantity:_ 7900 unit (3.19% yoy increase)
  - _Profit Margin:_ 0.37 (1.72% yoy decrease)
  - _Sales per Customer:_ 97.94K USD (0.86% yoy increase)
  - _Average Order Value:_ 1.25K USD (1.18% yoy increase)
-  _Sales by Channel:_  The wholesale channel demonstrates its prowess as a key revenue driver for the business (Account for 55% of the total sales)
- _Sales by customers:_ We can see that both total sales and profitability exhibit variations.
  - Total sales range from 70K to 130K USD
  - Total profit range from 27K to 49K USD
- _Sales by Products:_ Shoes are the top-selling product (288K USD), while dress shirts have the lowest revenue among the product (197K USD)
- _Sales by States:_ There is a disparity in sales across different states.
- _Sales by Month:_ The monthly sales figures fluctuate between 100K and 200K USD. There is an increase in sales during the months of March, June, and October.


The objective of sales analysis is to interpret sales data to gain insights into the performance, trends, and patterns of a business's sales activities. 


So we have to analyze this data futher to understand customer behavior, identify successful sales strategies, optimize sales processes, and make informed decisions. So that we can enhance overall sales performance and profitability.


### Diagnostic Analytics
### 1. Why Total Profit decrease in 2016 ?


The situation where sales go up but profits go down happens because even though some products are selling well and making more money, the decrease in profit from other products is more significant. 


Although the sell of some products are really well and bring in more money (Shoes, Sunglasses, Pants and Socks), the profit you make from those proct isn't enough to make up for the lower profit from other product (Shirt, Jeans, Hats and Dress Shirt).


Lets take a look at the two tables below


![image](https://github.com/linhdan2109/Portfolio_Projects/assets/85982220/ff17829e-a159-4dee-9b27-4821fb26f97c)


Now we can understand clearly about the decrese in profit in 2016. We observe that two products: Dress shirts and Hats, experienced a significant decrease in profit in the year 2016. 


&rarr; **So, why are there a significant decrease in profit Dress Shirt and Hats ?**


A decrease in profit can be attributed to either _a decline in sales_ or _an increase in the cost of goods sold (COGS)_. Let take a look closer at these factor in the two product:


_Case 1: Decrease in sales cause the decrease in profit_


![image](https://github.com/linhdan2109/Portfolio_Projects/assets/85982220/0df25a6e-5e82-4829-b684-801213048f64)


It is noted that there is a decrease ranging from 50K to 60K USD in the sales of the two items. 


_2. Case 2: Increase in COGS cause the decrease in profit_


![image](https://github.com/linhdan2109/Portfolio_Projects/assets/85982220/937a84bf-6c50-4376-8725-9034ab683456)


As you can see, in 2016 there are decrease in unit cost of two product. 


Therefore in summary, the majority of the profit decrease is caused by the decline in sales of two products.


&rarr; **So, is this decrease in sales occurring with specific customers or all customers?**


![image](https://github.com/linhdan2109/Portfolio_Projects/assets/85982220/11b78064-1ada-4422-898b-d327124608b1)


There is a decrease in sales of Dress Shirt and Hats across the majority of customers. We can proceed to examine macroeconomic factors that collectively influence the behavior of the majority of customers and devise appropriate strategies based on the findings.


&rarr; **What cause the decline in sales: _The decrease in order quantity or the decrease in unit price_?**


![image](https://github.com/linhdan2109/Portfolio_Projects/assets/85982220/2944b5c8-469e-4495-8262-d245c449c7aa)


_Hats Product:_ 
- In 2016, the number of products being sold has gone up (order quantity increase by 65 unit), but the price for each product has gone down (the unit price decline by 50 USD). This change has led to a decrease in overall profit.
- To address this issue, we can consider a few strategies:
  - Price Adjustment: Reassess pricing for Hats product. A slight increase in price could help maintain or even improve profit margins.
  - Cost Control: Examine the cost structure for products with reduced profitability. Look for opportunities to reduce production costs without compromising quality.
  - Upselling and Cross-Selling: Encourage customers to consider complementary or higher-value products (such as any accessories that go with Hats) through upselling and cross-selling techniques, which can help offset the impact of lower unit prices.
  - Customer Segmentation: Segment customers based on buying behaviors and preferences. This can help tailor marketing strategies and promotions to different customer groups, optimizing sales and profits.
  - Market Research: Conduct market research to understand why customers are responding to lower unit prices. This can help identify any shifts in customer preferences or market trends that may be influencing their purchasing decisions.
  - Product Differentiation: Focus on product differentiation and value-added features to justify higher prices for certain products. Highlighting unique selling points can support maintaining higher unit prices.
  - Promotion and Marketing: Adjust promotional strategies to focus on products with better profit margins. Highlight the value proposition of these products to attract customer attention.
  - Continuous Monitoring: Regularly monitor sales, pricing, and profit data to identify any changes in trends and take prompt action to address any potential negative impacts.


_Dress Shirt Product:_ 
- In 2016, the unit price decreases (the unit price decline by 28 USD) and the order quantity also declines (order quantity decrease by 129 unit) 
- Here are a few potential reasons for this phenomenon:
  - Price-Quality Perception: A significant decrease in unit price might lead customers to question the quality or value of the product. This can result in reduced demand, even though the product is more affordable.
  - Income Effect: If customers' income levels have decreased or remained stagnant, they might be more cautious about spending, leading to a decline in both quantity and order value.
  - Substitution Effect: Customers might opt for alternative products or brands that offer a better perceived value, even if the unit price of the original product decreases.
  - Marketing and Messaging: If the decrease in unit price is not effectively communicated through marketing campaigns or promotions, customers might not be aware of the price reduction and may continue with their usual buying behavior.
  - Change in Preferences: Shifts in customer preferences, seasonal demand changes, or evolving trends could contribute to reduced demand even with a lower unit price.
  - Competitor Actions: Competitor pricing strategies and marketing efforts can influence customers' decisions. If competitors offer better value or unique features, customers might still choose their products despite the lower unit price of your products.
  - Economic Factors: Broader economic conditions, inflation, or uncertainties about the future might influence customers to cut back on spending, resulting in reduced demand.
  - Lack of Trust: If customers have had negative experiences with the product or brand in the past, they might be hesitant to buy, even if the price has been lowered.
- To address this situation, it's important to analyze customer feedback, conduct market research, and gather insights on changing consumer preferences. By understanding the underlying reasons, businesses can implement appropriate strategies such as adjusting pricing, improving product communication, enhancing product quality, or addressing any other issues that are contributing to the decline in both unit price and order quantity.













































