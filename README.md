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

![alt text](https://github.com/mrquant/TitanicClassifier/blob/master/assets/rsquare.png?raw=true =200x200 "R-square")

The performance values for this training are:
  * Accuracy: 0.7865
  * Kappa: 0.5529
  * Sensitivity : 0.8091        
  * Specificity : 0.75 

Now, we automate the parameter tuning and also run 10-fold Cross Validation in the process of training in order to achieve a combination of parameters that yields a better performance. After obtaining different combinations of parameters we are going to focus on:
  * The Complexity Parameter (cp). In every split, the algorithm checks if the R-squared is improved more than cp and in that case it      splits. The main role of this parameter is to save computing time by pruning off splits that are obviously not worthwhile. Therefore, obtaining the optimal cp would safe computation time and also the possibility of overfitted trees.
  * The Cost. A vector of non-negative costs, one for each variable in the model. Defaults to one for all variables. These are scalings to be applied when considering splits, so the improvement on splitting on a variable is divided by its cost in deciding which split to choose.

Those are the different results obtained:

![alt text](https://github.com/mrquant/TitanicClassifier/blob/master/assets/accuracy_cp_all.png?raw=true =200x200)

Here we have trees that were pruned very soon. We can see the problem of a forward approach when splitting. In order to reduce overfitting and computation time, we are prunning the tree in every split checking the cp threshold without knowing if later splits are going to increase the accuracy, even though the current split doesn’t improve more than what we have stated in the cp parameter, this is known as the horizon effect (Wikipedia, Horizon Effect). Therefore, for the final parameters (pink line, Cost = 2), when cp= 0.04 or 0.07 the tree stops with an accuracy of ~0.79, but for cp=0.00, 0.01 or 0.02 the tree doesn’t stop and doesn’t prune some intermediate nodes, which don’t increase the accuracy, ending up in splittings that increase the accuracy to 0.81.

The final combination used is the default rpart() parameters (maxdepth = 30, minsplit=20, etc) plus cp = 0.00 and Cost = 2, which are the values obtained after the train() using 10-fold CV. The final tree is:

<img src="https://github.com/mrquant/TitanicClassifier/blob/master/assets/tree_10.png?raw=true" width="200" height="200">

  * Accuracy: 0.81
  * Kappa: 0.59



