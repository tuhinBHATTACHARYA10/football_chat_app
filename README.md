# ⚽ Football Chat Hub

A real-time "Digital Stadium" experience for football fans. This hybrid mobile application combines live match data from external APIs with instant, real-time messaging powered by Firebase.

Built with **Flutter** and **Firebase**.

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/firebase-%23039BE5.svg?style=for-the-badge&logo=firebase)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)

## 🚀 Project Overview

The goal of this project was to solve a common problem: fans want to chat while watching the game, but existing apps are either just for scores (OneFootball) or just for chatting (WhatsApp). 

**Football Chat Hub** merges these into one seamless interface:
1.  **Live Data:** Users see scheduled matches and live scores.
2.  **Live Interaction:** Users can enter a "Match Room" and chat instantly with other fans.

## ✨ Key Features

-   **Real-Time Messaging:** Powered by **Cloud Firestore** streams for sub-second latency.
-   **Live Match Data:** Integrated with **football-data.org API** to fetch schedules for Premier League, La Liga, UCL, and more.
-   **Dynamic Theming:** The app UI adapts its color scheme based on the selected league (e.g., Purple for Premier League, Orange for La Liga).
-   **Hybrid State Management:** Uses `FutureBuilder` for API calls and `StreamBuilder` for chat updates.
-   **Offline Resilience:** Optimized asset caching for team logos and league branding.

## 🛠️ Tech Stack

-   **Frontend:** Flutter (Dart)
-   **Backend (Chat):** Firebase Cloud Firestore
-   **Backend (Data):** REST API (football-data.org)
-   **Architecture:** MVC Pattern (Model-View-Controller)

## 📸 Screenshots

| Login Screen | League Select | Live Chat |
|:---:|:---:|:---:|
| ![Login](screenshot_login.png) | ![Menu](screenshot_menu.png) | ![Chat](screenshot_chat.png) |

## 🧩 Architecture Decisions

**Why two backends?**
I chose a hybrid approach to optimize costs and performance:
-   **Firebase** is excellent for real-time features (chat) but expensive for storing massive amounts of static sports data.
-   **REST API** is perfect for fetching structured data (scores/fixtures) that doesn't need to be "real-time" to the millisecond.

**Handling Android versions:**
The project uses a custom `gradle` configuration to bridge modern Flutter plugins (which demand Android 34) with older hardware stability (Android 33), ensuring smooth performance on all devices.

## 🔮 Future Improvements

-   [ ] **Push Notifications:** Notify users when their team scores (via Firebase Cloud Messaging).
-   [ ] **Monetization:** Integrate Google AdMob for banner ads.
-   [ ] **User Profiles:** Allow users to upload avatars and view stats.

## 👨‍💻 Author

**Tuhin Bhattacharya**
-   Flutter Developer | Backend Engineer
-   [LinkedIn](https://www.linkedin.com/in/tuhin-bhattacharya-4002632a3/) | [GitHub](https://github.com/tuhinBHATTACHARYA10)

---
*Star ⭐ this repo if you find it useful!*