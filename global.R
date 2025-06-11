# global.R
# Shared setup for "Cost of Living in Melbourne – A Student's Perspective"

# === Load required libraries ===
library(shiny)
library(ggplot2)
library(dplyr)
library(readr)
library(lubridate)
library(scales)
library(tidyr)
library(plotly)

# === Load primary dataset: Group 1 (core cost data) ===
group1_data <- read_csv("cleaned_data/group1_time_series_clean.csv") %>%
  mutate(
    quarter = as.Date(quarter)
  )

# === Load secondary datasets from Group 2 ===

# 1. Base CPI categories (not used yet, but may support future tabs)
group2_base <- read_csv("cleaned_data/group2_base_clean.csv") %>%
  mutate(
    quarter = as.Date(quarter)
  )

# 2. Education subcategories (used in Tab 2)
group2_education <- read_csv("cleaned_data/group2_education_clean.csv") %>%
  mutate(
    quarter = as.Date(quarter)
  )

# 3. Grocery product-level data (used in Tab 2)
group2_grocery <- read_csv("cleaned_data/group2_grocery_clean.csv") %>%
  mutate(
    quarter = as.Date(quarter)
  )

# === Extract unique subcategories for UI inputs (Tab 2) ===
education_subcategories <- unique(group2_education$education_type)
grocery_products <- unique(group2_grocery$product)