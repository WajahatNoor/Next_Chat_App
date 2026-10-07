import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_chat/app/modules/auth/bloc/auth_bloc.dart';
import 'package:next_chat/app/routes/app_pages.dart';
import 'package:next_chat/app/utils/all_bloc_providers.dart';
import 'package:next_chat/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AllBlocProviders.providers,
      child: Builder(
        builder: (context) {
          final authBloc = context.read<AuthBloc>();
          return MaterialApp.router(
            routerConfig: AppPages.router(authBloc),
            debugShowCheckedModeBanner: false,
            title: 'Real Time Chat App With Firebase',
            theme: ThemeData(
              colorScheme: .fromSeed(seedColor: Colors.deepPurple),
            ),
          );
        },
      ),
    );
  }
}
