import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/api_service.dart';
import 'screens/auth_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/inbox_screen.dart';
import 'screens/crm_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final apiService = ApiService();
  await apiService.init();

  runApp(
    MultiProvider(
      providers: [
        Provider<ApiService>.value(value: apiService),
      ],
      child: const FlowSuiteApp(),
    ),
  );
}

class FlowSuiteApp extends StatelessWidget {
  const FlowSuiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context);

    return MaterialApp(
      title: 'FlowSuite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: const Color(0xFF030712),
        fontFamily: 'sans-serif',
      ),
      initialRoute: apiService.isAuthenticated ? '/dashboard' : '/auth',
      routes: {
        '/auth': (context) => const AuthScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/inbox': (context) => const InboxScreen(),
        '/crm': (context) => const CrmScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
