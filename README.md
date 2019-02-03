# CryptocurrencyPriceApp

Simple app to display current and historical price index of BTC in EUR, USD, GBP. 
The current price index is updating every minute. 
The app also has a today widget to display current price index.

## How to use

Just download the project and open `CryptocurrencyPriceApp.xcodeproj`.

## System requirements

The project was created with Xcode 10.1 (10B61) and Swift 4.2. iOS Deployment Target is 11.0. 

No third party dependencies were used in the project, so no necessary to install any package managers like CocoaPods or Carthage.

## Naming

`Cryptocurrency` word in the project name means the project could be easily extended to provide price index for other cryptocurrencies, not only Bitcoin.

## Implementation

### Share code

As the project has to share the features between main and extenstion targets, there were an idea to put shared code into `CryptocurrencyPriceService` framework. 

The framework provides public access to `PriceIndexService` protocol to fetch price index and `CurrentPriceIndexListener` protocol to listen to current index updates. Also the framework provides some additional code like model structs, completion handlers aliases and helper extensions.

The framework project was included into the main project for easy development and testing.

It was decided not to share UI layer, as it has the differences in implementation, but some parts could be shared (e.g. views for error/loading states, error handling).

*Ideas for improvements: it makes sense to put the whole feature (UI layer, view model, services, model) into one framework (or even into custom cocoa pod) to let it be shared between the projects and make it easy to be covered by UI tests*

### Networking layer

The project has custom lightweight networking layer that is enough for the current requirements. 

*Ideas for improvements: for production requrements it could be replaced by thrid party libraries like `Moya`/`Alomofire`/`Result`.*

### Use remote API

It was decided to use `Timer` to fetch current price index updates frequently. The interval to send a new request is started to count after the response to the previous request was received. As [Coindesk API](https://www.coindesk.com/api) updates the index every minute, it does not make sense to send requests more frequently (as it was mentioned in the specification for Today Widget).            

*Ideas for improvements: as the Coindesk API has some restrictions (like historical data can be returned in one currency per request, the minimal frequency of the current index updates is one minute), it makes sense to find more convenient remote API provider for production projects.*

### Architectural solutions

It was decided to follow MVVM architecture pattern to keep `UIViewController` classes lightweight, make business logic testable in `ViewModel` classes and decouple the `Model` and `Services` from the top layers. Coordinator pattern is applied for navigation between screens. Alongside with `Factory` class, it helps to minimize dependenices between implementations of each screen.

## Suggestions to improve

- Use `Float` type instead of `String` type to store price value in models (to increase size of memory usage);
- Use `Localizable.strings` to display string values in UI (to manage and localize strings easily);
- Update current price index between the list screen and the detail screen in sync (to improve data consistency between the screens);
- Avoid `today` initial parameter in `ItemListViewModel` class (to simplify the implementation and code readability);
- Cache current price index value in shared `UserDefaults` (to display cached value while Today widget is waiting for the new value);
- Add some animation to notify user about current price index updates in the list screen and the detail screen (to improve user experience).

## Questions

If you find a bug, have a suggesion to improve or any questions related to the project, feel free to open an issue or send a PR.
