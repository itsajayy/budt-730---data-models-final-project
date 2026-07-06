
# R package for better performance working with dataframes
library(data.table)

df <- fread("C:/Users/rohit/Downloads/car_prices.csv")

View(df)

names(df)   # names of columns
str(df)     # column data types

summary(df) # min, max, mean, etc



# Deal with N/A and "" values

colSums(is.na(df))    # number of N/A values in each column

colSums(df == "" | is.na(df)) # Some blanks "" are not treated as N/A by R



subset(df, is.na(df$make) | is.na(df$model) | is.na(df$trim) | is.na(df$body) | is.na(df$transmission))

# The numerical columns have N/A values. The categorical columns have blanks "" instead

colSums(df == "")    # number of blanks "" in each column

# Remove rows with "" values in these columns
df <- subset(df, make != "" & model != "" & trim != "" & body != "" & vin != "" & color != "" & interior != "" & saledate != "")


# Transmission Column
unique(df$transmission) 

# Replace "" in transmission column with "Other"
nrow(subset(df, transmission == "")) # 63k rows have blank "" transmission
df$transmission[df$transmission == ""] <- "Other"

colSums(df == "")

unique(df$transmission) 

df$transmission[df$transmission == 'sedan'] <- 'Sedan'
nrow(subset(df, df$transmission == 'Sedan')) # there are 22 rows with 'sedan' transmission

# Removing them
df <- subset(df, transmission != "Sedan")

unique(df$transmission)

# Changing the casing
df$transmission[df$transmission == 'automatic'] <- 'Automatic'
df$transmission[df$transmission == 'manual'] <- 'Manual'
unique(df$transmission)
colSums(df == "")


# Spelling check
unique(df$make)
unique(df$model)

unique(df$body) # There are casing differences in body
df$body <- tools::toTitleCase(tolower(df$body))  # changing the casing to Title Casing
unique(df$body)


# Color Column
table(df$color) # There are a few number values
subset(df, grepl("^[0-9]+$", color))  # df where color are numbers
df <- subset(df, !grepl("^[0-9]+$", color))  # removing rows with numbers as color 
table(df$color)

# There is '—' color with 24k rows
df[df$color == '—']
# Changing it to 'Unkown'
df$color[df$color == '—'] <- "Unknown"
table(df$color)


# Interior column
unique(df$interior)
nrow(subset(df, interior == '—'))  # there are 16k '-' values
# Changing it to 'Unkown'
df$interior[df$interior == '—'] <- "Unknown"
table(df$interior)


# Model column
# There are differences in casing. ex: 'accord' and 'Accord'
df$model <- tools::toTitleCase(tolower(df$model))
unique(df$model)


# Saledate column
summary(df$saledate)
head(df$saledate) # Stored as "Tue Dec 16 2014 12:30:00 GMT-0800 (PST)"


# Create a new column with YYYY-MM-DD
df$saledate_clean <- as.POSIXct(df$saledate, format = "%a %b %d %Y %H:%M:%S", tz = "GMT")
df$saledate_clean <- as.Date(df$saledate_clean)
head(df$saledate_clean)


# Replace N/A values
colSums(is.na(df))

# odometer and mmr have very few N/A values so drop them

df <- subset(df, !is.na(odometer))
df <- subset(df, !is.na(mmr))
colSums(is.na(df))

# Now, let's deal with condition. It has 11,000 N/A values
summary(df$condition)

hist(df$condition,
     main = "Distribution of Vehicle Condition",
     xlab = "Condition Rating",
     col = "lightblue",
     border = "white")

# Left skewed; median > mean
# replace NA values in condition with median
median(df$condition, na.rm = TRUE)  # na.rm means ignore NA when computing median
df$condition[is.na(df$condition)] <- median(df$condition, na.rm = TRUE)

colSums(df == "" | is.na(df))  # No more NA and "" values

nrow(df)

# Duplicate Data

sum(duplicated(df))  # 0 duplicate rows

sum(duplicated(df$vin)) # 8272 duplicate vins

length(unique(df$vin)) # How many unique vins?

# creating a df that has the duplicate vins for analysis
duplicated_vins <- df$vin[duplicated(df$vin)]
subset(df, vin %in% duplicated_vins)

dupes <- subset(df, vin %in% duplicated_vins)
dupes <- dupes[order(dupes$vin),]  # ordering to see what the differences are. saledate? saleprice?
View(dupes)
# The duplicate vins have different sale date and selling price
# Meaning, these cars were resold again
# Keep these duplicates if you want to analyze resale of used cars
# Possibly make 2 datasets; 1 clean without dupes and 1 dupes

# Keep only the first sale of each vin in the main df
df <- df[order(df$vin, df$saledate), ]
df_unique <- df[!duplicated(df$vin), ]
nrow(df_unique)


# Download the cleaned df
write.csv(df_unique, "car_prices_clean_main.csv", row.names = FALSE)
write.csv(dupes, "car_prices_clean_dupes.csv", row.names = FALSE)




