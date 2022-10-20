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
