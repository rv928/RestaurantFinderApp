# RestaurantFinderApp
 RestaurantFinderApp

## Installation

- Download and install Mac OS 10.15.4 and Xcode 11.3.1  , 
- Checkout develop branch Code from Github.

## Language
- Swift 5

## Support
- App and code supports for iOS 13 and later devices(iPhone) only.

## Architeture
- Bob's VIP Clean Swift Architecture

## Tests
- UI Test cases

# Features
- LocationManager
- Geocoding
- Apple Maps

## Sample Usecase guide (Tested from simulator only, not real device): 

Due to Google place API are paid now, I used apple's in-built functionality only for 1 location.

1. Searching location for ex. type "Bonchon" in searchbar
2. Results will be displayed which are related "Bonchon"
3. Clicking on one of the results from tableview, user will redirect to mapview with pinned location.
4. Clicking on pinned location, 1 AnnotationCalloutAccessoryView will be opened.
5. Clicking on restaurant icon button, user will be redirected to Maps application for directions and route selection.


## License
[MIT](https://choosealicense.com/licenses/mit/)
