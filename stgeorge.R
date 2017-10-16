library( ggplot2 )


marathonLaps <- c( 1:26, 26.2 )

# [64 - 89 degress] mean: 76

stgeorge2016 <- c( "7:09", "7:03", "6:50", "6:44", "6:49", "6:45", "6:46", "7:26", "7:19", "7:00", "7:10", "6:58", "6:37",  
                   "6:45", "6:47", "6:39", "6:41", "6:38", "6:57", "6:28", "6:11", "6:30", "6:29", "6:23", "6:32", "6:24",
                   "6:46" )

stgeorge2016 <- sapply( strsplit( stgeorge2016, ":" ),
  function(x) {
    x <- as.numeric(x)
    x[1]+x[2]/60
    }
)

stgeorge2016_cumAvg <- cumsum( stgeorge2016 ) / marathonLaps


# [57 - 82 degress] mean: 70

stgeorge2015 <- c( "7:32", "7:18", "6:41", "6:44", "6:40", "6:42", "6:37", "7:27", "7:14", "7:08", "7:27", "7:07", "6:47",
                   "6:53", "6:35", "6:23", "6:42", "6:38", "7:21", "6:55", "6:36", "7:14", "8:04", "7:58", "8:27", "8:34",
                   "8:02" )                   

stgeorge2015 <- sapply( strsplit( stgeorge2015, ":" ),
  function(x) {
    x <- as.numeric(x)
    x[1]+x[2]/60
    }
)

stgeorge2015_cumAvg <- cumsum( stgeorge2015 ) / marathonLaps

stgeorge_df <- data.frame( Mile = as.numeric( marathonLaps ),  
                           Splits = c( stgeorge2015, stgeorge2015_cumAvg, stgeorge2016, stgeorge2016_cumAvg ), 
                           Group = as.factor( c( rep( "2015Splits", length( marathonLaps ) ), 
                                                 rep( "2015CumAvg", length( marathonLaps ) ),
                                                 rep( "2016Splits", length( marathonLaps ) ),
                                                 rep( "2016CumAvg", length( marathonLaps ) ) 
                                            ) )
                         )

myPlot <- ggplot( data = stgeorge_df ) + 
          geom_line( aes( x = Mile, y = Splits, color = Group ) )

ggsave( "/Users/ntustison/Desktop/stgeorge.pdf", myPlot, height = 3, width = 7, units = 'in' )