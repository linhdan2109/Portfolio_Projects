# The Six Data Analysis Phases

## 1. Ask
### Identify the business task:
- Focus on a Bellabeat product:"Bellabeat membership" and analyze smart device usage data in order to gain insight into how people are already using their smart devices. 
- Then, using this information, make high-level recommendations for how these trends can inform Bellabeat marketing strategy for the "Bellabeat membership" 
product. 

### Questions to Analyze:
1. What are some trends in smart device usage?
2. How could these trends apply to Bellabeat customers?
3. How could these trends help influence Bellabeat marketing strategy?

## 2. Prepare
### Data Source:
Use public data that explores smart device users’ daily habits: [FitBit Fitness Tracker Data](https://www.kaggle.com/datasets/arashnic/fitbit). 
The data has been made available by [Mobius](https://www.kaggle.com/arashnic)
### Data organization:
- File naming convention: [time unit][measurement item][data format]__merged
- Content: Each file contains 3 main parts: Id, ActivityTime, measurement results.
### The credibility of the data
This Kaggle data set contains personal fitness tracker from thirty fitbit users. Thirty eligible Fitbit users consented to the submission of
personal tracker data, including minute-level output for physical activity, heart rate, and sleep monitoring. It includes
information about daily activity, steps, and heart rate that can be used to explore users’ habits

## 3. Process
I have used Microsoft Excel and SQL for data validation and cleaning.
### Microsoft Excel
- By scanning through data in Excel worksheet, the general outline and basic information can be found which enable me to get familiarize with the dataset
- Use Filter in Excel to check if there are any invalid/ incorrect / unusable data data in every columns. I don't seen any invalid data.
- Use Conditional Formatting to check if there are any NULL values. 
![image](https://user-images.githubusercontent.com/85982220/196919581-d7d24531-86db-414b-ae53-4a76d70c5a3a.png)
- Use Soft in Excelt to soft the data by Id and ActivityTime to make it easier to read and easier to understand the data.
- Use Remove Duplicates in Power Query in Excel to check duplicates and remove it. I don't see any duplicate.
![image](https://user-images.githubusercontent.com/85982220/196922975-5e6e3284-c8bf-4f59-a75d-44a92540c10d.png)
![image](https://user-images.githubusercontent.com/85982220/196923014-a1ffa533-93dc-4f87-9399-d0cbd52bb482.png)
### SQL
- [Click here](https://github.com/linhdan2109/Portfolio_Projects/blob/main/Google%20Data%20Analytics%20Professional%20Certificate%20Capstone%20Project/SQL_ProcessPharse.sql) to see the code of SQL in this process step.
- Load some tables that will be used for the Analysis pharse into SSMS. There are 6 tables that will be used, and they are stored in the database name 'Bellabeat'.

  ![image](https://user-images.githubusercontent.com/85982220/196999858-993f1995-a939-436f-94ee-6e5782edaa1a.png)

- View table schema of 6 tables: We can see the data type of every columns and the table doesn't have any NULL values
![image](https://user-images.githubusercontent.com/85982220/197016878-c4610588-c52c-4b58-b84d-d69720c0ba20.png)

- View a number of rows in the dailyActivity_merged table
![image](https://user-images.githubusercontent.com/85982220/197001812-ecbf2a14-e48b-42df-91cd-577cfca2d7f2.png)
- Size of the tables. The dailyActivity_merged table have 940 records, The hourlyCalories have 22099 records,...


   ![image](https://user-images.githubusercontent.com/85982220/197015373-ef7c024d-bcb1-44fa-8e40-412f594ee362.png)
- As the author says, the data is collected from 3/12/2016 - 5/12/2016. So I will check if the date in the dateset fit their meaning.
The result shows that there are no data points that are outside the range from 3/12/2016 to 5/12/2016.


   ![image](https://user-images.githubusercontent.com/85982220/197007439-6a897606-6d4f-4c9f-a08f-61fedebe2e33.png)
-  As the author says, the data is collected from 30 users. Check to see if we have 30 users. The dataset has 33 user data from daily activity, 24 from sleep and only 8 from weight. The result shows the dataset is inconsistent as we expect 30 unique Id on all tables.


   ![image](https://user-images.githubusercontent.com/85982220/197012238-dcced94a-3549-44f1-9d68-8b61d3ebce1a.png)

- Records which are dubplicate. The result shows that there are no duplicate


   ![image](https://user-images.githubusercontent.com/85982220/197008764-83b8dd02-b0b4-4352-a638-a74b17a7a60f.png)
- Add a column for day of the week


   ![image](https://user-images.githubusercontent.com/85982220/197024916-ebd482dc-4c89-4a6e-ac51-2964ce7a7a22.png)

## 4. Analyze



