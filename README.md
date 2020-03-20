# ZomatoDart
## A wrapper for the Zomato API implemented in Dart
https://developers.zomato.com/api

## Usage:
A user key must be provided to initialize the ZomatoDart object.
Convenience methods are used to fetch responses and await Futures of the corresponding model:
<pre>
await ZomatoDart(<i>userKey</i>).<i>convenienceMethod</i>()
</pre>


## Convenience Methods:
- .categories
- .cities
- .cuisines
- .establishments
- .locations
- .locationDetails
- .geocode
- .restaurant
- .restaurantSearch
- .dailyMenus
- .reviews

## Notes
- Organization of the methods and models is based upon the organization of the API documentation.
- This package is meant to be platform agnostic, in order to be usable on mobile, web and desktop.


