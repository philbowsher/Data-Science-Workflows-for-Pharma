# RStudio Portfolio Training Exercises

Welcome! This document will guide you through a series of exercises that will introduce:
- ggplot2
- R Notebooks
- RMD & Flexdashboards
- Parameterize R Markdown
- Shiny 

These artifacts will be explored in the context of RStudio Connect.

> A quick setup note. Please navigate to `Tools -> Global Options -> R Markdown` and change the dropdown for "Show output preview in" from Window to Viewer Pane.

## Part 1: ggplot2 & Plotly

To begin, we'll work with the openFDA API to explore adverse event data.

`01-adverse-events-plots.R` - This file includes our code to query the API and generate a few static plots.

Try running each line of R code by using Ctrl Enter. Alternately, try highlighting code and running it.

The plots are generated with ggplot2...

A ggplot2 template - Make any plot by filling in the parameters of this template

ggplot(data = <DATA>) +
<GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))

ggplot(data = <DATA>) +
<GEOM_FUNCTION>(mapping = aes(<MAPPINGS>),
stat = <STAT>) +
<FACET_FUNCTION>

ggplot(data = mpg) +
geom_point(mapping = aes(x = displ, y = hwy))

ggplot(data = diamonds) +
geom_bar(mapping = aes(x = cut), stat = "count")

Here is an example with Plotly:

http://www.htmlwidgets.org/showcase_plotly.html

library(ggplot2)
library(plotly)
p <- ggplot(data = diamonds, aes(x = cut, fill = clarity)) +
            geom_bar(position = "dodge")
ggplotly(p)

Can you make the openfda ggplot2 examples interactive with plotly?

Let's publish our plotly visualization to RSC by clicking the blue publish icon in the upper right hand corner of the RStudio source pane.

You'll be prompted to link RStudio to the account you created on RStudio Connect, enter the [URL for your server, it will look like this](http://ec2-54-202-230-54.us-west-2.compute.amazonaws.com/). Once connected, you'll be prompted to publish the plot. **Please title the plot as: yourFirstName_plot**.

Once published, take some time to play with the RStudio Connect interface.

Usually you'll want your boss / colleagues to visit the app without seeing the RStudio Connect dashboard. Can you find the link that wil open the report outside of the RStudio Connect dashboard? 

How would you restrict access to your app? Can you visit your neighbour's app? Change the access controls so your neighbour can view your app.

Make some changes to the report and redeploy it. Can you figure out how to rollback to the first deployed version of the application?

## Part 2: Introduction to R Notebooks

Now let's covert our R file into a R Notebook. To do this, take each section of your .R file and add them to code chunks to a R Notebook.

To do this, go to File, New File, R Notebook.

Try executing each of your chunks by clicking the *Run* button within the chunk or by placing your cursor inside it and pressing *Ctrl+Shift+Enter*. 

Add a new chunk by clicking the *Insert Chunk* button on the toolbar or by pressing *Ctrl+Alt+I*.

Now save your notebook, and click Preview Notebook or press *Ctrl+Shift+K*. 

Now publish your notebook to RSC by hitting the blue button.

A finished example is: `02_building_blocks.Rmd`

## Part 3: R Markdown Dashboards

Noe go to File, New File, R Markdown, From Template...and click Flexdashboard.

