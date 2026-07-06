# Used Vehicle Sales Analysis

## Overview

This project analyzes used vehicle sales transactions in the United States to understand which factors most strongly influence resale value. The project was completed for **BUDT730: Data Models and Decisions**.

The analysis uses a large Kaggle vehicle sales dataset containing approximately **550,000 used vehicle transactions** across the U.S. over an eight-month period. The project investigates geographic price variation, selling price deviations from market benchmarks, brand-level value retention, and predictive features that contribute to used vehicle pricing.

## Business Problem

The used vehicle market in the United States is large, competitive, and highly sensitive to factors such as mileage, condition, brand, model, geography, and market benchmarks. However, buyers and sellers often rely on generic pricing guides or informal rules of thumb.

This creates an unclear and non-unified pricing system.

For sellers, poor pricing can lead to:

* Underpricing and lost profit
* Overpricing and longer inventory holding time
* Increased depreciation risk

For buyers, unclear pricing can lead to:

* Overpaying for vehicles
* Difficulty comparing similar listings
* Confusion across locations and brands

The central business question was:

**Which factors most strongly influence the resale value of a used vehicle in the United States?**

## Business Questions

The project answered four main questions:

1. How do resale values vary across U.S. states?
2. What is the distribution of the difference between selling price and MMR price?
3. Which car brands hold value best in the used market?
4. Which features are most important in determining the selling price of a used car?

## Dataset

The project uses the Kaggle **Vehicle Sales and Market Trends** dataset.

The dataset includes approximately **550,000 transactions** and contains fields such as:

* Vehicle year
* Make
* Model
* Trim
* Body type
* Transmission
* Condition
* Odometer reading
* Color
* Interior color
* State
* Sale date
* Selling price
* MMR value

## Data Cleaning

Before analysis, the dataset was cleaned to improve consistency and reliability.

Main cleaning steps included:

* Standardizing categorical fields such as make, model, body, color, and transmission
* Handling missing or placeholder values
* Converting sale date into a clean `YYYY-MM-DD` format
* Imputing missing condition scores using the median
* Identifying duplicate VINs
* Keeping only the first recorded sale of each VIN in the main dataset
* Creating a secondary repeated-sales dataset for potential depreciation analysis
* Creating a `salesDifference` variable to compare selling price against MMR

The condition variable was especially important because it is recorded on a 0–50 scale and had over 11,000 missing values. The median was used because the condition distribution was left-skewed and the median is less sensitive to outliers.

## Methodology

The project combined exploratory analysis, statistical modeling, regression diagnostics, and feature importance interpretation.

The methodology included:

1. Data cleaning and standardization
2. State-level resale price comparison
3. Selling price vs. MMR deviation analysis
4. Brand-level depreciation modeling
5. Regression model development
6. Model comparison and diagnostic analysis

## Analysis 1: Resale Value by State

To compare resale prices across states, transactions were grouped by state and summary statistics were calculated for selling price, including mean, median, standard deviation, and percentiles.

The analysis identified the top states by average resale price.

### Top resale value states

The top states included:

* Tennessee
* Pennsylvania
* Colorado
* Nevada
* Michigan

The charts on page 3 show the top five states by average resale price and box plots comparing resale price distributions across these states. These visuals indicate that higher average resale values were not only caused by extreme outliers; medians and interquartile ranges were also elevated.

### Business Insight

Geography should be considered when pricing used vehicles. A national dealer using one national pricing curve may underprice vehicles in high-value states and overprice vehicles in lower-value states.

This insight can support:

* State-specific pricing recommendations
* Inventory relocation decisions
* Trade-in valuation adjustments
* Regional pricing strategy

## Analysis 2: Selling Price vs. MMR Price

The project compared actual selling price against MMR, an industry benchmark for vehicle pricing.

A new variable was created:

```text
salesDifference = selling price - MMR
```

The analysis found that most vehicles sold close to their MMR value. After outlier treatment, the average sales difference was close to zero, indicating that actual selling prices generally aligned with market benchmarks.

The box plots on page 5 compare the sales difference before and after cleaning. The cleaned distribution was more realistic and stable, showing that extreme outliers had been reduced while still preserving valid market variation.

### Key Findings

* Vehicles sold close to MMR on average
* After cleaning, the mean sales difference was approximately `-49.9`
* The standard deviation dropped to approximately `1,068`
* The interquartile range was roughly `-700` to `+600`
* Winsorization preserved valid extreme observations while reducing distortion

### Business Insight

Understanding the difference between selling price and MMR can help buyers and sellers evaluate whether a vehicle is fairly priced. It can also help dealers set pricing strategies that protect profit margins while staying competitive.

## Analysis 3: Brand-Level Value Retention

Mileage is one of the strongest predictors of used vehicle resale value. To compare how brands retain value as mileage increases, the project modeled the relationship between mileage and selling price for each brand.

Brands with fewer than 50 cars were filtered out to ensure reliable comparisons.

The regression model used was:

```text
ln(Selling Price) = β0 + β1(Mileage)
```

This log-linear model measured the percentage change in selling price as mileage increases.

### Why Log Selling Price Was Used

The raw relationship between selling price and mileage was nonlinear. Prices decline sharply at low mileage and flatten at higher mileage. Using the log of selling price helped stabilize variance and made depreciation comparisons more meaningful across brands.

The scatterplot and brand depreciation chart on pages 5–6 show that mileage has a strong negative relationship with resale value.

### Key Findings

Brands that retained value better included:

* Ram
* Hummer
* Toyota
* Chevrolet

Luxury brands depreciated faster, including:

