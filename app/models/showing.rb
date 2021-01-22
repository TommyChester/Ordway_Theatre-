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

    
end
