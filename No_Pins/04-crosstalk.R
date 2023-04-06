library(ggplot2)
library(plotly)
library(crosstalk)

mtcars_shared <- SharedData$new(mtcars)


bscols(
  ggplotly( 
    ggplot(mtcars_shared) +
      geom_point(aes(hp, mpg, color = as.factor(cyl))) + 
      labs(
        fill = "Cylinders",
        title = "MPG vs HP"
      ) 
  ) %>% 
  highlight(on = "plotly_selected"),
  
  ggplotly(
    ggplot(mtcars_shared, aes(disp, qsec)) + 
      geom_point() + 
      geom_smooth() + 
      labs(
        title = "DISP vs Quarter Mile Time"
      )
  ) %>% 
  highlight(on = "plotly_selected")
)
