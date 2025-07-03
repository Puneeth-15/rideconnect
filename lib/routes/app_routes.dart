import 'package:flutter/material.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/marketplace/marketplace.dart';
import '../presentation/home_feed/home_feed.dart';
import '../presentation/post_creation/post_creation.dart';
import '../presentation/user_profile/user_profile.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String loginScreen = '/login-screen';
  static const String marketplace = '/marketplace';
  static const String homeFeed = '/home-feed';
  static const String postCreation = '/post-creation';
  static const String userProfile = '/user-profile';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const LoginScreen(),
    loginScreen: (context) => const LoginScreen(),
    marketplace: (context) => const Marketplace(),
    homeFeed: (context) => const HomeFeed(),
    postCreation: (context) => const PostCreation(),
    userProfile: (context) => const UserProfile(),
    // TODO: Add your other routes here
  };
}
