# GooglePlaces
A very basic UI for Google Places using RxSwift.

**Important**: you will need to put in your own Google Places key for the code to work.

Gives an example of using rxSwift and rxCocoa in an iOS app. Some highlights:
- the use of standard components significantly reduces the amount of code and the possibility for bugs
- the search view controller is very simple
- the model transforms the search text into search results (and on the main thread) with only a few
lines of easy to read, declarative code
- the model is stateless
