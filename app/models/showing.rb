class Showing < ApplicationRecord
    # Starting with, just going to allow any JSON, epending on time d
    # I will move to error throwing/validation etc on the wrong json
    # structure
    def jsonChunk
        JSON.parse self.body
    end

    def venueLayout
        jsonChunk["venue"]["layout"]
    end

    # I am not quite sure what I am going to need so I am creating 
    # each possible need and might come back and clear out.
    def venueColumns 
        venueLayout["columns"]
    end

    def venueRows
        venueLayout["rows"]
    end

    #At this point it would make sense to pull out of the model and use
    #Helpers or something else to do much of the logic in. However, I am 
    #trying make an MVP that will likely never be built on top of so I am 
    #going to do the logic in the model. 

    #okay just a clear defining of the open seats
    def availableSeats
        jsonChunk["seats"].map{|x| [x[1]["row"],x[1]["column"]]}
    end

    #so no I am thinking it would best to figure out how to point a seat. 
    #I am going write out some my logic in the readme 
    def is_movie?
        self.type_of_show.downcase == "movie" ? true : false 
    end

    #For a non-movie showing the distribution would be an exponential decay 
    #for how far back is acceptable. To start with I am going to use the 
    #the basic equation e^-x, where x is actually 1 divided by the 
    # total number of rows and multiplied by the actual row number. To make sense of 
    # that look at https://en.wikipedia.org/wiki/Exponential_decay where a 
    #0<=x<5 with a e^-x. 
    def point_per_non_movie_seat_row(seat_row)
        Math.exp(-((1.0/venueRows)*(seat_row-1))) 
    end

    #I was going to use a Poisson distribution but after thinking more about it 
    #I think that a simpiler distrobution of the middle third of the theatre = 1
    # and the first third being .25 points and back third being .8 points accurately
    # Describes the real relationship and not a semi-continous equation. 
    def point_per_movie_seat_row(seat_row)
        puts venueRows
        puts seat_row / venueRows
        if seat_row.to_f / venueRows  < 0.333
            return 0.25
        elsif seat_row.to_f / venueRows < 0.666
            return 1.0
        else
            return 0.8
        end
    end

    #defining column values will be the same for both the 

end
