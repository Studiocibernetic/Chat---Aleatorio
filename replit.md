# Random Chat - Flutter Web App

## Project Overview
A modern Flutter-based mobile application designed for anonymous chat functionality. The app has been successfully configured to run in the Replit environment as a web application.

## Current State
- ✅ Flutter development environment set up
- ✅ All dependencies installed and configured
- ✅ Web support enabled and working
- ✅ Development server running on port 5000
- ✅ Theme compatibility issues resolved
- ✅ Deployment configuration complete

## Architecture
- **Frontend**: Flutter Web App
- **UI Framework**: Material Design with custom Contemporary Conversational Minimalism theme
- **Typography**: Google Fonts (Inter)
- **Responsive Design**: Sizer package for screen adaptability

## Key Features
- Anonymous chat interface
- User discovery and matching
- Chat history management  
- User blocking and reporting functionality
- Nickname creation system
- Dark/Light theme support

## Development Setup
- **Framework**: Flutter 3.32.0
- **Language**: Dart 3.8.0  
- **Development Server**: Running on port 5000 with hot reload
- **Browser**: Chromium for web development

## Deployment
- **Target**: Autoscale deployment (stateless web app)
- **Build**: `flutter build web --release`
- **Serve**: Python HTTP server serving static files
- **Port**: 5000 (configured for Replit environment)

## Project Structure
```
lib/
├── core/           # Core utilities and exports
├── presentation/   # UI screens and widgets
│   ├── main_chat_interface/
│   ├── nickname_creation_screen/
│   ├── random_user_discovery/
│   ├── recent_chats_list/
│   ├── splash_screen/
│   └── user_blocking_and_reporting/
├── routes/         # Application routing
├── theme/          # Theme configuration (fixed compatibility)
├── widgets/        # Reusable UI components
└── main.dart       # Application entry point
```

## Recent Changes
- Fixed theme compatibility issues (CardTheme → CardThemeData, TabBarTheme → TabBarThemeData)
- Added web support with proper Flutter web configuration
- Configured development workflow for Replit environment
- Set up deployment configuration for production

## Configuration Notes
- Chrome executable set to Chromium for web development
- Host configured as 0.0.0.0 to work with Replit's proxy system
- Development server allows all hosts for iframe compatibility
- No sound null safety flags removed (no longer needed in Flutter 3.32+)