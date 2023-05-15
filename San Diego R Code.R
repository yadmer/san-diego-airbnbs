getwd()

#I USED '****' JUST TO HIDE INFORMATION ABOUT MY COMPUTER, BUT THAT IS THE ROUTE TO GET TO THE FILE
setwd("/****/****/****/****/AIRBNB_DATASET")

#UPLOADING DATA

sdairbnb <- read.csv("San Diego Clean Data.csv", header = TRUE)


library(ggplot2)

# 1- TOP 5 CITIES WITH NUMBER OF LISTINGS  

sdairbnb_filtered <- subset(sdairbnb, price <= 2500 & number_of_reviews > 0)

top_cities <- names(sort(tapply(sdairbnb_filtered$number_of_reviews, sdairbnb_filtered$city, sum), decreasing = TRUE))[1:5]

sdairbnb_top_cities <- sdairbnb_filtered[sdairbnb_filtered$city %in% top_cities,]

ggplot(sdairbnb_top_cities, aes(x = number_of_reviews, y = price, color = city)) +
  geom_point(alpha = 0.4) +
  ggtitle("TOP 5 CITIES") +
  labs(x = "Number of Listings", y = "Price", color = "CITY") +
  theme(plot.title = element_text(size = 25, face = "bold"),
        axis.title = element_text(size = 20, face = "bold"),
        axis.text = element_text(size = 15, face = "bold"),
        legend.title = element_text(size = 20, face = "bold"),
        legend.text = element_text(size = 15, face = "bold"),
        legend.position = c(0.8, 0.9)) 


# 2- TOP 5 NEIGBOURHOODS WITH 100+ BOOKINGS 

sdairbnb_filtered <- subset(sdairbnb, price <= 2500 & number_of_reviews > 100)

top_neighborhoods <- names(sort(tapply(sdairbnb_filtered$number_of_reviews, sdairbnb_filtered$neighbourhood, sum), decreasing = TRUE))[1:5]

sdairbnb_top_neighborhoods <- sdairbnb_filtered[sdairbnb_filtered$neighbourhood %in% top_neighborhoods,]

ggplot(sdairbnb_top_neighborhoods, aes(x = number_of_reviews, y = price, color = neighbourhood, size = I(2))) +
  geom_point(alpha = 0.5) +
  ggtitle("TOP 5 AIRBNB NEIGHBORHOODS WITH 100+ BOOKINGS ") +
  labs(x = "Number of Bookings", y = "Price", color = "NEIGHBORHOODS") +
  theme(plot.title = element_text(size = 25, face = "bold"),
        axis.title = element_text(size = 20, face = "bold"),
        axis.text = element_text(size = 15, face = "bold"),
        legend.title = element_text(size = 20, face = "bold"),
        legend.text = element_text(size = 15, face = "bold"),
        legend.position = c(0.8, 0.8))

# 3- AVERAGE PRICE FOR AIRBNBS OVERALL AND WITH 4.95 RATING BY TOP 5 CITIES
#    (THE TOP 5 CITIES ARE BASED ON THE NUMBER OF BOOKINGS)

# 3.1 AVERAGE PRICE FOR AIRBNBS OVERALL TOP 5 CITIES WITH 1+ BOOKING

sdairbnb_filtered <- subset(sdairbnb, number_of_reviews > 0)

city_avg_price <- aggregate(sdairbnb_filtered$price, list(sdairbnb_filtered$city), mean)
names(city_avg_price) <- c("city", "average_price")

top_cities <- names(sort(tapply(sdairbnb_filtered$number_of_reviews, sdairbnb_filtered$city, sum), decreasing = TRUE))[1:5]

city_avg_price_top <- city_avg_price[city_avg_price$city %in% top_cities,]

new_city_names <- c("Bonita", "Chula Vista", "Del Mar", "La Jolla", "San Diego")

