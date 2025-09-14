# XMoneyNote - Personal Finance Tracker

A simple, secure, and privacy-focused personal finance management app built with Flutter.

## 🚀 Features

- **Privacy First**: All data stored locally on your device
- **Income & Expense Tracking**: Record and categorize your financial transactions
- **Visual Statistics**: Beautiful charts and graphs to analyze your spending
- **Custom Categories**: Create and manage your own income and expense categories
- **Dark/Light Themes**: Switch between themes for comfortable viewing
- **Offline Functionality**: Works without internet connection
- **User Authentication**: Secure login and registration system

## 📱 Screenshots

The app includes three main sections:
- **Home**: Transaction ledger with floating action button
- **Statistics**: Visual charts showing income vs expenses
- **Profile**: User settings, category management, and preferences

## 🛠️ Technical Stack

- **Framework**: Flutter
- **Database**: SQLite (local storage)
- **State Management**: Provider
- **Authentication**: Flutter Secure Storage + Crypto
- **Charts**: FL Chart
- **Theme**: Custom day/night mode switching

## 📦 Installation

### Prerequisites
- Flutter SDK (3.0 or higher)
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/xiebao/jizhang-base.git
   cd jizhang-base
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## 🔧 Configuration

### Package Information
- **Package Name**: `com.jizhang.goodgood`
- **App Name**: `XMoneyNote`
- **Version**: 1.0.0

### Test Account
- **Username**: `zhanxiao`
- **Password**: `123456`
- **Initial Balance**: 1000.0

## 📊 Database Schema

### Users Table
- `id`: Primary key
- `username`: Unique username
- `email`: User email
- `password`: Hashed password
- `initialBalance`: Starting balance
- `createdAt`: Account creation timestamp

### Transactions Table
- `id`: Primary key
- `userId`: Foreign key to users
- `amount`: Transaction amount
- `type`: Income or Expense
- `category`: Transaction category
- `description`: Transaction notes
- `dateTime`: Transaction timestamp

### Categories Table
- `id`: Primary key
- `userId`: Foreign key to users
- `name`: Category name
- `type`: Income or Expense category

## 🌐 Web Deployment

The project includes web pages for App Store submission:
- `index.html` - Main website homepage
- `privacy-policy.html` - Privacy policy
- `terms-of-service.html` - Terms of service

### Deployment Options
1. **GitHub Pages** (Free)
2. **Netlify** (Free)
3. **Vercel** (Free)
4. Traditional web hosting

See `WEB_DEPLOYMENT_GUIDE.md` for detailed instructions.

## 📱 App Store Submission

### Required Documents
- `APP_STORE_METADATA.md` - App description and metadata
- `PRIVACY_POLICY_XMONEYNOTE.md` - Privacy policy
- `TERMS_OF_SERVICE_XMONEYNOTE.md` - Terms of service
- `APP_STORE_CHECKLIST.md` - Submission checklist
- `APP_STORE_GUIDE.md` - Step-by-step guide

### Test Account for Review
- **Username**: `zhanxiao`
- **Password**: `123456`
- **Features**: Pre-populated with sample transactions

## 🔒 Privacy & Security

- All financial data stored locally on device
- No data transmission to external servers
- Passwords encrypted using SHA-256
- No third-party data sharing
- GDPR and CCPA compliant

## 📄 License

This project is proprietary software. All rights reserved.

## 🤝 Support

For support and questions:
- **Email**: support@xmoney-note.com
- **Privacy**: privacy@xmoney-note.com

## 📝 Changelog

### Version 1.0.0
- Initial release
- Core transaction tracking functionality
- User authentication system
- Statistics and charts
- Dark/light theme support
- Category management
- Local database storage

## 🏗️ Project Structure

```
lib/
├── database/
│   └── database_helper.dart
├── models/
│   ├── user.dart
│   ├── transaction.dart
│   └── category.dart
├── screens/
│   ├── auth/
│   ├── home/
│   ├── statistics/
│   ├── profile/
│   ├── transaction/
│   └── main/
├── services/
│   ├── auth_service.dart
│   └── theme_service.dart
├── utils/
│   └── init_test_data.dart
├── widgets/
│   └── initial_balance_dialog.dart
└── fish_main.dart
```

---

**XMoneyNote** - Take control of your finances with privacy and simplicity.