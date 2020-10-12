library( ggplot2 )


marathonLaps <- c( 1:26 )

pikespeak2019 <- c( "8:07", "12:13", "13:46", "13:22", "13:16", "10:55", "10:59", "14:21", "16:44", "17:54", "15:59", "17:44", "20:01",
                   "13:14", "9:07", "8:32", "9:08", "8:03", "7:54", "7:53", "7:47", "7:06", "7:31", "7:41", "7:41", "7:02" )

pikespeak2019 <- sapply( strsplit( pikespeak2019, ":" ),
  function(x) {
    x <- as.numeric(x)
    x[1]+x[2]/60
    }
)

pikespeak2019_cumAvg <- cumsum( pikespeak2019 ) / marathonLaps


pikespeak_df <- data.frame( Mile = as.numeric( marathonLaps ),
                           Splits = c( pikespeak2019, pikespeak2019_cumAvg ),
                           Group = as.factor( c( rep( "2019Splits", length( marathonLaps ) ),
                                                 rep( "2019CumAvg", length( marathonLaps ) ) ) ) )

myPlot <- ggplot( data = pikespeak_df ) +
          geom_line( aes( x = Mile, y = Splits, color = Group ) )

ggsave( "/Users/ntustison/Desktop/pikespeak.pdf", myPlot, height = 3, width = 7, units = 'in' )