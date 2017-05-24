# GooglePlaces
A very basic UI for Google Places without RxSwift

Implements the same functionality as the main branch and reuses some of its code, but without RxSwift. Some highlights:
- extensive use of delegates (both standard and app specific) makes the code much more verbose and difficult to read (in the RxSwift version, everything is in one place)
- many "standard" tasks need to be implemented manually (such as searching with a delay or canceling a started request) which increases the possibliity for bugs
- the completion API inside PlacesAPI doesn't scale well and is much more verbose (if the code needed to make nested network requests, this would stand out even more).
