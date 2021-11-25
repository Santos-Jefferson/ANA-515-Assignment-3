library(tidyverse)
library(lubridate)

# 2.	Limit the dataframe to the following columns: (10 points)
# •	the beginning and ending dates and times (make sure to keep BEGIN_DATE_TIME and END_DATE_TIME) 
# •	the episode ID
# •	the event ID
# •	the state name and FIPS
# •	the “CZ” name
# •	type
# •	FIPS
# •	the event type 
# •	the source
# •	the beginning latitude and longitude and ending latitude and longitude 
df <- read.csv("StormEvents_details-ftp_v1.0_d1985_c20210803.csv")
df <- select(df, BEGIN_DATE_TIME, END_DATE_TIME, EPISODE_ID, EVENT_ID, STATE,
             STATE_FIPS, CZ_NAME, CZ_TYPE, CZ_FIPS, EVENT_TYPE, SOURCE,
             BEGIN_LAT, BEGIN_LON, END_LAT, END_LON)


# 3.	Convert the beginning and ending dates (BEGIN_DATE_TIME and END_DATE_TIME)
# to a “date-time” class (there should be one column for the beginning date-time 
# and one for the ending date-time) (5 points) 
df$BEGIN_DATE_TIME <- dmy_hms(df$BEGIN_DATE_TIME)

# 4.	Change state and county names to title case (e.g., “New Jersey” instead of
#                                                 “NEW JERSEY”) (5 points) 
df$STATE <- str_to_title(df$STATE)
df$CZ_NAME <- str_to_title(df$CZ_NAME)

# 5.	Limit to the events listed by county FIPS (CZ_TYPE of “C”) and then remove
# the CZ_TYPE column (5 points) 
df <- filter(df, CZ_TYPE == "C")
df <- select(df, -CZ_TYPE)

# 6.	Pad the state and county FIPS with a “0” at the beginning (hint: there’s a 
# function in stringr to do this) and then unite the two columns to make one fips
# column with the 5 or 6-digit county FIPS code (5 points) 
df$STATE_FIPS <- str_pad(df$STATE_FIPS, width=3, side="left", pad="0")
df$CZ_FIPS <- str_pad(df$CZ_FIPS, width=3, side="left", pad="0")
df <- unite(df, sep="", "NEW_FIPS", c("STATE_FIPS", "CZ_FIPS"), remove=FALSE)

# 7.	Change all the column names to lower case (you may want to try the 
# rename_all function for this) (5 points) 
names(df) <- tolower(names(df))

# 8.	There is data that comes with base R on U.S. states (data("state")).
# Use that to create a dataframe with these three columns: state name, area,
# and region (5 points)
data("state")
us_state_info <- data.frame(state=state.name, region=state.region, area=state.area)

# 9.	Create a dataframe with the number of events per state in the year of
# your birth. Merge in the state information dataframe you just created in
# step 8. Remove any states that are not in the state information dataframe.
# (5 points) 
df_events_state <- data.frame(table(df$state))
df_events_merged <- rename(df_events_state, c("state"="Var1"))

# 10.	Create the following plot (10 points): 
library(ggplot2)
storm_plot <- ggplot(us_state_info, aes(x = area, y = df_events_merged$Freq)) +
  geom_point(aes(color = region)) +
  labs(x = "Land area (square miles)",
       y = "# of storm events in 1985")
storm_plot












