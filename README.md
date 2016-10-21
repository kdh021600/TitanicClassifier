# TitanicClassifier
Titanic Survivors Classifier - Random Forests

## Introduction
> “The sinking of the RMS Titanic occurred on the night of 14 April through to the morning of 15 April 1912 in the north Atlantic Ocean, four days into the ship's maiden voyage from Southampton to New York City. The largest passenger liner in service at the time, Titanic had an estimated 2,224 people on board when she struck an iceberg at around 23:40 (ship's time) on Sunday, 14 April 1912. Her sinking two hours and forty minutes later at 02:20 (05:18 GMT) on Monday, 15 April resulted in the deaths of more than 1,500 people, which made it one of the deadliest peacetime maritime disasters in history.” - Wikipedia.

## Data Cleaning

At first, we are going to get rid of the unnecesary variables that will not contribute to the model. That variables are:
..*Name: because it’s a string.
..*Id: because the ID does not provide any valuable information, since it’s only metadata.
..*Ticket: it’s a string.
..*Cabin: it’s a string.
Besides, we are going to get rid of the rows that have missing values such as ‘ages’. The dataset has 891 rows at the beginning, and after filtering out the missing values we have ended up with 714 instances with which we will work from now on.
