#install.packages("swirl")
library(swirl)
install_from_swirl("R Programming")
swirl()

#jgat2022

y<-4
check<- function(x){
  x+y
}
check(2)

x <- 5
y <- if(x < 3) {
        NA
} else {
        10
}
y
