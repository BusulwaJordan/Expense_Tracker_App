# 💰 Expense Tracker - Flutter Mobile Application

A beautiful, full-featured expense tracking application built with Flutter that works seamlessly online and offline. Track your expenses, visualize spending patterns, and manage your finances with stunning animations and a modern interface.

![Flutter](https://img.shields.io/badge/Flutter-3.19.5-blue?style=for-the-badge&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.3.0-blue?style=for-the-badge&logo=dart)
![Supabase](https://img.shields.io/badge/Supabase-PostgreSQL-green?style=for-the-badge&logo=supabase)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

## ✨ Features

### 📱 Core Functionality
- **Expense Management**: Add, edit, delete expenses with categories, dates, and notes
- **Smart Categorization**: Predefined categories (Food, Transport, Entertainment, Groceries, Utilities, Others)
- **Date Filtering**: Filter expenses by week, month, year, or custom date ranges
- **Real-time Search**: Quickly find specific expenses

### 📊 Data Visualization
- **Interactive Pie Charts**: Category-wise spending breakdown using fl_chart
- **Trend Line Charts**: Monthly/weekly spending trends with touch interactions
- **Smart Analytics**: Total expenses, category averages, spending patterns

### 🌐 Cloud Sync & Offline Support
- **Offline-First**: Hive database for instant local storage
- **Automatic Sync**: Supabase backend synchronization when online
- **Conflict Resolution**: Prioritizes local changes with smart merge
- **Connection Awareness**: Real-time online/offline status detection

### 🎨 Stunning UI/UX
- **Material Design 3**: Modern design with deep blue (#1976D2) and teal (#26A69A) theme
- **Smooth Animations**: Hero transitions, AnimatedList, flutter_animate effects
- **Responsive Design**: Works perfectly on phones, tablets, and landscape mode
- **Dark/Light Mode**: System-based theme switching with accessibility support
- **Onboarding Experience**: Beautiful animated introduction for new users

### 🔒 Security & Performance
- **Row Level Security**: Supabase RLS policies for data protection
- **Optimized Performance**: Lazy loading, pagination, and efficient state management
- **Error Handling**: Comprehensive error handling with user-friendly messages

## 🛠️ Tech Stack

- **Frontend**: Flutter 3.19.5, Dart 3.3.0
- **State Management**: Provider
- **Local Database**: Hive (cross-platform, works on web)
- **Cloud Backend**: Supabase (PostgreSQL, REST APIs)
- **Charts**: fl_chart for interactive data visualization
- **Animations**: flutter_animate for stunning effects
- **Icons**: Custom app icon with adaptive support

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  supabase_flutter: ^2.1.0
  fl_chart: ^0.66.0
  flutter_animate: ^4.2.0
  connectivity_plus: ^5.0.1
  shimmer: ^3.0.0
  smooth_page_indicator: ^1.1.0
  shared_preferences: ^2.2.2
  intl: ^0.18.1

dev_dependencies:
  flutter_launcher_icons: ^0.13.1
  build_runner: ^2.4.8
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.19.5 or higher
- Dart 3.3.0 or higher
- Android Studio/VSCode with Flutter extension
- Supabase account (free)

### Installation

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd expense_tracker
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up Supabase**
   - Create account at [supabase.com](https://supabase.com)
   - Create new project and get API keys
   - Run the SQL script in Supabase SQL editor:

   ```sql
   CREATE TABLE expenses (
     id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
     amount REAL NOT NULL CHECK (amount > 0),
     category TEXT NOT NULL,
     date TIMESTAMP WITH TIME ZONE NOT NULL,
     notes TEXT,
     synced BOOLEAN DEFAULT false,
     created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
     updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
   );

   ALTER TABLE expenses ENABLE ROW LEVEL SECURITY;
   CREATE POLICY "Allow all operations" ON expenses FOR ALL USING (true);
   ```

4. **Configure environment**
   - Update `lib/utils/constants.dart` with your Supabase credentials:
   ```dart
   const String supabaseUrl = 'YOUR_SUPABASE_URL';
   const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
   ```

5. **Generate app icons**
   ```bash
   flutter pub run flutter_launcher_icons:main
   ```

6. **Run the application**
   ```bash
   flutter run
   ```

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   ├── expense.dart         # Expense data model
│   └── onboarding_model.dart # Onboarding model
├── providers/
│   └── expense_provider.dart # State management
├── services/
│   ├── database_helper.dart # Hive local database
│   └── supabase_service.dart # Cloud services
├── screens/
│   ├── home_screen.dart     # Main dashboard
│   ├── add_edit_expense_screen.dart # Expense form
│   ├── charts_screen.dart   # Data visualization
│   └── onboarding_screen.dart # First launch experience
├── widgets/
│   ├── expense_tile.dart    # Expense list item
│   ├── custom_card.dart     # Reusable card component
│   ├── pie_chart.dart       # Category chart
│   ├── line_chart.dart      # Trends chart
│   └── loading_shimmer.dart # Loading effects
└── utils/
    ├── constants.dart       # App constants
    ├── helpers.dart         # Utility functions
    ├── sync_manager.dart    # Sync logic
    └── onboarding_data.dart # Onboarding content
```

## 📸 Screenshots

*(Application includes these screens:)*
- **Splash Screen**: Animated app logo with smooth transitions
- **Onboarding**: 3-step animated introduction with illustrations
- **Home Screen**: Expense list with summary cards and FAB
- **Add Expense**: Beautiful form with category dropdown and date picker
- **Charts Screen**: Interactive pie and line charts
- **Responsive Design**: Adaptive layout for all screen sizes

## 🎯 Key Features Implementation

### Offline-First Architecture
```dart
// Hive local database for instant operations
await _dbHelper.init();
_expenses = _dbHelper.getExpenses(); // Synchronous reads

// Automatic background sync
if (_isOnline) {
  await _syncManager.trySync();
}
```

### Smooth Animations
```dart
// Using flutter_animate for stunning effects
ExpenseTile(expense: expense)
  .animate()
  .fadeIn(delay: (index * 100).ms)
  .slideX(begin: 0.5, curve: Curves.easeOut);
```

### Responsive Design
```dart
// Adaptive layout for different screen sizes
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 600) {
      return _buildTabletLayout();
    } else {
      return _buildPhoneLayout();
    }
  },
)
```

## 📱 Building for Production

### Android APK
```bash
flutter build apk --release
```

### iOS IPA (requires Mac)
```bash
flutter build ios --release
```

### Web PWA
```bash
flutter build web --release --web-renderer canvaskit
```

## 🔧 Configuration

### Environment Variables
Create `lib/utils/constants.dart`:
```dart
const String supabaseUrl = 'https://your-project.supabase.co';
const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
```

### App Icons
Place your icons in:
- `assets/icons/app_icon.png` (512x512)
- `assets/icons/adaptive_icon.png` (108x108)
- `assets/onboarding/1.png`, `2.png`, `3.png` (onboarding images)

## 🐛 Troubleshooting

### Common Issues

1. **Supabase Connection Failed**
   - Verify API keys in constants.dart
   - Check internet connection
   - Ensure RLS policies are configured

2. **Hive Initialization Error**
   ```bash
   flutter clean
   flutter pub get
   ```

3. **Build Errors**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Web Renderer Issues**
   ```bash
   flutter run -d chrome --web-renderer canvaskit
   ```

### Solutions

- **Database not initializing**: Ensure Hive is properly configured
- **Sync failures**: Check Supabase credentials and internet connection
- **Animation issues**: Verify flutter_animate version compatibility

## 📈 Performance Tips

1. **Use const constructors** for better widget rebuilding
2. **Implement lazy loading** for large expense lists
3. **Optimize images** for onboarding screens
4. **Use efficient state management** with Provider

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🚀 Future Enhancements

- [ ] User authentication and multi-user support
- [ ] Receipt image capture and storage
- [ ] Budget setting and alert notifications
- [ ] Export to CSV/PDF functionality
- [ ] Recurring expenses management
- [ ] Currency conversion support
- [ ] Advanced reporting and analytics
- [ ] Data backup and restore
- [ ] Voice command support
- [ ] Wear OS/Apple Watch integration

## 🙏 Acknowledgments

- [Flutter](https://flutter.dev) for the amazing cross-platform framework
- [Supabase](https://supabase.com) for the excellent backend service
- [Hive](https://hivedb.dev) for fast local database
- [fl_chart](https://github.com/imaNNeo/fl_chart) for beautiful charts
- [flutter_animate](https://pub.dev/packages/flutter_animate) for smooth animations

## 📞 Support

If you have any questions or issues, please:

1. Check the [Troubleshooting](#-troubleshooting) section
2. Search existing [GitHub Issues](https://github.com/your-username/expense_tracker/issues)
3. Create a new issue with detailed description

## 🌟 Star History

If you find this project useful, please give it a star on GitHub! ⭐

---

**Built with ❤️ using Flutter and Supabase**

*Happy expense tracking! 💰📊*
