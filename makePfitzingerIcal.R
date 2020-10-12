library( lubridate )

#############

marathonGoalDate <- ymd( 20210214 )
# plan <- read.csv( "PfitzingerPlans/Pfitzinger_70to85_12week.csv", header = TRUE )
plan <- read.csv( "PfitzingerPlans/Pfitzinger_55to70_18week.csv", header = TRUE )
# plan <- read.csv( "PfitzingerPlans/Pfitzinger_MultipleMarathons_10week.csv", header = TRUE )
outputFile <- "plan.ics"

##############

weeks <- unique( plan$WeeksToGoal )
numberOfWeeks <- length( weeks )
numberOfDays <- numberOfWeeks * 7

startDate <- marathonGoalDate - numberOfDays + 1
currentDate <- startDate

text <- c()
text <- append( text, "BEGIN:VCALENDAR" )
text <- append( text, "VERSION:2.0" )

index <- 1
for( i in seq_len( numberOfWeeks ) )
  {
  text <- append( text, "BEGIN:VEVENT" )
  text <- append( text, "CLASS:PUBLIC" )
  text <- append( text, "DESCRIPTION:" )

  text <- append( text, paste0( "DTSTART;VALUE=DATE:", format( currentDate, "%Y%m%d" ) ) )
  text <- append( text, paste0( "DTEND;VALUE=DATE:", format( currentDate + 7, "%Y%m%d" ) ) )
  text <- append( text, "LOCATION:" )
  text <- append( text, paste0( "SUMMARY;LANGUAGE=en-us:Week ", plan$WeeksToGoal[index], ", weekly mileage: ", plan$WeeklyTotal[index] ) )

  text <- append( text, "TRANSP:TRANSPARENT" )
  text <- append( text, "END:VEVENT" )

  for( j in seq_len( 7 ) )
    {
    text <- append( text, "BEGIN:VEVENT" )
    text <- append( text, "CLASS:PUBLIC" )
    text <- append( text, "DESCRIPTION:" )

    text <- append( text, paste0( "DTSTART;VALUE=DATE:", format( currentDate, "%Y%m%d" ) ) )
    text <- append( text, paste0( "DTEND;VALUE=DATE:", format( currentDate, "%Y%m%d" ) ) )
    text <- append( text, "LOCATION:" )
    text <- append( text, paste0( "SUMMARY;LANGUAGE=en-us:", plan$Event[index] ) )

    text <- append( text, "TRANSP:TRANSPARENT" )
    text <- append( text, "END:VEVENT" )

    currentDate <- currentDate + 1
    index <- index + 1
    }
  }
text <- append( text, "END:VCALENDAR" )

fileConnection <- file( outputFile )
writeLines( text, fileConnection )




