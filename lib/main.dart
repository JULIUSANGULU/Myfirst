import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myfirst/constants/routes.dart';
import 'package:myfirst/services/auth/bloc/auth_bloc.dart';
import 'package:myfirst/services/auth/bloc/auth_event.dart';
import 'package:myfirst/services/auth/bloc/auth_state.dart';
import 'package:myfirst/services/auth/firebase_auth_provider.dart';
import 'package:myfirst/views/Register_view.dart';
import 'package:myfirst/views/login_view.dart';
import 'package:myfirst/views/notes/create_update_note_view.dart';
import 'package:myfirst/views/notes/notes_view.dart';
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
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: Homepage(),
      ),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
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
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state){
      if (state is AuthStateLoggedIn){
        return const NotesView();
      } else if(state is AuthStateNeedsVerification){
        return const verifyEmailView();
      } else if (state is AuthStateLoggedOut){
        return const LoginView();
      } else{
        return const Scaffold(
         body: CircularProgressIndicator(),
        );
      }
    },
    );
  }
}
