# Movie-App-TMDb-
Cricbuzz iOS Developer Assignment - Movie App (TMDb)

API KEY : a9091bbe2cd61ed22263e3892e642610

Importent note: 
** API is only can access connected with VPN ** phone or lap should be connected to VPN 
I Used Proton VPN for development process

Setup:

The app requires a TMDb API key to fetch movie data. You need to register on TMDb and obtain an API key, which should be configured in the app.

The app is built with SwiftUI for iOS 16+ and uses Combine for reactive data handling.

No external dependencies are required; all functionality (image caching, networking, etc.) is implemented internally.

To build and run the app: open the project in Xcode 14 or higher, configure the API key, and run on a simulator or device.



Assumptions:

Movies are fetched from TMDb's popular movies endpoint and search endpoint.

Pagination is implemented for the popular movies list, loading additional pages dynamically when scrolling.

Favorites are stored locally on the device.

Images are cached for faster loading and animated when displayed.

The search functionality dynamically updates results as the user types.




Implemented Features:

Home Screen

Displays popular movies in a 3-column grid.

Supports lazy loading and pagination.

Pull-to-refresh is implemented to reload the movie list.

Movies can be searched using a dynamic search bar.


Movie Detail Screen

Shows movie details: title, overview, rating, release date, and runtime.

Displays cast and crew, including profile images.

Supports YouTube trailers embedded via API.


Favorites

Users can mark/unmark movies as favorite.

Favorites are persisted locally across app launches.


Images

CachedImage component fetches images asynchronously.

Smooth fade-in animation for images as they load.

Supports different shapes (rectangle and circle).




Known Limitations:

No offline support; the app requires an internet connection to fetch movies.

Pagination for search results is not fully implemented (only one page is fetched at a time).

Only YouTube trailers are supported.

App supports English only; no localization is implemented.


