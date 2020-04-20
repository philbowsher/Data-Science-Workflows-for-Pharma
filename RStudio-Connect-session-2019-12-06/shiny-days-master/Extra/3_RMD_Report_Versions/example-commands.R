# https://github.com/philbowsher/Job-Scheduling-R-Markdown-Reports-via-R
library(magrittr)

# Build a bunch of animal reports
animals <- list("Elephant", "Giraffe", "Koala", "Anaconda")

# base R
lapply(animals
       , function(x){
         rmarkdown::render(
           "animal-report.Rmd"
           , params=list(animal = x)
           , output_file = tolower(
             paste0(x,".html")
           )
         )
       }
)

# tidyverse
animals %>% purrr::map(
  function(x){
    rmarkdown::render(
      "animal-report.Rmd"
      , params=list(animal = x)
      , output_file = tolower(
        paste0(x,".html")
      )
    )
  }
)

# Build the airplane reports (requires a database with airlines and flights tables)
#Set WD

carriers <- list("AA", "DL", "WN")

build_airplane_report <- function(carrier) {
  rmarkdown::render("airplane-report.Rmd"
                    , params=list(carrier = carrier)
                    , output_file = tolower(paste0(carrier,".html"))
  )
}
# base R
lapply(carriers, build_airplane_report)

# tidyverse
purrr::map(carriers, build_airplane_report)