To build our dashboard, we will use [flexdashboard](https://rstudio.github.io/flexdashboard) package, which is a powerful templating package for arranging building blocks into a composite dashboard.

Copy your Notebook code chunks into your new Template.

Markdown syntax is used to layout the plots into a dashboard.

If you would like a heads starts, `03-flexdashboard-skeleton.Rmd` has added the ETL process and packages for you. Try finishing this document by adding the plots.

Struture your Dashboard so that there are 2 Columns.

Your first column will only have "All Events".

Your second Column will have "Age Range"" and "Events by Gender".

Add the section below as your first section of your second Column...

### Age Range

```{r}
age_label <- str_replace_all(age, fixed("+"), " ") %>% 
    str_replace(fixed("["), "") %>% 
    str_replace(fixed("]"), "") %>% 
    str_replace(fixed("TO"), "-")     

valueBox(age_label, icon = 'glyphicon-user')
```

Once complete, use the dropdown by the "Knit" button on top of the source pane, select "Knit with Parameters". What happens?

Now publish your HTML report to RSC.

## Part 4: Parameterize Rmarkdown

Let's keep working on your RMD file.

Let's now Parameterize our R Mardown Report so that different versions of the dashboard can easily be created for different drugs

First, look over your code and remove this line:

# specify drug
drug <- "Prednisone"

The top of your RMD file is the YAML metadata.

Add this section to the bottom of your YAML header.

params:
  drug: Prednisone

Ok, here is the tricky part. Our report will create a report for the value of drug, which currently is hard coded as "Keytruda".

Do a search for all occurances of "drug" bt hitting Ctrl F

And replace all of them with:

params$drug

Now our R Markdown document includes a parameter, `params$drug`

Now Knit your report.

Now go back to the YML header and change Keytruda to Prednisone

Ok, now publish your R Markdown to RSC.

This time be sure to "Publish with Source Code". 

Once published, investigate the different options in Connect for parameterized reports. Can you email yourself the report? 

Can you setup a schedule to email your neighbour the report? Can you view previous renderings of the report?

Our report accepts a parameter - the drug name. See if you can configure RStudio Connect to email a version of the report for Keytruda every Monday and a version for Prednisone every Tuesday. 

Hint: On the left hand side you'll see a bar that says "Input", open the sidebar to change the parameters. Elect "Save" to create a new version of the report.

## Part 5: Shiny

Before we jump into openFDA, let's look at a basic example of migrating a RMD into a Shiny App.

RMD_NO_Shiny.Rmd

This file is just a RMD with ggplot2

Open the file and knit it.

Now add this to the bottom of your YAML:

runtime: shiny

Add this to your global chunk:

dataset1 <- read_csv("ToothGrowth.csv") %>% mutate( supp = factor(supp))
data <- read_csv("ToothGrowth.csv") %>% mutate( supp = factor(supp))

Create a Sidebar with this:

# Page 1

Inputs {.sidebar}
-----------------------------------------------------------------------

```{r}

#Change for your dataset

sliderInput('sampleSize', 'Sample Size', min=1, max=nrow(dataset1),
            value=min(1000, nrow(dataset1)), step=500, round=0)

checkboxInput('jitter', 'Jitter', value = TRUE)
checkboxInput('smooth', 'Smooth', value = TRUE)

selectInput('x', 'X', names(dataset1))
selectInput('y', 'Y', names(dataset1), names(dataset1)[[2]])
selectInput('color', 'Color', c('None', names(dataset1)))

selectInput('facet_row', 'Facet Row',
            c(None='.', names(dataset1[sapply(dataset1, is.factor)])))
selectInput('facet_col', 'Facet Column',
            c(None='.', names(dataset1[sapply(dataset1, is.factor)])))
```



Add this over your ggplot2 code:



Outputs
-----------------------------------------------------------------------

### Diamonds

```{r}
dataset <- reactive({
  data[sample(nrow(data), input$sampleSize),]
})

renderPlotly({
  p <- ggplot(dataset(), aes_string(x=input$x, y=input$y)) + geom_point()
  
  if (input$color != 'None')
    p <- p + aes_string(color=input$color)
  
  facets <- paste(input$facet_row, '~', input$facet_col)
  if (facets != '. ~ .')
    p <- p + facet_grid(facets)
  
  if (input$jitter)
    p <- p + geom_jitter()
  if (input$smooth)
    p <- p + geom_smooth()
  
  print(p)
})
```


Lastly, add this code to the bottom of your file:




# Page 2

```{r}
renderDataTable({
  dataset()
}, options = list(scrollY = "750px"))
```



RMD_YES_Shiny.Rmd Has this done for you



Ok, back to openFDA:


`05-adverse-events-shiny.Rmd` - This file builds off the flexdashboard and adds `runtime:shiny` to turn the static HTML file into an intereactive Shiny application. 

The shiny application makes it easy to explore the affect of age on the distribution of adverse events. Notice the minimal code changes required to turn the document into an app!

`04-crosstalk.R` - Next, we'll take a brief detour to explore crosstalk and we'll go from regular ggplot2 charts to interactive, linked charts.

In the first section we created a Shiny app that allows users to explore information on different stocks. 

This type of interactive exploratory analysis is very helpful in meetings when users are asking questions. Often, after an interesting set of inputs has been identified, you'll want to transition from an interactive application to a model that pushes out updates to end users. 

To do so, we'll take our building blocks and create a report that can be scheduled and pushes an email to customers.