ggplot(city_avg_price_top, aes(x = average_price, y = city)) +
  geom_histogram(stat = "identity", fill = "skyblue", color = "white") +
  geom_text(aes(label = paste0("$", round(average_price))), hjust = -0.2, color = "black") +
  labs(x = "Average Price", y = "City", title = "AVERAGE PRICE FOR THE TOP 5 CITIES WITH THE MOST BOOKINGS") +
  scale_y_discrete(labels = new_city_names) +
  theme(plot.title = element_text(size = 20, face = "bold"),
        axis.title = element_text(size = 15, face = "bold"),
        axis.text = element_text(size = 15, face = "bold"))

# 3.2 AVERAGE PRICE FOR AIRBNBS OVERALL TOP 5 CITIES WITH 1+ BOOKING AND 4.95+ RATING

sdairbnb_filtered <- subset(sdairbnb, number_of_reviews > 0 & review_scores_rating >= 4.95)

city_avg_price <- aggregate(sdairbnb_filtered$price, list(sdairbnb_filtered$city), mean)
names(city_avg_price) <- c("city", "average_price")

top_cities <- names(sort(tapply(sdairbnb_filtered$number_of_reviews, sdairbnb_filtered$city, sum), decreasing = TRUE))[1:5]

city_avg_price_top <- city_avg_price[city_avg_price$city %in% top_cities,]

new_city_names <- c("Chula Vista", "Del Mar", "La Jolla", "La Mesa", "San Diego")

ggplot(city_avg_price_top, aes(x = average_price, y = city)) +
  geom_histogram(stat = "identity", fill = "skyblue", color = "white") +
  geom_text(aes(label = paste0("$", round(average_price))), hjust = -0.2, color = "black") +
  labs(x = "Average Price", y = "City", title = "AVERAGE PRICE FOR TOP 5 CITIES WITH MOST BOOKINGS & 4.95+ RATING") +
  scale_y_discrete(labels = new_city_names) +
  theme(plot.title = element_text(size = 20, face = "bold"),
        axis.title = element_text(size = 15, face = "bold"),
        axis.text = element_text(size = 15, face = "bold"))



# 4- OVERALL AVERAGE PRICE FOR TOP 5 NEIGBORHOODS

# 4.1 AVERAGE PRICE FOR AIRBNBS OVERALL TOP 5 NEIGBORHOODS WITH 1+ BOOKING

sdairbnb_filtered <- subset(sdairbnb, number_of_reviews > 0 )

neighbourhood_avg_price <- aggregate(sdairbnb_filtered$price, list(sdairbnb_filtered$neighbourhood), mean)
names(neighbourhood_avg_price) <- c("neighbourhood", "average_price")

top_neighbourhoods <- names(sort(tapply(sdairbnb_filtered$number_of_reviews, sdairbnb_filtered$neighbourhood, sum), decreasing = TRUE))[1:5]

neighbourhood_avg_price_top <- neighbourhood_avg_price[neighbourhood_avg_price$neighbourhood %in% top_neighbourhoods,]

ggplot(neighbourhood_avg_price_top, aes(x = average_price, y = neighbourhood)) +
  geom_histogram(stat = "identity", fill = "skyblue", color = "white") +
  geom_text(aes(label = paste0("$", round(average_price, 2))), hjust = -0.2, color = "black") +
  labs(x = "Average Price", y = "Neighborhood", title = "AVG PRICE FOR TOP 5 NEIGHBORHOODS BASED ON BOOKINGS") +
  theme(plot.title = element_text(size = 20, face = "bold"),
        axis.title = element_text(size = 15, face = "bold"),
        axis.text = element_text(size = 15, face = "bold"))


# 4.2 AVERAGE PRICE FOR AIRBNBS OVERALL TOP 5 NEIGBORHOODS WITH 1+ BOOKING AND 4.95+ RATING

sdairbnb_filtered <- subset(sdairbnb, number_of_reviews > 0 & review_scores_rating >= 4.95)

neighbourhood_avg_price <- aggregate(sdairbnb_filtered$price, list(sdairbnb_filtered$neighbourhood), mean)
names(neighbourhood_avg_price) <- c("neighbourhood", "average_price")

top_neighbourhoods <- names(sort(tapply(sdairbnb_filtered$number_of_reviews, sdairbnb_filtered$neighbourhood, sum), decreasing = TRUE))[1:5]

