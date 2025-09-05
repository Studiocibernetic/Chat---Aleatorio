import 'package:flutter/material.dart';
import '../presentation/main_chat_interface/main_chat_interface.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/random_user_discovery/random_user_discovery.dart';
import '../presentation/user_blocking_and_reporting/user_blocking_and_reporting.dart';
import '../presentation/recent_chats_list/recent_chats_list.dart';
import '../presentation/nickname_creation_screen/nickname_creation_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String mainChatInterface = '/main-chat-interface';
  static const String splash = '/splash-screen';
  static const String randomUserDiscovery = '/random-user-discovery';
  static const String userBlockingAndReporting = '/user-blocking-and-reporting';
  static const String recentChatsList = '/recent-chats-list';
  static const String nicknameCreation = '/nickname-creation-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    mainChatInterface: (context) => const MainChatInterface(),
    splash: (context) => const SplashScreen(),
    randomUserDiscovery: (context) => const RandomUserDiscovery(),
    userBlockingAndReporting: (context) => const UserBlockingAndReporting(),
    recentChatsList: (context) => const RecentChatsList(),
    nicknameCreation: (context) => const NicknameCreationScreen(),
    // TODO: Add your other routes here
  };
}
