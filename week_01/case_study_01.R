#Load the iris dataset
data(iris)

#
iris$Sepal.Length
iris$Sepal.Width
iris$Petal.Length
iris$Petal.Width
iris$Species

#Define new variable for petal length mean
petal_length_mean <-mean(Petal.Length)
petal_length_mean

#Plot Histogram for Petal Length
hist(Petal.Length)