neighbourhood_avg_price_top <- neighbourhood_avg_price[neighbourhood_avg_price$neighbourhood %in% top_neighbourhoods,]

ggplot(neighbourhood_avg_price_top, aes(x = average_price, y = neighbourhood)) +
  geom_histogram(stat = "identity", fill = "skyblue", color = "white") +
  geom_text(aes(label = paste0("$", round(average_price, 2))), hjust = -0.2, color = "black") +
  labs(x = "Average Price", y = "Neighborhood", title = "AVG PRICE FOR TOP 5 NEIGHBORHOODS WITH 4.95+ RATING") +
  theme(plot.title = element_text(size = 20, face = "bold"),
        axis.title = element_text(size = 15, face = "bold"),
        axis.text = element_text(size = 15, face = "bold"))



# 5. SAN DIEGO


# 5.1 TOP 5 PROPERTIES IN SAN DIEGO WITH 1+ BOOKING 

# Filter by price and number of reviews
sdairbnb_filtered <- subset(sdairbnb, number_of_reviews > 0)
#Without 4.95 filter 
sdairbnb_filtered <- subset(sdairbnb, number_of_reviews > 0 )


# Get the top city by number of listings
top_city <- names(sort(table(sdairbnb_filtered$city), decreasing = TRUE))[1]

# Filter by the top city
city_data <- sdairbnb_filtered[sdairbnb_filtered$city == top_city, ]

# Aggregate by property type
agg_data <- aggregate(id ~ property_type, data = city_data, FUN = function(x) length(unique(x)))

# Get the top 5 property types by number of listings
top_property_types <- head(with(agg_data, property_type[order(id, decreasing = TRUE)]), 5)

# Filter the aggregated data by the top property types
agg_data_top_property_types <- subset(agg_data, property_type %in% top_property_types)

# Sort the data by number of listings
agg_data_top_property_types <- agg_data_top_property_types[order(agg_data_top_property_types$id, decreasing = TRUE),]


# Plot the results

ggplot(agg_data_top_property_types, aes(x = id, y = property_type, fill = property_type)) +
  geom_bar(stat = "identity", position = "dodge") +
  ggtitle("TOP 5 PROPERTY TYPES IN SAN DIEGO") +
  labs(x = "NUMBER OF LISTHINGS", y = "PROPERTY TYPES", fill = "Top 5 Property Types") +
  scale_fill_brewer(palette = "Dark2") +
  theme(plot.title = element_text(size = 25, face = "bold"),
        axis.text = element_text(size = 15, face = "bold",hjust = 0),
        axis.title = element_text(size = 10, face = "bold"),
        legend.text = element_text(size = 12)) +
  theme(legend.position = "none")




# 5.2 TOP 5 PROPERTIES IN SAN DIEGO WITH 1+ BOOKING AND 4.95+ RATING

# Filter by price and number of reviews
sdairbnb_filtered <- subset(sdairbnb, number_of_reviews > 0  & review_scores_rating >= 4.95)
#Without 4.95 filter 
sdairbnb_filtered <- subset(sdairbnb, number_of_reviews > 0 )


# Get the top city by number of listings
top_city <- names(sort(table(sdairbnb_filtered$city), decreasing = TRUE))[1]

# Filter by the top city
city_data <- sdairbnb_filtered[sdairbnb_filtered$city == top_city, ]

# Aggregate by property type
agg_data <- aggregate(id ~ property_type, data = city_data, FUN = function(x) length(unique(x)))

# Get the top 5 property types by number of listings
top_property_types <- head(with(agg_data, property_type[order(id, decreasing = TRUE)]), 5)

# Filter the aggregated data by the top property types
agg_data_top_property_types <- subset(agg_data, property_type %in% top_property_types)

# Sort the data by number of listings
agg_data_top_property_types <- agg_data_top_property_types[order(agg_data_top_property_types$id, decreasing = TRUE),]


# Plot the results

