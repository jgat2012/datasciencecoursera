library(datasets)
data(iris)
?iris
tapply(iris$Sepal.Length, iris$Species, mean)
sapply(iris[,1:4], mean)
colMeans(iris[,1:4])
data(mtcars)
?mtcars

tapply(mtcars$mpg, mtcars$cyl, mean)
sapply(split(mtcars$mpg,mtcars$cyl), mean)
split(mtcars$cyl,mtcars$hp)
avg_hp<-sapply(split(mtcars$hp,mtcars$cyl), mean)

round(abs(avg_hp[1] - avg_hp[3]))

set.seed(10)
x <- rep(0:1, each = 5)
e <- rnorm(10, 0, 20)
y <- 0.5 + 2 * x + e

plot(y)


