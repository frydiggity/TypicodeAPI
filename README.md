# JsonPlaceholder Posts API App

## Overview

This project demonstrates a basic iOS app that fetches data from the https://jsonplaceholder.typicode.com API, including
- Fetching related data from two separate REST API endpoints using `async let` syntax for demonstrating concurrent asynchronous operations
- SwiftUI View layer with:
  - Posts list screen listing the data from the `/posts` endpoint
    - View can be one of three states:
      - Loading (during API fetches)
      - Loaded (displays fetched `Post` data)
      - Error (displays generic error message if API fetching was unsuccessful)
  - Post detail screen showing `Post` data as well as detail of the `User` making the `Post`

## Architecture

- The app uses a modularized app architecture with separate SPM sub-packages for `Models`, `NetworkClient`, and `Features` (screens)
- The app itself contains no logic other than displaying the entry point view, which is imported from the `Features` module

App -> Features -> NetworkClient - Models


## Dependencies Used

- [swift-dependencies](https://github.com/pointfreeco/swift-dependencies)
  - Dependency Injection is a critical technique in nearly any non-trivial app, enabling greater flexibility for Unit Testing business logic in components as well as for SwiftUI Previews
  - The custom `NetworkClient` dependency is defined in a separate SPM package, and is utilized by the `Features` module to fetch data from the `/users` and `/posts` API endpoints
  - This app utilizes customization of the `\.urlSession` Dependency built into the `swift-dependencies` library to Unit Test the `NetworkClient` component with various overridden network beahviors
  - While not utilized fully in this demo, an additional `\.typicodeJSONDecoder` dependency is implemented demonstrating how a single `JSONDecoder` instance can be created and configured with customizations specific to a particular API's encoding rules
  - The `PostsView` screen's SwiftUI previews also creates a Preview that demonstrates the effect of a slow-loading API
- [swift-perception](https://github.com/pointfreeco/swift-perception)
  - The minimum iOS version of the app is intentionally set to 15.5, but the app uses the modern SwiftUI data observation-style techniques introduced alongside iOS 17 at WWWDC 2023 by leveraging the `swift-perception` library's backport of `@Observable`
  - What would be `@Observable` macro decorated types are replaced with the `@Perception` macro to enable the `PostsView` screen's observation of the `.state` property on the `PostsViewModel` type
- [swift-tagged](https://github.com/pointfreeco/swift-tagged)
  - Also, while not specifically exercised in this use case, the types in the `Models` package employ a best practice of defining their `.id` properties using the Phantom Type construct in `swift-tagged`, which enables stronger compile-time checking that adds more contextual data for general types like `String`, `Int`, or `UUID`
