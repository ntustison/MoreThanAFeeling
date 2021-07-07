library( ggplot2 )
library( lubridate )

powerData <- read.csv( "testLeftVsRight.csv" )
powerData$Leg <- as.factor( powerData$Leg )

powerData$Pace <- sapply(strsplit( powerData$Pace, ":" ),
  function(x) {
    x <- as.numeric(x)
    x[1]+x[2]/60
    }
)

f <- as.formula( "Power ~ Leg + Pace + Cadence + GCT + VO" )
powerLm <- lm( f, powerData )

