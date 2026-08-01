# SECTION 1:
# PROJECT TITLE: UNDERSTANDING THE DETERMINANTS OF HAPPINESS ACROSS COUNTRIES
# AUTHOR: MANASVI JADHAV

# OBJECTIVE: 
# To examine how socio-economic factors such as GDP, social support, life expectancy, freedom, generosity,
# and corruption influence happiness levels across countries using R.                                                                                            


# SECTION 2: LOAD LIBRARIES
library(tidyverse)
library(dplyr)
library(ggplot2)
library(tidyr)
library(readr)
library(corrplot)


# SECTION 3: IMPORT DATASET
setwd("C:\\Users\\manas\\Downloads\\DA\\github\\R")
happiness <- read.csv("WHR2024.csv")


# SECTION 4: EXPLORE THE DATASET
# to get the first 6 observations
head(happiness)

# to get the last 6 observations
tail(happiness)

# to get dimensions
dim(happiness)

# to get the variable names
colnames(happiness)

# to get the structure
str(happiness)

#to get the summary statistics
summary(happiness)


# SECTION 5: DATA CLEANING
# STEP 1: CHECK FOR MISSING VALUES
colSums(is.na(happiness))

#checking observations that have missing values
happiness[!complete.cases(happiness), ]

#remove observations with missing values
happiness <- happiness %>% 
  drop_na()
colSums(is.na(happiness))
dim(happiness)

#check duplicate observations
sum(duplicated(happiness))

#check data types
sapply(happiness, class)

#rename the variables
happiness <- happiness %>% 
  rename(
    Country = Country.name,
    Happiness = Ladder.score,
    GDP = Explained.by..Log.GDP.per.capita,
    SocialSupport = Explained.by..Social.support,
    LifeExpectancy = Explained.by..Healthy.life.expectancy,
    Freedom = Explained.by..Freedom.to.make.life.choices,
    Generosity = Explained.by..Generosity,
    Corruption = Explained.by..Perceptions.of.corruption,
    Dystopia = Dystopia...residual
  )
colnames(happiness)

happiness <- happiness %>% 
  select(-upperwhisker, -lowerwhisker)
colnames(happiness)

#DATA CLEANING SUMMARY:
# - Removed 3 observations containing missing values.
# - Verified that no duplicate observations exist.
# - Renamed varibables for readability.
# - Removed unnecessary confidence interval columns.
# - Dataset is now ready for exploratory data analysis.


# SECTION 6: EXPLORATORY DATA ANALYSIS (EDA)
# 6.1: OVERALL SUMMARY STATISTICS
summary(happiness)

# 6.2: HAPPINESS SCORE STATISTICS
# mean happiness score
mean(happiness$Happiness)

# median happiness score
median(happiness$Happiness)

# standard deviation
sd(happiness$Happiness)

# minimum happiness score
min(happiness$Happiness)

# maximum happiness score
max(happiness$Happiness)

# 6.3: TOP 10 HAPPIEST COUNTRIES
top10_happy <- happiness %>% 
  arrange(desc(Happiness)) %>% 
  select(Country, Happiness) %>% 
  head(10)
top10_happy

# 6.4: BOTTOM 10 HAPPIEST COUNTRIES
bottom10_happy <- happiness %>% 
  arrange(Happiness) %>% 
  select(Country, Happiness) %>% 
  head(10)
bottom10_happy

# 6.5: AVERAGE SOCIO-ECONOMIC INDICATORS
happiness %>% 
  summarise(
    Avg_Happiness = mean(Happiness),
    Avg_GDP = mean(GDP),
    Avg_SocialSupport = mean(SocialSupport),
    Avg_LifeExpectancy = mean(LifeExpectancy),
    Avg_Freedom = mean(Freedom),
    Avg_Generosity = mean(Generosity),
    Avg_Corruption = mean(Corruption)
  )


