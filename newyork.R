# New York 2018 race planning based on
#
#         https://runnersconnect.net/new-york-city-marathon-race-strategy/
#
# With a goal race pace of 6:29 ---> 2:50 marathon
#

library( ggplot2 )

marathonLaps <- c( 1:26, 26.2 )

newYork <- rep( "6:29", length( marathonLaps ) )

newYork <- sapply( strsplit( newYork, ":" ),
  function(x) {
    x <- as.numeric( x )
    x[1] * 60 + x[2]
    }
)
newYork[27] <- newYork[27] * 0.2

newYork[1] <- newYork[1] + 45          # the first mile should be about 45-60 seconds slow
newYork[2] <- newYork[2] - 15          # Try to stay right on goal marathon EFFORT for the 2nd mile.
                                       # Because of the downhill, marathon pace EFFORT will be about
                                       # 10-15 seconds faster than goal pace.

newYork[3:15] <- newYork[3:15] + 5     # You should plan on being about 5-10 seconds per mile slower
                                       # than goal pace through this section.

newYork[16:20] <- newYork[16:20] - 15  # You don’t want to be more than 10-15 seconds per mile faster
                                       # than goal pace on this section.

newYork[21:23] <- newYork[21:23] + 0   # 20-30 seconds slower than goal pace is ok if you’re not feeling good.
newYork[23:27] <- newYork[23:27] + 0

newYork <- newYork / 60
newYork_cumAvg <- cumsum( newYork ) / marathonLaps
newYork[27] <- newYork[27] / 0.2

newYork_df <- data.frame( Mile = as.numeric( marathonLaps ),
                          Splits = c( newYork, newYork_cumAvg ),
                          Group = as.factor( c( rep( "Splits", length( marathonLaps ) ),
                                                rep( "CumAvg", length( marathonLaps ) )
                                            ) )
                         )

myPlot <- ggplot( data = newYork_df ) +
          geom_line( aes( x = Mile, y = Splits, color = Group ) ) +
          scale_y_continuous( breaks = c( 6.25, 6.50, 6.75, 7.0, 7.25, 7.5 ),
            labels = c( "6:15", "6:30", "6:45", "7:00", "7:15", "7:30" )  )

ggsave( "/Users/ntustison/Desktop/newYork.pdf", myPlot, height = 3, width = 7, units = 'in' )