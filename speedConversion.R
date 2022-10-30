library( ggplot2 )

mph <- seq( from = 4.0, to = 12, by = 0.1 )
mpm <- rep( 0, length( mph ) )

for( i in seq.int( length( mph ) ) )
  {
  mpm[i] <- 60.0 / mph[i]
  }

speed_df <- data.frame( MilesPerHour = mph, MinutesPerMile = mpm )

myPlot <- ggplot( data = speed_df ) +
          geom_line( aes( x = MilesPerHour, y = MinutesPerMile ) )
ggsave( "/Users/ntustison/Desktop/speed.pdf", myPlot, height = 7, width = 7, units = 'in' )