# SECTION 7: DATA VISUALISATION
library(scales)
custom_theme <- theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5, color = "grey40"),
    axis.title = element_text(face = "bold"),
    panel.grid.minor = element_blank()
  )

# 7.1: DISTRIBUTION OF HAPPINESS SCORES
happiness_distribution <- ggplot(happiness, aes(x = Happiness)) +
  geom_histogram(
    bins = 15,
    fill = "steelblue",
    color = "black"
  ) +
  labs(
    title = "Distribution of Happiness Scores",
    subtitle = "World Happiness Report 2024",
    x = "Happiness Score",
    y = "Number of Countries"
  ) +
  custom_theme
happiness_distribution


# 7.2: TOP 10 HAPPIEST COUNTRIES
top10_plot <- ggplot(top10_happy,
       aes(x = reorder(Country, Happiness),
           y = Happiness)) +
  geom_col(fill = "forestgreen") +
  
  coord_flip() +
  labs(
    title = "Top 10 Happiest Countries",
    subtitle = "World Happiness Report 2024",
    x = "",
    y = "Happiness Score"
  ) +
  custom_theme
top10_plot


# 7.3: BOTTOM 10 HAPPIEST COUNTRIES
bottom10_plot <- ggplot(bottom10_happy,
       aes(x = reorder(Country, Happiness),
           y = Happiness)) +
  geom_col(fill = "firebrick") +
  coord_flip() +
  labs(
    title = "Bottom 10 Happiest Countries",
    subtitle = "World Happiness Report 2024",
    x = "",
    y = "Happiness Score"
  ) +
  custom_theme
bottom10_plot


# 7.4: GDP vs Happiness
gdp_plot <- ggplot(happiness,
       aes(x = GDP,
           y = Happiness)) +
  geom_point(
    color = "steelblue",
    size = 3,
    alpha = 0.8
  ) +
  geom_smooth(
    method = "lm",
    color = "red",
    se = TRUE
  ) +
  labs(
    title = "GDP and Happiness",
    subtitle = "Relationship between GDP per capita and Happiness",
    x = "GDP per capita",
    y = "Happiness Score"
  ) +
  custom_theme
gdp_plot

# 7.5: SOCIAL SUPPORT vs HAPPINESS
social_support_plot <- ggplot(happiness,
       aes(x = SocialSupport,
           y = Happiness)) +
  geom_point(
    color = "darkorange",
    size = 3,
    alpha = 0.8
  ) +
  geom_smooth(
    method = "lm",
    color = "red",
  ) +
  labs(
    title = "Social Support and Happiness",
    subtitle = "Relationship between Social Support and Happiness",
    x = "Social Support",
    y = "Happiness Score"
  ) +
  custom_theme
social_support_plot


# 7.6: FREEDOM vs HAPPINESS
freedom_plot <- ggplot(happiness,
       aes(x = Freedom,
           y = Happiness)) +
  geom_point(
    color = "purple",
    size = 3,
    alpha = 0.8
  ) +
  geom_smooth(
    method = "lm",
    color = "red",
  ) +
  labs(
    title = "Freedom and Happiness",
    subtitle = "Relationship between Freedom and Happiness",
    x = "Freedom",
    y = "Happiness Score"
  ) +
  custom_theme
freedom_plot


# 7.7: LIFE EXPECTANCY vs HAPPINESS
life_expectancy_plot <- ggplot(happiness,
       aes(x = LifeExpectancy,
           y = Happiness)) +
  geom_point(
    color = "darkgreen",
    size = 3,
    alpha = 0.8
  ) +
  geom_smooth(
    method = "lm",
    color = "red",
  ) +
  labs(
    title = "Life Expectancy and Happiness",
    subtitle = "Relationship between Healthy Life Expectancy and Happiness",
    x = "Healthy Life Expectancy",
    y = "Happiness Score"
  ) +
  custom_theme
life_expectancy_plot


