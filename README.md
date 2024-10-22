# ArtistsTechnicalTest

## Overview

This project implements an artist search application using Clean Architecture and the MVVM design pattern. The application is designed to provide users with an efficient way to search for artists and manage selections.

## Development Process Insights

### Design Choices

- **Architecture**: 
  - I chose Clean Architecture to separate concerns between different layers (Domain, Data, Presentation). This separation improves maintainability and scalability.
  
- **Design Patterns**:
  - The MVVM (Model-View-ViewModel) pattern was implemented to enhance the separation between the UI and the business logic. This pattern allows for a reactive UI, where changes in the ViewModel automatically update the UI.

- **Protocols and Dependency Injection**:
  - Protocols were used extensively to define interfaces for components (e.g., repositories, services, and mappers). This approach facilitates testing and allows for easy substitution of implementations.
  - Dependency injection was used to pass dependencies to classes, promoting loose coupling and easier testing.

### Improvements and Refactors

If I had more time, I would implement the following improvements:

- **UI Tests**:
  - Although I have implemented unit tests for critical components, I did not have the opportunity to add UI tests. Adding UI tests would help ensure that user interactions and visual elements function correctly across different scenarios and screen sizes.

- **Error Handling**:
  - I would implement more robust error handling throughout the application, including user-friendly messages and recovery options for common issues.

- **Performance Optimizations**:
  - Investigate potential performance optimizations, such as implementing caching mechanisms for search results or optimizing the data flow between layers.
    
- **Enhance `TargetType` Protocol**:
  - Introduce additional parameters to make it easier to handle different types of network requests. 
    - **Added `queryParameters`**: This optional property allows conforming types to specify query parameters, making the protocol more versatile for various network requests.
    - **Added `httpMethod`**: This property enables the specification of the HTTP method used in the request, which is important for RESTful APIs.

- **Accessibility**:
  - Improve the application's accessibility features to ensure it is usable for all users, including those with disabilities.

- **Core Data Integration**:
  - Implement Core Data for persistent storage, allowing for offline access to selected artists and better management of data.

- **Pagination**:
  - Implement pagination for search results to improve performance and user experience, especially when dealing with a large dataset.

- **Cancellation of Requests**:
  - Enhance the search functionality to allow for cancellation of ongoing requests directly rather than just during typing, improving responsiveness and resource management.

### Challenges and Technical Decisions

During the development process, I encountered several challenges:

- **State Management**:
  - Managing the state of the application (e.g., switching between search results and selected artists) required careful design to ensure the UI remained responsive and intuitive.

- **Handling Network Requests**:
  - Implementing a debounce mechanism to prevent spamming network requests when typing in the search bar was a key consideration. I utilized a timer to delay the search until the user has paused typing.

- **UI Responsiveness**:
  - Ensuring the UI remained responsive during data fetching and processing required careful threading and use of asynchronous programming constructs (e.g., `async/await`).

## Conclusion

This project showcases my ability to design a robust application architecture while applying best practices in software development. The decisions made during development were guided by principles aimed at creating a maintainable and scalable codebase.
