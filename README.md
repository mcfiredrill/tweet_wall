tweet wall
==========

A processing sketch that scrolls tweets across the screen.

It uses the twitter streaming api to fetch tweets based on a given keyword.

We spin up a thread in the setup method and then add the tweets to an array.
A mutex around the array prevents conflicts from the two threads reading from 
the array.

I originally wanted to use event machine to get the tweets from the streaming
api, but there were problems using event machine with jruby. Luckily, jruby has
better threading than mri ruby anyway, so I just use threads.

Tested with jruby 1.6.

usage
=====
rp5 --jruby watch tweet_wall.rb
