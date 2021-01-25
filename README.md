# README
Assumptions of assignment:
1. That the json blob will never show missing available seats. 
2. Though it is probably unrealistic, for this particular exercise I am going to assume that venues are rectangular and every row has the same number column intersections and every column has the same number for row interactions.
3. Unless the show type is a movie, more forward is better, for movies it too close is bad and too far back is bad(but not as intense as concerts). With that said, at a concert the difference between a row 1 and row 2 is vastly larger than the difference between 107 and 108. 
    a. So for non-movie type showings I am going to use expontial decay to describe the pointing for rows.
    b. For movies I am going to use a Poisson Distribution just because I think it fits in my mind what works (not a rigorous reason).
4. Seats together on the same row are not quite as important as seats connected, i.e, if you have nine ticket  a7,a8,a9,b7,b8,b9,c7,c8,c9  that would likely be better than a4-12. 


