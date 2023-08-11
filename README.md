# PlayRadar: Exploring Games with RAWG API

Welcome to PlayRadar, an application designed to provide an immersive experience in the world of gaming by harnessing the power of the RAWG API.

## Features at a Glance

1. **Game Listing**: Discover an extensive list of games, complete with cover images, titles, release dates, and ratings.
2. **Game Details**: Dive deep into the details of your favorite games, including publisher information, play count, and game descriptions.
3. **Favorites List**: Create your personal favorites list, allowing you to keep track of games you love.
4. **Favorite Toggling**: Easily toggle games as favorites with a simple click.

## Tech Stack

PlayRadar is built using modern technologies to ensure a seamless user experience.

1. **Swift**: The primary programming language that powers the application.
2. **UIKit**: The foundation for building the app's user interface.
3. **URLSession**: Leveraged to make efficient network requests to the RAWG API.
4. **CoreData**: The backbone of the local database, used to store game and favorite information.
5. **XCTest**: Employs both Unit Tests and UI Tests to ensure the application's functionality.

## Dependency-free Development

PlayRadar is built without relying on any third-party dependencies. This not only ensures optimal performance but also makes the application more maintainable and secure.

## Architecture Pattern: VIPER

The application architecture follows the VIPER pattern, ensuring clear separation of concerns and promoting modularization for easier maintenance and scalability.

## Modularization for Enhanced Functionality

The PlayRadar project is divided into several modules to enhance flexibility and platform independence:

1. **PlayRadariOS**: The main iOS application module that orchestrates the user interface.
2. **PlayRadarMacOS**: Ensures that core business logic remains platform-independent.
3. **PlayRadar**: Contains the core business logic, making it easy to maintain and extend.
4. **PlayRadarRemote**: Manages API calls to the RAWG API, fetching game data for the app.
5. **PlayRadarLocal**: Handles data storage in the local database, ensuring seamless access to favorites and game details.

Feel free to explore, contribute, and enjoy the world of gaming with PlayRadar!