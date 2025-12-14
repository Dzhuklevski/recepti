import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/category_screen.dart';
import 'screens/meal_detail_screen.dart';

// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('Background message received: ${message.notification?.title} - ${message.notification?.body}');
  
  // Fetch a random recipe from TheMealDB API
  await fetchRandomRecipe();
}

// Fetch a random recipe from TheMealDB API
Future<void> fetchRandomRecipe() async {
  try {
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final recipe = data['meals'][0]['strMeal'];
      print('Random recipe: $recipe');
    } else {
      print('Failed to fetch recipe: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching recipe: $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Set background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Request notification permissions (Android & iOS)
  NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else {
    print('User declined or has not accepted permission');
  }

  // Print device token for testing
  String? token = await FirebaseMessaging.instance.getToken();
  print('FCM Token: $token');

  // Foreground message handler
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print('Foreground notification received: ${message.notification?.title} - ${message.notification?.body}');
    await fetchRandomRecipe();
  });

  runApp(const MealDbApp());
}

class MealDbApp extends StatelessWidget {
  const MealDbApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MealDB Recipes',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: false,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        CategoryScreen.routeName: (context) => const CategoryScreen(),
        MealDetailScreen.routeName: (context) => const MealDetailScreen(),
      },
    );
  }
}
