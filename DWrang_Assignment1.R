
#Install Libraries
install.packages("dplyr")
install.packages("tidyr")

# Upload date file
# refine_Original.csv
dfref <- read.csv("refine_original.csv")

# Part 1. Correcting the Company Names

# I am using regular exressions for the following

dfref$company <- gsub(".*s$", "philips", dfref$company,ignore.case = TRUE)
dfref$company <- gsub(".*[0|o]$", "akzo", dfref$company,ignore.case = TRUE)
dfref$company <- gsub("^[Vv](.*)n", "van houten", dfref$company,ignore.case = TRUE)
dfref$company <- gsub(".*r$", "unilever", dfref$company,ignore.case = TRUE)

# Part 2. Separating the product code and numbers in colmuns

# Using the tidyr

library(tidyr)

dfref <- dfref %>% separate(Product.code...number, c("product_code","product_number"), sep="-")


# Part 3. Adding the product category

# Define the lookup table

lut <- c("p" = "Smartphone","v" = "TV","x" = "Laptop", "q" = "Tablet")

# Use Dplyr to define a new column which "recodes" the product code column based on look-up tables

library(dplyr)

dfref <- dfref %>% mutate(product_category = recode(product_code, !!!lut))

# Part 4. Add full address

# We just want to combine the three columns so we use the unite command

# This replaces the three columns with one single column


dfref <- dfref %>% unite(full_address, c(address,city,country), sep = ",")

# Part 5.1. Create Dummy Variable for Comapny

dfref <- dfref %>% mutate(company_philips = ifelse((company=="philips"),1,0),company_akzo = ifelse((company=="akzo"),1,0),company_van_houten = ifelse((company=="van houten"),1,0), company_unilever = ifelse((company=="unilever"),1,0))

# Other ways for same approach

# dfref <- dfref %>% mutate(company_philips = (company=="philips"),company_akzo = (company=="akzo"),company_van_houten = (company=="van houten"), company_unilever = (company=="unilever"))

# dfref$company_philips <- as.binary(dfref$company_philips)
# dfref$company_akzo <- as.binary(dfref$company_akzo)
# dfref$company_van_houten <- as.binary(dfref$company_van_houten)
# dfref$company_unilever <- as.binary(dfref$company_unilever)

# Part 5.2. Create Dummy Variable for Product Category

dfref <- dfref %>% mutate(product_smartphone = ifelse((product_category=="Smartphone"),1,0),product_tv = ifelse((product_category=="TV"),1,0),product_laptop = ifelse((product_category=="Laptop"),1,0), product_tablet = ifelse((product_category=="Tablet"),1,0))


str(dfref)
