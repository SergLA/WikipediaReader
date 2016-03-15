# WikipediaReader
This is test task for job application

#
#Task
#
 
Application should load a random Wikipedia article using this link:https://en.wikipedia.org/wiki/Special:Random - it loads random article. User should be able to “re-roll” article if doesn’t like it or finished reading current one. If found interesting article you should be able to share it with your friends and add it to your favorites list. Additionally to see your thought process we would like you to add one feature that you think would make this application better. You can load source code in your Github repository and send us a link.
 
Technical details:
- Application user interface should be compliant with Apple HIG and use standard images provided in SDK.
- Application should use Storyboard as it’s interface.
- Application should “play” nicely on all of devices supporting iOS9 
- As it is 2016 now application should use size classes and application should be Universal binary.
- For iPad application should leverage Split View functionality made available in iOS9.



#
# Implementation details:
#

- Ive added two features:
  * navigation back and forward for web view to provide possibility to dig inside given random theme.
  * store wiki page for offline reading. If page have been stored it will have “folder” image in the list. Note, that you cannot store page without “favouriting” one.
- I’m using separate file as storage for simplicity. From this posing it’s not so hard to go to separate storage of the page html, URLs and (if it will be necessary) images or resources.
- I’m using Size Classes for Launch Screen only because there’s no other place where ones could be useful.


Knowing issues:
- navigation back/forward works only for given page and navigation from those page with help of internal links. After user press “New” again back/forward stack will be drained by web view.