# 7.8: CORRELATION ANALYSIS
# create a correlation matrix
correlation_matrix <- happiness %>% 
  select(Happiness,
         GDP,
         SocialSupport,
         Freedom,
         Generosity,
         Corruption) %>% 
  cor()
correlation_matrix

#correlation heatmap
corrplot(
  correlation_matrix,
  method = "color",
  type = "upper",
  addCoef.col = "black",
  tl.col = "black",
  tl.srt = 45,
  tl.cex = 0.8,
  number.cex = 0.7
)


# SECTION 8: REGRESSION ANALYSIS
#multiple linear regressions
model <- lm(
  Happiness ~ GDP +
    SocialSupport +
    LifeExpectancy +
    Freedom +
    Generosity +
    Corruption,
  data = happiness
)
summary(model)


#SECTION 9: MODEL DIAGNOSTICS
diagnostics <- data.frame(
  Fitted = fitted(model),
  Residuals = residuals(model),
  StdResiduals = rstandard(model)
)
head(diagnostics)

# 9.1: Residual vs Fitted
residual_plot <- ggplot(diagnostics,
       aes(x = Fitted,
           y = Residuals)) +
  geom_point(color = "steelblue",
             size = 3,
             alpha = 0.8) +
  geom_hline(yintercept = 0,
             color = "red",
             linewidth = 1) +
  labs(
    title = "Residuals vs Fitted Values",
    subtitle = "Checking for constant variance",
    x = "Fitted Happiness",
    y = "Residuals"
  ) +
  custom_theme
residual_plot

# 9.2: HISTOGRAM OF RESIDUALS
residual_histogram <- ggplot(diagnostics,
       aes(x = Residuals)) +
  
  geom_histogram(
    bins = 15,
    fill = "steelblue",
    color = "white"
  ) +
  
  labs(
    title = "Distribution of Regression Residuals",
    x = "Residuals",
    y = "Count"
  ) +
  custom_theme
residual_histogram


# 9.3: NORMAL Q-Q PLOT
qq_plot <- ggplot(diagnostics,
       aes(sample = StdResiduals)) +
  stat_qq(color = "steelblue") +
  stat_qq_line(color = "red") +
  labs(
    title = "Normal Q-Q plot",
    subtitle = "Checking normality of residuals"
  ) +
  custom_theme
qq_plot

# SECTION 10: EXPORTING PLOTS
ggsave(
  filename = "plots/happiness_distribution.png",
  plot = happiness_distribution,
  width = 8,
  height = 5,
  dpi = 300
)

ggsave("plots/top10_happiest.png",
       plot = top10_plot,
       width = 8,
       height = 5,
       dpi = 300)

ggsave("plots/bottom10_happiest.png",
       plot = bottom10_plot,
       width = 8,
       height = 5,
       dpi = 300)

ggsave("plots/gdp_vs_happiness.png",
       plot = gdp_plot,
       width = 8,
       height = 5,
       dpi = 300)

ggsave("plots/social_support_vs_happiness.png",
       plot = social_support_plot,
       width = 8,
       height = 5,
       dpi = 300)

ggsave("plots/freedom_vs_happiness.png",
       plot = freedom_plot,
       width = 8,
       height = 5,
       dpi = 300)

ggsave("plots/life_expectancy_vs_happiness.png",
       plot = life_expectancy_plot,
       width = 8,
       height = 5,
       dpi = 300)

ggsave("plots/residual_vs_fitted.png",
       plot = residual_plot,
       width = 8,
       height = 5,
       dpi = 300)

ggsave("plots/residual_histogram.png",
       plot = residual_histogram,
       width = 8,
       height = 5,
       dpi = 300)

ggsave("plots/qq_plot.png",
       plot = qq_plot,
       width = 8,
       height = 5,
       dpi = 300)

png("plots/correlation_heatmap.png",
    width = 900,
    height = 700)

corrplot(
  correlation_matrix,
  method = "color",
  type = "upper",
  addCoef.col = "black",
  tl.col = "black",
  tl.srt = 45
)

dev.off()