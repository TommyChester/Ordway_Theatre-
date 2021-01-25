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
        jsonChunk["seats"]
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
        Math.exp(-((1.0/venueRows)*(seat_row.to_f+1))) 
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
    def seat_point(row_num,col_num,weight_non_movies=1)
        (is_movie? ? point_per_movie_seat_row(row_num) + point_column(col_num) : (weight_non_movies)*point_per_non_movie_seat_row(row_num)) + point_column(col_num)
    end

    # now I make chart that holds the values for each seat. returns [row, col, points]
    def seat_point_chart
        hold=[]
        availableSeats.to_a.each do |i| 
            row=i[1]["row"]
            row_num=row_to_num(row)
            col=i[1]["column"]
            sp=[row,col,seat_point(row_num,col)]
            hold.push(sp)
        end
        return hold 
    end

    # helpter for converting row alphabet to number
    def row_to_num(input)
        ("a".."zz").to_a.index(input[0])
    end

    #at this point I have all the logic for a single ticket (essentiall). Now it gets 
    # interesting, multiple tickets. The first thing I am going to do
    # is say given a set of seats how many connections are their divided by 
    # the number of seats So for 1 ticket it would always be 1, two tickets 
    # can be 0,1. Three can have 0,1,2,3 (I am counting diagonal as connection)
    # four can have 0-6. I believe that it is summation of n choose k from 1 to n

    # first I need to say to to seats touch, var input is array [row,column]
    def seats_touch?(seat_a, seat_b)
        #Redefine letters to numbers
        row_a= row_to_num(seat_a[0])
        row_b= row_to_num(seat_b[0])
        #check to see if column number are <= 1 different from eachother
        col_off = (seat_a[1]-seat_b[1]).abs <= 1 
        row_off = (row_a-row_b).abs <= 1
        col_off && row_off
    end

    
    
    #Combinations of available seats by seat number
    def seat_combinations(input_num)
        #dont allow for combination numbers above number of avail seats
        return nil unless input_num < availableSeats.length + 1
        seat_point_chart.combination(input_num).to_a
    
    end

    #input one of seat_combinations subsets
    def how_many_connections(input_set)
        #counter
        hold = 0
        #n choose 2 in double loop format (efficient for choose 2)
        for i in 0..input_set.length-1
            for j in i+1..input_set.length-1
                seat_a = [input_set[i][0],input_set[i][1]]
                seat_b= [input_set[j][0],input_set[j][1]]
                if seats_touch?(seat_a, seat_b)
                    hold += 1
                end
            end
        end
        hold.to_f / input_set.length
    end

    #total Value of an input set I am crudely saying is the sum of the
    #of the points per seat multiplied by the number of seated connections
    # divided by the number of total seats
    def total_value_of_set(input_set)
        pps = input_set.sum{|x| x[2]}
        cv= how_many_connections(input_set)
        cv*pps
    end
    
    # Find which one of the all combinations per ticket number 
    def best_seat_combination(input_num)
        all_sets = seat_combinations(input_num)
        hold_set = []
        hold_val = 0
        all_sets.each do |i|
            tv = total_value_of_set(i)
            if  tv > hold_val
                hold_set = i
                hold_val= tv
            end
        end
        # just add the push to show the total value (might want it)
        hold_set.push(hold_val)
        hold_set
    end

    #Finally here I have all the best seat combinations for each value of 
    # the number of tickets (had to force push 1, because I forgoot to)
    # handle earlier and running out time to work on this. 
    def all_best_seat_combinations
        all_best = [[1,seat_point_chart[seat_point_chart.map{|x| x[2]}.each_with_index.max[1]]]]
        for i in 2..availableSeats.length
            all_best.push([i,best_seat_combination(i)])
        end 
        all_best
    end
end
