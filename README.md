
# Note It! - A Flutter-Based Note-Taking Application 📝

**NoteIt** is a sleek, minimalist note-taking app built using Flutter. It offers seamless note management with cloud syncing, customizable themes, and a smooth user experience, ensuring all notes are stored and updated automatically without extra steps.





## 🌟 Features

- **Multiple Authentication Options**  
  - Secure login with three Firebase providers: Email & Password, Google OAuth, and Facebook.
- **Data Syncing**  
  - Automatically saves notes locally and in Firebase Firestore, ensuring user data is available across devices.
- **Adaptive Theming**  
  - Supports both Light and Dark modes, adapting to the system theme.
- **Seamless Note Management**  
  - No save or update buttons—notes are automatically saved when exiting the editor and updated when closed after edits.
- **Customizable Layout**  
  - Toggle between Grid View and List View for viewing notes.
- **Trash Bin for Deleted Notes**  
  - Deleted notes are moved to a trash bin, allowing for easy recovery, with automatic deletion after 7 days.
- **Bulk Deletion**  
  - Long-press to select and delete multiple notes at once.
- **Additional Pages**  
  - Includes settings and help/feedback pages for a complete user experience.
- **Privacy Focused**  
  - User data remains private and is not used for app improvements, ensuring secure data handling.

---

## 📸 Screenshots

| Home Page | Login page | Sing Up Page |
|-----------------|-----------|-----------|
| ![Home Page](https://github.com/kamesh7773/note_application/blob/main/readme/screenshots/Notes%20Page%20Grid%20View.png?raw=true) | ![Login page](https://github.com/kamesh7773/note_application/blob/main/readme/screenshots/Login%20Page.png?raw=true) | ![Sing Up Page](https://github.com/kamesh7773/note_application/blob/main/readme/screenshots/Sign%20up%20page.png?raw=true) |

| Login & Sign up | Selectable Notes | Modes (Light & Dark) |
|-----------------|-----------|-----------|
| ![Login & Sign up](https://github.com/kamesh7773/note_application/blob/main/readme/gifs/Login%20and%20Sign%20Up%20transition.gif?raw=true) | ![Multiple Selectable Notes](https://github.com/kamesh7773/note_application/blob/main/readme/gifs/Selected%20Multiple%20Notes%20and%20move%20to%20trash%20and%20trash%20to%20Notes.gif?raw=true) | ![Trash Page](https://github.com/kamesh7773/note_application/blob/main/readme/gifs/Light%20and%20Dark%20Theme%20DEMO.gif?raw=true) |

---

## 🚀 Installation

1. **Clone the Repository**
   ```bash
   git clone https://github.com/yourusername/noteit.git
   cd noteit
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the App**
   ```bash
   flutter run
   ```

*Note*: Ensure that [Flutter SDK](https://flutter.dev/docs/get-started/install) is installed and configured in your environment.

---

## 🔧 Configuration

- **Firebase Setup**
  - Go to the [Firebase Console](https://console.firebase.google.com/) and create a new project.
  - Register both Android and iOS apps to this project.
  - Download and add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) to the appropriate directories.
  - Enable **Firestore** and **Authentication** in Firebase and set up Email, Google, and Facebook providers.

---

## 📘 Usage

1. **Authenticate**  
   - Sign up or log in using email, Google, or Facebook.

2. **Create and Edit Notes**  
   - Create a new note by navigating to the editor; changes are automatically saved when exiting the page.

3. **View Layout Options**  
   - Choose between Grid View and List View for note organization.

4. **Recover Deleted Notes**  
   - Access deleted notes in the Trash Bin. Restore or permanently delete items; trash clears automatically after 7 days.

5. **Select Multiple Notes**  
   - Long-press to select and delete multiple notes.

---

## 📂 Project Structure

```plaintext
note_it/
│
├── lib/
│ ├── pages/
│ │ ├── auth_pages/
│ │ ├── drawer_menu/
│ │ ├── notes_pages/
│ │ ├── home_page.dart
│ │ └── ...
│ ├── services/
│ │ ├── auth/
│ │ └── database/
│ ├── theme/
│ ├── widgets/
│ └── main.dart
│
├── assets/
│ ├── images/
│ ├── icon/
│ └── animation/
│
├── pubspec.yaml
└── README.md
```

---

## 🛠 Technologies Used

- **Flutter** - UI development across platforms.
- **Firebase** - Firestore for cloud storage and Firebase Authentication.
- **Provider** - State management.
- **Flutter Local Notifications** - For scheduled reminders and notifications.
- **Dart Extensions** - For custom color and theme extensions.

---

## 🤝 Contributing

Contributions are always welcome! Please follow our [contribution guidelines](CONTRIBUTING.md) to help improve NoteIt. Here’s how you can contribute:

- Report bugs and submit feature requests.
- Fork the repository and submit a pull request.

---

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

### 🙏 Acknowledgements

Special thanks to the Flutter and Firebase communities for their resources and inspiration in building this application!
