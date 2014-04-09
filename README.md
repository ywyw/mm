mm
==

  March Madness prediction in Matlab, should work in R2007b onwards, written for a personal project in a span of about 10 days, includes novel mathematical handling of neutral as well as home/away games and a tournament tree model

Uses Bradley-Taylor iterative algorithm to find minimum expected value of binomial deviance objective.  From regular season results, I build an adjancency matrix of victories, using logistic growth to scale victories, with recent victories worth more than past ones, and the distant past falling off rapidly in relevance.  Also uses priors on both numerators and denominators.  The tree structure can be implemented using both max and a softer max such as a geometric mean.

makepred makes prediction out of sample
predictseason makes prediction in sample and provides error value

In general, the tree structure is better in years with more upsets, and the home/away/neutral breakdown is dependent on whether neutral is truly neutral, something that my dataset did not control for.
