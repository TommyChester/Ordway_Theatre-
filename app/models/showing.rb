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
        if seat_row.to_f / venueRows  < 0.333
            return 0.25
        elsif seat_row.to_f / venueRows < 0.666
            return 1.0
        else
            return 0.8
        end
    end

    #defining column values will be the same for all types of showing. My thoughts
    # that the very middle 10% are fairly negligible in difference, the next 20%
    # (so total the middle 50%)on each side drop in desireabiliy linearly
    # the last side 25% drop exponentially.  
    def point_column(seat_column)
        #shift to have middle seats at or around zero, use abs to fold over
        #the origin make both sides similar
        shift_amount = venueColumns / 2.0
        seat_num = (seat_column.to_f - shift_amount).abs
        seat_percentage = seat_num / shift_amount
        if seat_percentage < 0.1
            return 1.0
        elsif seat_percentage <0.5
            return 1.0 - seat_percentage
        else
            return 1.0 - seat_percentage**(0.5)
        end
    end

    #Now define total point per seat (gave weighting option for forward importance), I 
    #might use in the future. 
    def seat_point(row, column,weight_non_movies=1)
        (is_movie? ? point_per_movie_seat_row(row) : (weight_non_movies)*point_per_non_movie_seat_row(row)) + point_column(column)
    end

    #at this point I have all the logic for a single ticket. Now it gets 
    # interesting, multiple tickets. The first thing I am going to do
    # is say given a set of seats how many connections are their divided by 
    # the number of seats So for 1 ticket it would always be 1, two tickets 
    # can be 0,1. Three can have 0,1,2,3 (I am counting diagonal as connection)
    # four can have 0-6. I believe that it is summation of n choose k from 1 to n

    # first I need to say to to seats touch, var input is array [row,column]
    def seats_touch?(seat_a, seat_b)
        #I actually need to redefine the letters to numbers
        # I believe I will only use here so I wont hang on it 
        def row_to_num(input)
            #simply create an array of the alphabet but up to the 
            # double alphabet for more than 26. Then just index the row.
            ("a".."zz").to_a.index(input[0])
        end
        
        #check to see if column number are <= 1 different from eachother
        col_off = (seat_a[1]-seat_b[1]).abs <= 1 
        row_off = (row_to_num(seat_a[0])-row_to_num(seat_b[0])).abs <= 1
        puts col_off 
        col_off && row_off
    end

    #now the function to run through all the permutations
    def seats_connect

    
end
