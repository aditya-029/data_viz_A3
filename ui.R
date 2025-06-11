# ui.R
# UI for "Cost of Living in Melbourne – A Student's Perspective"

library(shiny)
library(plotly)

shinyUI(
  navbarPage(
    title = "Cost of Living in Melbourne – A Student's Perspective",
    
    # === TAB 1: Overview of Cost Trends ===
    tabPanel("Cost Trends",
             fluidPage(
               h3("Quarterly Changes in Key Living Costs (2023–2025)", style = "margin-top: 10px; margin-bottom: 5px;"),
               
               h4("How have student essentials changed over time?"),
               p("This panel displays the ", strong("quarterly percentage change"), " for major student-related expenses: rent, electricity, groceries, education, and the overall CPI."),
               p("It helps visualise which categories have been the most volatile or burdensome over the past two years."),
               
               selectInput(
                 inputId = "selected_categories",
                 label = "Select cost categories to compare:",
                 choices = c("Rent", "Electricity", "Groceries", "Education", "CPI"),
                 selected = c("Rent", "Groceries", "Education", "Electricity", "CPI"),
                 multiple = TRUE
               ),
               
               plotlyOutput("overview_plot", height = "410px"),
               
               br(),
               HTML("
                 <h4><strong>Trend Insights:</strong></h4>
                 <ul>
                   <li><strong>Rent:</strong> Rose steadily in 2023–24, pointing to persistent housing stress.</li>
                   <li><strong>Electricity:</strong> Volatile, with sharp spikes in late 2024 — likely due to seasonal or supply shocks.</li>
                   <li><strong>Groceries:</strong> Small but steady increases suggest ongoing cost pressure.</li>
                   <li><strong>Education:</strong> Few but steep rises, likely tied to annual fee updates.</li>
                   <li><strong>CPI:</strong> Remained relatively stable — underestimating student-specific inflation.</li>
                 </ul>
                 <p><em>Overall, students appear more vulnerable to cost increases than the general population — especially in housing and energy.</em></p>
               ")
             )
    ),
    
    # === TAB 2: Deeper Breakdown ===
    tabPanel("Expense Breakdown",
             fluidPage(
               titlePanel("Detailed Cost Breakdown by Category"),
               
               h4("Explore cost variation across subcategories"),
               p("This panel allows a deeper dive into ", strong("education"), " and ", strong("grocery"), " categories — exploring subtypes and specific items students spend on."),
               
               tabsetPanel(
                 tabPanel("Education",
                          selectInput(
                            inputId = "selected_edu_type",
                            label = "Select education subcategory:",
                            choices = education_subcategories,
                            selected = education_subcategories[1]
                          ),
                          plotlyOutput("education_plot", height = "460px"),
                          uiOutput("education_description")
                 ),
                 
                 tabPanel("Groceries",
                          selectInput(
                            inputId = "selected_grocery_product",
                            label = "Select grocery item:",
                            choices = grocery_products,
                            selected = grocery_products[1]
                          ),
                          plotlyOutput("grocery_plot", height = "460px"),
                          uiOutput("grocery_description")
                 )
               ),
      
             )
    ),
    # === TAB 3: References ===
    tabPanel("References",
             fluidPage(
               titlePanel("References"),
               p("Australian Bureau of Statistics. (2025, March quarter). Consumer Price Index, Australia. ABS. https://www.abs.gov.au/statistics/economy/price-indexes-and-inflation/consumer-price-index-australia/mar-quarter-2025"),
               p("R Core Team. (2024). R: A language and environment for statistical computing (Version 4.3.2) [Computer software]. R Foundation for Statistical Computing. https://www.R-project.org/"),
               p("Wickham, H. (2016). ggplot2: Elegant graphics for data analysis. Springer. https://ggplot2.tidyverse.org"),
               p("Sievert, C. (2020). Interactive web-based data visualization with R, plotly, and shiny. Chapman and Hall/CRC. https://plotly-r.com"),
               p("Wickham, H., François, R., Henry, L., & Müller, K. (2023). dplyr: A grammar of data manipulation (Version 1.1.4) [R package]. https://CRAN.R-project.org/package=dplyr"),
               p("Wickham, H., & Bryan, J. (2023). readr: Read rectangular text data (Version 2.1.5) [R package]. https://CRAN.R-project.org/package=readr"),
               p("Wickham, H., & Seidel, D. (2023). scales: Scale functions for visualization (Version 1.3.0) [R package]. https://CRAN.R-project.org/package=scales"),
               p("Chang, W., Cheng, J., Allaire, J., Xie, Y., & McPherson, J. (2023). shiny: Web application framework for R (Version 1.8.1) [R package]. https://CRAN.R-project.org/package=shiny"),
               p("Pedersen, T. L. (2023). patchwork: The composer of plots (Version 1.1.3) [R package]. https://CRAN.R-project.org/package=patchwork")
             )
    )
  )
)