# 🎬 Movieisme

![Movieisme Banner](<img width="697" alt="movies app" src="https://github.com/user-attachments/assets/4f32ac30-9d51-410b-92d8-db4dd5129fca" />)


## 📌 Overview
**Movieisme** is a feature-rich iOS application developed using **SwiftUI**, designed for movie enthusiasts to explore, search, and manage their favorite movies. The application integrates with a backend API to support **CRUD (Create, Read, Update, Delete) operations**, enabling seamless data management for movies, actors, and user interactions. Additionally, users can personalize their experience by maintaining a watchlist and customizing their profiles.

## 🚀 Key Features
- 🔍 **Advanced Search Functionality**: Search for movies, actors, and directors with real-time results.
- 🎞 **Comprehensive Movie Details**: View IMDb ratings, genres, runtime, storyline, and cast information.
- 🧑‍🎭 **Actor & Director Profiles**: Access detailed biographies and filmographies of movie professionals.
- 📚 **Categorized Movie Discovery**: Browse movies by genres such as Drama, Comedy, Action, Thriller, and more.
- 🎬 **Watchlist Management**: Save movies to a personalized watchlist for easy reference.
- ✍️ **Movie Reviews**: Users can write, edit, and delete reviews on specific movies.
- 📷 **Profile Customization**: Upload and manage profile images.

## 📱 Screenshots
| Home Screen | Movie Info | Search | Profile |
|-------------|------------|--------|--------|
| ![Home](https://your-image-url.com) | ![Movie Info](https://your-image-url.com) | ![Search](https://your-image-url.com) | ![Profile](https://your-image-url.com) |

## 🛠 Technology Stack
- **SwiftUI** – Declarative UI framework for building iOS applications.
- **Combine** – Reactive programming framework for managing asynchronous data streams.
- **PhotosUI** – Image picker for handling user profile images.
- **Airtable API** – Cloud database service for managing and retrieving movie-related data.
- **Postman** – API testing and documentation for efficient backend communication.

## 📥 Installation Guide
### Prerequisites
- **macOS** with **Xcode** installed.
- **iOS Simulator** or a **physical iPhone** for testing.

### Setup Instructions
1. **Clone the repository**:
   ```sh
   git clone https://github.com/your-username/Movieisme.git
   cd Movieisme
   ```
2. **Open the project in Xcode**:
   ```sh
   open Movieisme.xcodeproj
   ```
3. **Run the application on the simulator**:
   - Select an iOS device.
   - Press `Cmd + R` to build and run the app.

## 🔑 API Configuration
This project utilizes **Airtable API** for backend operations. To configure the API:
1. Open `APIService.swift`.
2. Replace the placeholder with your Airtable API key:
   ```swift
   private let apiKey = "Bearer YOUR_AIRTABLE_API_KEY"
   ```
3. Ensure all API endpoints are correctly configured.

## 💡 Application Usage
1. **Search** for movies, actors, or directors.
2. **View detailed movie information**, including cast and ratings.
3. **Save movies** to your personal watchlist for easy access.
4. **Write and manage reviews** for movies.
5. **Customize your profile** by uploading a profile image.

## 🔄 CRUD Operations & API Integration
The Movieisme app fully implements **CRUD operations** through Airtable API:
- **Create**: Add new reviews and save movies.
- **Read**: Fetch and display movies, actors, directors, and reviews.
- **Update**: Modify user profiles and edit movie reviews.
- **Delete**: Remove movies from the watchlist and delete reviews.

## 📌 Challenge Context
This project was developed as part of an **11-day iOS development challenge (Jan 16 - Jan 30, 2025)**, with the goal of building a fully functional SwiftUI application that integrates **CRUD operations** via a RESTful API. The challenge was conducted in an **individual capacity**, with support groups available for collaboration and technical guidance.

### Challenge Deliverables:
1. **A Fully Functional iOS App**
   - Implementing CRUD operations via the provided API.
   - Handling user authentication and profile customization.
2. **Source Code Repository**
   - Hosted on GitHub with a clean and structured commit history.
3. **Comprehensive Documentation**
   - Including a README outlining API integration and CRUD functionality.

## 🛠 Known Issues & Future Enhancements
- ⏳ Implement **pagination** for search results to optimize performance.
- 📅 Add **filtering options** based on movie release dates.
- 🎭 Expand **actor and director movie listings**.
- 🔐 Enhance **user authentication and security measures**.

## 🤝 Contributing
We welcome contributions! To contribute:
1. **Fork the repository**.
2. **Create a feature branch** (`feature-branch-name`).
3. **Commit your changes** with clear messages.
4. **Submit a Pull Request**.

## 📜 License
This project is licensed under the **MIT License**.

---
🤍 Managed & Designed with passion by [Wjdan Mohammed](https://github.com/WjdanMohammed)
💙 Developed with passion by [Noora Alshahrani](https://www.linkedin.com/in/noora-a-alshahrani/)