ggplot(agg_data_top_property_types, aes(x = id, y = property_type, fill = property_type)) +
  geom_bar(stat = "identity", position = "dodge") +
  ggtitle("TOP 5 PROPERTY TYPES IN SAN DIEGO & 4.95+ RATING") +
  labs(x = "NUMBER OF LISTHINGS", y = "PROPERTY TYPES", fill = "Top 5 Property Types") +
  scale_fill_brewer(palette = "Dark2") +
  theme(plot.title = element_text(size = 25, face = "bold"),
        axis.text = element_text(size = 15, face = "bold",hjust = 0),
        axis.title = element_text(size = 10, face = "bold"),
        legend.text = element_text(size = 12)) +
  theme(legend.position = "none")




# 5.3 TOP 5 PROPERTIES IN SAN DIEGO BEDS, BEDROOMS, ACCOMMODATES

# Subset data for San Diego city
sdairbnb_sd_city <- sdairbnb[sdairbnb$city == "San Diego, California, United States",]

# Subset data for top 5 neighborhoods based on number of listings
top_neighbourhoods <- names(sort(tapply(sdairbnb_sd_city$number_of_reviews, sdairbnb_sd_city$neighbourhood, sum), decreasing = TRUE))[1:5]
sdairbnb_top_neighbourhoods <- sdairbnb_sd_city[sdairbnb_sd_city$neighbourhood %in% top_neighbourhoods,]


# Calculate average number of beds, bedrooms, and accommodates by neighborhood
beds_avg <- aggregate(sdairbnb_top_neighbourhoods$beds, list(sdairbnb_top_neighbourhoods$neighbourhood), mean)
names(beds_avg) <- c("neighbourhood", "avg_beds")

bedrooms_avg <- aggregate(sdairbnb_top_neighbourhoods$bedrooms, list(sdairbnb_top_neighbourhoods$neighbourhood), mean)
names(bedrooms_avg) <- c("neighbourhood", "avg_bedrooms")

accommodates_avg <- aggregate(sdairbnb_top_neighbourhoods$accommodates, list(sdairbnb_top_neighbourhoods$neighbourhood), mean)
names(accommodates_avg) <- c("neighbourhood", "total_accommodates")

# Merge the three data frames
neighbourhood_avg <- merge(beds_avg, bedrooms_avg, by = "neighbourhood")
neighbourhood_avg <- merge(neighbourhood_avg, accommodates_avg, by = "neighbourhood")

# Histograms number of beds
ggplot(neighbourhood_avg, aes(x = avg_beds, y = top_neighbourhoods)) +
  geom_col(fill = "skyblue", color = "white") +
  geom_text(aes(label = round(avg_beds)), vjust = -0.5, color = "black", size = 6, face = "bold") +
  labs(title = "AVERAGE NUMBER OF BEDS IN SAN DIEGO",
       x = "Top 5 Neighborhood",
       y = "Average Number of Beds") +
  theme(plot.title = element_text(size = 20, face = "bold"),
        axis.title = element_text(size = 15, face = "bold"),
        axis.text = element_text(size = 15, face = "bold"))


# Histograms number of bedrooms
ggplot(neighbourhood_avg, aes(x = avg_bedrooms, y = top_neighbourhoods)) +
  geom_col(fill = "skyblue", color = "white") +
  geom_text(aes(label = round(avg_bedrooms)), vjust = -0.5, color = "black", size = 6, face = "bold") +
  labs(title = "AVERAGE NUMBER OF BEDROOMS IN SAN DIEGO",
       x = "Average Number of Bedrooms",
       y = "Top 5 Neighborhood") +
  theme(plot.title = element_text(size = 20, face = "bold"),
        axis.title = element_text(size = 15, face = "bold"),
        axis.text = element_text(size = 15, face = "bold"))


# Histograms number of accommodates
ggplot(neighbourhood_avg, aes(x = total_accommodates, y = neighbourhood)) +
  geom_col(fill = "skyblue", color = "white") +
  geom_text(aes(label = round(total_accommodates)), vjust = -0.5, color = "black", size = 6) +
  labs(title = "AVERAGE NUMBER OF GUESTS IN SAN DIEGO",
       x = "Average Number of Guests",
       y = "Top 5 Neighborhood") +
  theme(plot.title = element_text(size = 20, face = "bold"),
        axis.title = element_text(size = 15, face = "bold"),
        axis.text = element_text(size = 15, face = "bold"))


