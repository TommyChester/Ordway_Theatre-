# README
Assumptions of assignment:
1. That the json blob will never show missing available seats. 
2. Though it is probably unrealistic, for this particular exercise I am going to assume that venues are rectangular and every row has the same number column intersections and every column has the same number for row interactions.
3. Unless the show type is a movie, more forward is better, for movies it too close is bad and too far back is bad(but not as intense as concerts). With that said, at a concert the difference between a row 1 and row 2 is vastly larger than the difference between 107 and 108. 
    a. So for non-movie type showings I am going to use expontial decay to describe the pointing for rows.
    b. For movies I am going to use a Poisson Distribution just because I think it fits in my mind what works (not a rigorous reason).





# Historical Journal
Jan 21. Okay so I went to start this the other day, well... After nokogiri wouldnt load which lead to me realizing that brew and rvm were not working, which lead to me realizing that all my root core Ruby files were all messed up. All attempts to fix this were futile (I even managed to mess the JSON gem which lead to not being to download anything correctly), I decided it was best to reinstall macOS. 

First things first was to get VScode, rails, brew, git, some other things I already forgot running. But at this point I think my ops problems are over until I try to host it on heroku. 


Jan 22. Well I learned last night that I am going on ski trip. Had to get my ski stuff together and I am hoping to get some time today to work on this as I am not going to be able to work on it over the weekend. 

