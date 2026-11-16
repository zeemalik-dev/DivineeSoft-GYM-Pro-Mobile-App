
import 'package:divineesoft_gym_pro_app/core/constants/networks/connectivity_service.dart';
import 'package:divineesoft_gym_pro_app/features/webview/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../features/webview/presentation/cubit/webview_cubit.dart';

import 'app_theme.dart';

class GymProApp extends StatelessWidget {
  const GymProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ConnectivityService>(
          create: (_) => ConnectivityService(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return BlocProvider<WebViewCubit>(
            create: (_) => WebViewCubit(
              connectivityService:
                  context.read<ConnectivityService>(),
            )..startMonitoring(),
            child: MaterialApp(
              title: 'DivineeSoft GYM Pro',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.dark,
              home: const SplashScreen(),
            ),
          );
        },
      ),
    );
  }
}