* BMW
* Porsche
* Maserati
* Jaguar

Toyota was used as an example regression model. The model showed that Toyota vehicles lose approximately **9% of value for every 10,000 miles driven**.

Jaguar showed much faster depreciation, losing approximately **25% of value per 10,000 miles driven**.

### Business Insight

Brands known for durability and affordability tend to depreciate more slowly. Luxury vehicles tend to lose value faster as mileage increases. This helps buyers, dealers, and sellers make better pricing, purchase, and inventory decisions.

## Analysis 4: Predictive Features for Selling Price

The project tested three regression models to determine which features contribute most to used vehicle selling price.

### Model A

Model A used many categorical variables, including year, make, model, trim, body, transmission, state, condition, odometer, color, and interior.

The model had a high R² of approximately **0.912**, but it also had many singularities due to multicollinearity and high-cardinality categorical variables.

### Model B

Model B improved the data quality by using:

1. IQR filtering
2. Winsorization

This reduced extreme noise and improved model stability. Model B achieved an R² of approximately **0.924**, but still suffered from singularities and multicollinearity.

### Model C

Model C was developed to address the issues in Models A and B.

Main improvements:

* Combined make, model, and trim into one variable: `make_model_trim`
* Applied log transformation to selling price
* Applied log transformation to odometer
* Removed color because it was less statistically significant
* Reduced multicollinearity and high-cardinality issues

Model C had a lower R² of approximately **0.759**, but it was more realistic, interpretable, and statistically reliable.

The diagnostic plots on pages 7–8 show that Model C improved residual behavior and reduced heteroscedasticity compared with earlier models.

### Important Pricing Features

The final model identified the following important features:

* Year
* Make, model, and trim
* Transmission
* State
* Condition
* Odometer
* Interior

## Key Findings

* Used vehicle prices vary meaningfully across states.
* Tennessee, Pennsylvania, Colorado, Nevada, and Michigan showed higher average resale values.
* Most vehicles sell close to their MMR benchmark value.
* Outlier treatment reduced noise in selling price vs. MMR deviations.
* Mileage strongly affects resale value, but depreciation differs by brand.
* Durable and affordable brands tend to retain value better.
* Luxury brands depreciate faster as mileage increases.
* Model C was the most reliable regression model because it reduced multicollinearity and improved interpretability.
* Important pricing features include year, vehicle variant, transmission, state, condition, odometer, and interior.

## Business Value

This project provides value for both buyers and sellers in the used vehicle market.

### For Dealers and Sellers

The analysis can help with:

* More accurate vehicle pricing
* Better trade-in valuation
* Regional pricing strategy
* Inventory movement between markets
* Avoiding overpricing and underpricing
* Understanding brand-level depreciation risk

### For Buyers

The analysis can help with:

* Identifying fair prices
* Comparing vehicles across states
* Understanding depreciation by brand
* Avoiding overpayment
* Choosing brands with stronger resale value

## Tools & Technologies

* R
* Regression modeling
* Exploratory data analysis
* Data cleaning
* Outlier treatment
* IQR filtering
* Winsorization
* Log transformation
* ANOVA
* VIF analysis
* Data visualization
* Kaggle dataset

## Project Structure

## Project Structure

```text
Used-Vehicle-Sales-Analysis/
│
├── Final/
│   ├── BUDT730_Final Project PPT.pdf
│   ├── BUDT730_Final Project_Report.pdf
│   └── BUDT730_Final Project_dataset_car_prices.csv
│
├── Regression Models to find the correlation/
│   ├── 730 report draft.docx
│   ├── car_price_stats.ipynb
│   ├── car_stats_quartile.csv
│   ├── eda_with_outliers_.docx
│   ├── model graphs 730 project.docx
│   ├── project draft 2.R
│   └── project file.R
│
├── 11_16 Questions - Youngseo.docx
├── 730 - Final Project Guidelines_.docx
├── 730 Final Report.docx
├── BUDT730 Final Project - Submitted.docx
├── Missing Values.docx
├── car_prices_clean_dup.csv
├── car_prices_clean_main.csv
└── car_prices_data_cleaning_script.R
```

## Limitations

The project had several limitations:

* The dataset covered a limited time range, mostly from January 2015 to July 2015, with some records from January 2014.
* The gap between January 2014 and January 2015 made time-series analysis difficult.
* Some vehicle categories had high cardinality, creating modeling challenges.
* MSRP was not included, limiting precise depreciation analysis.
* The analysis did not fully model nonlinear relationships beyond log transformations.
* The primary model used the first sale per VIN, while repeated vehicle sales were kept separate for potential future analysis.

## Future Improvements

Future work could improve the project by:

* Incorporating MSRP to calculate true depreciation
* Using the repeated VIN dataset to study depreciation across multiple transactions
* Building random forest or gradient boosting models
* Adding time-series analysis with longer-term data
* Creating a vehicle price prediction tool
* Developing state-specific pricing benchmarks
* Comparing dealer vs. private seller pricing behavior
* Building an interactive dashboard for used vehicle valuation

## Conclusion

This project shows that used vehicle resale value is influenced by geography, benchmark pricing, mileage, brand, condition, and vehicle specifications. State-level pricing differences suggest that location should be included in pricing strategies. MMR comparisons show that most vehicles sell near benchmark values, while brand-level depreciation analysis shows that durable, affordable brands retain value better than luxury brands.

Among the regression models tested, Model C provided the most reliable and interpretable framework for understanding used vehicle pricing. The findings can help dealers, sellers, and buyers make more informed decisions in the used vehicle market.
