# README

##Launch Locally 
1. First Clone Repo
2. If you do not have Node.js, please install https://nodejs.org/en/download/
3. If you do not have Yarn Please install via:
```brew install yarn```
4. if you do not have rails please install via:
```gem install rails```
5. If you do not have PostgrSQL
```brew install postgre```
6. Launch PG 
```pg_ctl -D /usr/local/var/postgres start ```
7.  Make sure you are in the project directory and Rake to set up db:
``` rake db:setup ```
8. Install Gem Bundle
```bundle install ```
9. Boot er' up:
 ```rails s```
10. Go to url described by cli

##Using the app
Clearly it has the best design that you have seen and no description is needed as it speaks for itself (jokes). If you click to add a new showing on the home page it will allow you add a showing, it allows for name, type of show and body. The boy would be where you put in the json blob. 

If you click on a shwoing it will just show you what the best seat pairing is (or best seat). You can edit or add more. 

This is clearly not my best work, but it is a quick mock up of what could be done. 

Assumptions of assignment:
1. That the json blob will never show missing available seats. 
2. Though it is probably unrealistic, for this particular exercise I am going to assume that venues are rectangular and every row has the same number column intersections and every column has the same number for row interactions.
3. Unless the show type is a movie, more forward is better, for movies it too close is bad and too far back is bad(but not as intense as concerts). With that said, at a concert the difference between a row 1 and row 2 is vastly larger than the difference between 107 and 108. 
    a. So for non-movie type showings I am going to use expontial decay to describe the pointing for rows.
    b. For movies I am going to use a Poisson Distribution just because I think it fits in my mind what works (not a rigorous reason).
4. Seats together on the same row are not quite as important as seats connected, i.e, if you have nine ticket  a7,a8,a9,b7,b8,b9,c7,c8,c9  that would likely be better than a4-12. 


