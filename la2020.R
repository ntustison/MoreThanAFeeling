library( ggplot2 )


marathonLaps <- c( 1:26, 26.2 )

la2020 <- c( "7:02", "6:38", "6:42", "6:45", "7:05", "7:03", "6:39", "6:41", "6:48", "6:39", "6:44", "6:39", "6:46",
             "6:38", "6:21", "6:29", "6:44", "6:38", "6:36", "6:28", "6:51", "6:26", "6:29", "6:20", "6:02", "5:48",
             "5:43" )

la2020 <- sapply( strsplit( la2020, ":" ),
  function(x) {
    x <- as.numeric(x)
    x[1]+x[2]/60
    }
)

la2020_cumAvg <- cumsum( la2020 ) / marathonLaps

la_df <- data.frame( Mile = as.numeric( marathonLaps ),
                     Splits = c( la2020, la2020_cumAvg ),
                     Group = as.factor( c( rep( "2020Splits", length( marathonLaps ) ),
                                           rep( "2020CumAvg", length( marathonLaps ) )
                                      ) )
                         )

myPlot <- ggplot( data = la_df ) +
          geom_line( aes( x = Mile, y = Splits, color = Group ) )

ggsave( "/Users/ntustison/Desktop/la2020.pdf", myPlot, height = 3, width = 7, units = 'in' )