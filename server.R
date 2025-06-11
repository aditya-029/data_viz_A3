# server.R
# Server logic for "Cost of Living in Melbourne – A Student's Perspective"

library(shiny)
library(plotly)
library(dplyr)
library(tidyr)
library(ggplot2)
library(lubridate)

shinyServer(function(input, output) {
  
  # === Tab 1: Overview Plot ===
  grocery_summary <- group2_grocery %>%
    group_by(quarter) %>%
    summarise(Groceries = mean(annual_change, na.rm = TRUE), .groups = "drop")
  
  education_summary <- group2_education %>%
    group_by(quarter) %>%
    summarise(Education = mean(quarterly_change, na.rm = TRUE), .groups = "drop")
  
  overview_data <- group1_data %>%
    select(quarter, Rent = rent_quarterly_change, Electricity = electricity_incl_rebate, CPI = cpi_quarterly_change) %>%
    mutate(Electricity = (Electricity / first(Electricity) - 1) * 100) %>%
    left_join(grocery_summary, by = "quarter") %>%
    left_join(education_summary, by = "quarter") %>%
    pivot_longer(-quarter, names_to = "Category", values_to = "Quarterly_Change")
  
  output$overview_plot <- renderPlotly({
    filtered_data <- overview_data %>%
      filter(Category %in% input$selected_categories)
    
    p <- ggplot(filtered_data, aes(x = quarter, y = Quarterly_Change, color = Category)) +
      geom_line(size = 1.2) +
      geom_point(size = 2) +
      scale_y_continuous(
        labels = scales::label_number(suffix = "%", accuracy = 0.1),
        expand = expansion(mult = c(0.05, 0.1))
      ) +
      scale_x_date(date_breaks = "3 months", date_labels = "%b\n%Y") +
      labs(x = "Quarter", y = "Quarterly Change (%)", color = "Cost Category") +
      theme_minimal(base_size = 14) +
      theme(legend.position = "top")
    
    ggplotly(p, tooltip = c("x", "y", "color"))
  })
  
  # === Tab 2: Education Subcategory Plot ===
  output$education_plot <- renderPlotly({
    edu_filtered <- group2_education %>%
      filter(education_type == input$selected_edu_type)
    
    p_edu <- ggplot(edu_filtered, aes(x = quarter, y = quarterly_change)) +
      geom_line(color = "#1f77b4", size = 1.2) +
      geom_point(color = "#1f77b4", size = 2) +
      labs(
        title = paste("Quarterly Change in", input$selected_edu_type),
        x = "Quarter",
        y = "Change (%)"
      ) +
      scale_y_continuous(labels = scales::label_percent(scale = 1)) +
      scale_x_date(date_breaks = "3 months", date_labels = "%b\n%Y") +
      theme_minimal(base_size = 14)
    
    ggplotly(p_edu, tooltip = c("x", "y"))
  })
  
  # === Tab 2: Grocery Product Plot ===
  output$grocery_plot <- renderPlotly({
    grocery_filtered <- group2_grocery %>%
      filter(product == input$selected_grocery_product)
    
    p_grocery <- ggplot(grocery_filtered, aes(x = quarter, y = annual_change)) +
      geom_line(color = "#d62728", size = 1.2) +
      geom_point(color = "#d62728", size = 2) +
      labs(
        title = paste("Annual Price Change for", input$selected_grocery_product),
        x = "Quarter",
        y = "Annual Change (%)"
      ) +
      scale_y_continuous(labels = scales::label_percent(scale = 1)) +
      scale_x_date(date_breaks = "3 months", date_labels = "%b\n%Y") +
      theme_minimal(base_size = 14)
    
    ggplotly(p_grocery, tooltip = c("x", "y"))
  })
  
  # === Tab 2: Descriptions ===
  
  edu_descriptions <- c(
    "education_percent" = "Total education CPI has irregular spikes, likely linked to annual fee cycles.",
    "preschool_primary_education_percent" = "Primary education costs rose steadily across the observed period.",
    "secondary_education_percent" = "Secondary education showed consistent increases, reflecting term-based indexing.",
    "tertiary_education_percent" = "Tertiary education saw a sharp spike early, then levelled off gradually."
  )
  
  grocery_descriptions <- c(
    "Bread and cereal products" = "Cereal and bread prices showed a cooling trend but remain above pre-inflation levels.",
    "Dairy and related products" = "Dairy costs dipped sharply in late 2024 before stabilising in 2025.",
    "Food and non-alcoholic beverages" = "Food costs broadly declined but remain persistently high.",
    "Food products n.e.c" = "Miscellaneous food items tracked above 3% inflation throughout.",
    "Fruit and vegetables" = "Fruit and veg prices bounced mid-2024 due to likely seasonal factors.",
    "Meat and seafoods" = "Meat costs showed steady increases across all quarters.",
    "Non alcoholic beverages" = "Non-alcoholic drinks had brief recovery before returning to a decline."
  )
  
  output$education_description <- renderUI({
    selected <- input$selected_edu_type
    desc <- edu_descriptions[selected]
    if (is.null(desc)) desc <- "No description available for this category."
    tags$p(em(desc), style = "margin-top: 10px;")
  })
  
  output$grocery_description <- renderUI({
    selected <- input$selected_grocery_product
    desc <- grocery_descriptions[selected]
    if (is.null(desc)) desc <- "No description available for this product."
    tags$p(em(desc), style = "margin-top: 10px;")
  })
  
})