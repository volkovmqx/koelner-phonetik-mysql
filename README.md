Implementation of the German Soundex function in Mysql using the Kölner Phonetik Algorithm. 
Base code is taken from this post, i had to do some migration so it works in mysql: https://bit.ly/2LHqxyE

Unfortunately, this implementation is so slow, when running against the same dataset, i got 325.048 sec vs 0.159 sec when using soundex.I also don't have the time to optimize. Any PR is welcome ^^

