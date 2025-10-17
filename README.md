# 🚨 Smart Alarm Clock

A sophisticated alarm clock application built with Flutter that challenges users with math problems to ensure they're fully awake before dismissing alarms.

## ✨ Features

### 🧮 Math Challenge System
- **Wake-up Challenge**: Solve 3 math problems correctly to stop the alarm
- **Smart Reset**: Wrong answer? Start over with 3 new problems
- **Operators**: Addition (+), Subtraction (-), Multiplication (×), Division (÷)
- **Toggle Option**: Enable/disable math challenges per alarm

### 🎨 Modern UI/UX
- **Material Design 3**: Clean, modern interface
- **Dark/Light Mode**: Toggle between themes with smooth transitions
- **Responsive Design**: Optimized for various screen sizes
- **Smooth Animations**: Fluid transitions and visual feedback

### ⏰ Advanced Alarm Management
- **Multiple Alarms**: Create unlimited alarms
- **Custom Titles**: Personalize each alarm
- **Repeat Patterns**: Daily, weekdays, or custom repeat schedules
- **Enable/Disable**: Quick toggle for individual alarms
- **Edit & Delete**: Full CRUD operations

### 🎵 Audio Features
- **Custom Ringtones**: Choose from device storage
- **Timestamp Control**: Set start time for custom ringtones (0-5 minutes)
- **Volume Control**: Adjustable volume slider
- **Vibration**: Optional vibration support

### 🌙 Theme System
- **Night Mode**: Dark theme for comfortable night use
- **Light Mode**: Bright theme for daytime use
- **Persistent Settings**: Theme preference saved across sessions
- **System Integration**: Follows Material Design guidelines

## 🏗️ Architecture

### Project Structure
```
lib/
├── main.dart                    # App entry point
├── models/
│   ├── alarm.dart              # Alarm data model
│   └── math_challenge.dart     # Math challenge logic
├── services/
│   ├── alarm_service.dart      # Alarm management service
│   └── theme_service.dart      # Theme management service
└── screens/
    ├── home_screen.dart        # Main alarm list screen
    ├── add_edit_alarm_screen.dart # Alarm creation/editing
    └── alarm_ringing_screen.dart  # Alarm dismissal screen
```

### Key Components

#### 📊 Data Models
- **`Alarm`**: Core alarm data structure with time, repeat patterns, and settings
- **`TimeOfDay`**: Custom time representation
- **`MathChallenge`**: Individual math problem generator
- **`MathChallengeSession`**: Manages the 3-problem sequence

#### 🔧 Services
- **`AlarmService`**: Handles alarm CRUD operations, notifications, and scheduling
- **`ThemeService`**: Manages dark/light mode switching and persistence

#### 🖼️ Screens
- **`HomeScreen`**: Displays current time and alarm list
- **`AddEditAlarmScreen`**: Form for creating/editing alarms
- **`AlarmRingingScreen`**: Full-screen alarm dismissal with math challenges

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.35.6 or higher)
- Android Studio or VS Code
- Android device/emulator (API level 21+)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd alarm_clock_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Quick Start Scripts

**Check available devices:**
```bash
# Windows
check_devices.bat

# Or manually
flutter devices
```

**Run the app:**
```bash
# Windows
run_app.bat

# Or manually
flutter clean && flutter pub get && flutter run
```

## 📱 Usage Guide

### Creating an Alarm

1. **Tap the + button** on the home screen
2. **Set alarm details**:
   - Enter alarm title
   - Select time using the time picker
   - Choose repeat days (optional)
   - Toggle math challenge on/off
   - Adjust volume and vibration settings
   - Select custom ringtone (optional)
3. **Save the alarm**

### Managing Alarms

- **Toggle**: Use the switch to enable/disable alarms
- **Edit**: Tap the menu (⋮) → Edit
- **Delete**: Tap the menu (⋮) → Delete
- **Math Challenge**: Toggle the "Math Challenge" option when creating/editing

### Dismissing Alarms

#### Standard Alarm
- Tap "Stop Alarm" button to dismiss immediately

#### Math Challenge Alarm
1. **Solve 3 math problems** correctly
2. **Wrong answer?** The challenge resets and starts over
3. **Complete all 3** to stop the alarm

### Theme Switching
- Tap the **🌙/☀️ icon** in the app bar to toggle between dark and light modes
- Your preference is automatically saved

## 🛠️ Development

### Dependencies

```yaml
dependencies:
  flutter: sdk
  shared_preferences: ^2.2.2      # Local storage
  flutter_local_notifications: ^17.2.2  # Alarm notifications
  audioplayers: ^6.0.0            # Audio playback
  file_picker: ^8.0.0+1           # File selection
  permission_handler: ^11.3.1     # Permissions
  intl: ^0.19.0                   # Date/time formatting
  timezone: ^0.9.2                # Timezone handling
```

### Building for Production

**Debug Build:**
```bash
flutter build apk --debug
```

**Release Build:**
```bash
flutter build apk --release
```

**App Bundle (for Play Store):**
```bash
flutter build appbundle --release
```

### Testing

**Run unit tests:**
```bash
flutter test
```

**Run widget tests:**
```bash
flutter test test/widget_test.dart
```

## 📋 Permissions

The app requires the following Android permissions:

- `WAKE_LOCK` - Keep device awake during alarms
- `VIBRATE` - Vibration support
- `RECEIVE_BOOT_COMPLETED` - Restore alarms after device restart
- `SCHEDULE_EXACT_ALARM` - Schedule precise alarm times
- `USE_EXACT_ALARM` - Use exact alarm functionality
- `POST_NOTIFICATIONS` - Display alarm notifications
- `READ_EXTERNAL_STORAGE` - Access custom ringtones
- `WRITE_EXTERNAL_STORAGE` - Save app data

## 🎯 Customization

### Adding Your App Logo

1. Replace `assets/images/app_logo.png` with your logo
2. Recommended size: 512x512 pixels
3. Format: PNG with transparent background

### Adding Custom Sounds

1. Place audio files in `assets/sounds/`
2. Supported formats: MP3, WAV, AAC
3. Update the ringtone selection logic as needed

### Theming

Modify `lib/services/theme_service.dart` to customize:
- Color schemes
- Typography
- Component styles
- Animation durations

## 🐛 Troubleshooting

### Common Issues

**App won't build:**
```bash
flutter clean
flutter pub get
flutter run
```

**Alarms not working:**
- Check notification permissions
- Verify alarm permissions in device settings
- Ensure battery optimization is disabled for the app

**Audio issues:**
- Check volume settings
- Verify audio file formats
- Test with different ringtones

**Math challenges not appearing:**
- Ensure "Math Challenge" is enabled for the alarm
- Check that the alarm is properly configured

### Debug Mode

Enable debug logging by running:
```bash
flutter run --debug
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📞 Support

For support, email your-email@example.com or create an issue in the repository.

## 🔄 Version History

- **v1.0.0** - Initial release with core alarm functionality
- **v1.1.0** - Added math challenge system
- **v1.2.0** - Implemented dark/light theme switching
- **v1.3.0** - Added custom ringtone support

---

**Made with ❤️ using Flutter**