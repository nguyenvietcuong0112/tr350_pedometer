import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_size/responsive_size.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/dashboard_provider.dart';
import 'core/navigation/app_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ResponsiveSize.init(designWidth: 390.0, designHeight: 844.0);
  runApp(const ProviderScope(child: FitLifeApp()));
}

class FitLifeApp extends ConsumerWidget {
  const FitLifeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'FitLife - Run & Calorie Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const AppShell(),
    );
  }
}
