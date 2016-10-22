# TitanicClassifier
Titanic Survivors Classifier - Random Forests

## Introduction

> “The sinking of the RMS Titanic occurred on the night of 14 April through to the morning of 15 April 1912 in the north Atlantic Ocean, four days into the ship's maiden voyage from Southampton to New York City. The largest passenger liner in service at the time, Titanic had an estimated 2,224 people on board when she struck an iceberg at around 23:40 (ship's time) on Sunday, 14 April 1912. Her sinking two hours and forty minutes later at 02:20 (05:18 GMT) on Monday, 15 April resulted in the deaths of more than 1,500 people, which made it one of the deadliest peacetime maritime disasters in history.” - Wikipedia.

![alt text](https://github.com/mrquant/TitanicClassifier/blob/master/assets/titanic.png?raw=true "Titanic")

## Data Cleaning

At first, we are going to get rid of the unnecesary variables that will not contribute to the model. That variables are:
  * Name: because it’s a string.
  * Id: because the ID does not provide any valuable information, since it’s only metadata.
  * Ticket: it’s a string.
  * Cabin: it’s a string.
  
Besides, we are going to get rid of the rows that have missing values such as ‘ages’. The dataset has 891 rows at the beginning, and after filtering out the missing values we have ended up with 714 instances with which we will work from now on.

## Training Decision Tree

Once the dataset is clean, we can learn our first tree. For this task, we use the default training method. This is the resulting tree:

![alt text](https://github.com/mrquant/TitanicClassifier/blob/master/assets/tree2.png?raw=true "Tree1")

This is the imporatance given to the splitting variables: Sex > Pclass > Age > Fare > Parch.

As we can see, “women and children first!” is what predominates in the successive splits but mostly for those of a higher social class. Third class passengers did not have fair chances to survive due to several reasons: (1) there were many nationalities in third class passengers and most of them di not speak english, so they realized later of warnings and what was happening , (2) and they were treated worse than first class passengers.

> “Ship's regulations were designed to keep third class passengers confined to their area of the ship. The Titanic was fitted with grilles to prevent the classes from mingling and these gates were normally kept closed, although the stewards could open them in the event of an emergency. In the rush following the collision, the stewards, occupied with waking up sleeping passengers and leading groups of women and children to the boat deck, did not have time to open all the gates, leaving many of the confused third class passengers stuck below decks” - Titanic Passengers.

Regarding the classification tree, it does not change because the decision tree algorithm takes the decision of splitting data following a forward approach in which it looks for the variable to split that maximizize the grouping of the variable to be predicted. That is, the decision tree is a greedy algorithm that always goes for the quickest solution given the condition of maximizig the grouping instead of finding the optimal solution. However, it would change if we had generated again the training and partition sets due to the randomized way of the generation.

Besides, if we look at the R-squared of the decision tree, we can see how important is the first split (Sex variable) in the explanation of the Survivals, and how the successive splittings add less explanation. We can also see how the overfitting is avoided pruning the tree in the 6th split and leaving only a R-squared of 0.66.

![alt text](https://github.com/mrquant/TitanicClassifier/blob/master/assets/rsquare.png?raw=true "R-square")

The performance values for this training are:
  * Accuracy: 0.7865
  * Kappa: 0.5529
  * Sensitivity : 0.8091        
  * Specificity : 0.75 





