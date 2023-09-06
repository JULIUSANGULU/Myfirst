import 'package:flutter/material.dart';
import 'package:myfirst/constants/routes.dart';
import 'package:myfirst/services/auth/auth_service.dart';
import 'package:myfirst/views/Register_view.dart';
import 'package:myfirst/views/login_view.dart';
import 'package:myfirst/views/notes/create_update_note_view.dart';
import 'package:myfirst/views/notes/notes_view.dart';
import 'dart:developer' as devtools show log;
import 'package:myfirst/views/verify_email_view.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Homepage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute:(context) => const NotesView(),
        verifyEmailRoute: (context) => const verifyEmailView(),
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    );
  }
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;
              if(user !=null) {
                if(user.isEmailVerified){
                  devtools.log('Email is verified');
                } else{
                  return const LoginView();
                }
              } else{
                return const NotesView();
              }
              return const LoginView();
            default:
              return const Text('Loading...');
          }

        },
      );

  }
}


