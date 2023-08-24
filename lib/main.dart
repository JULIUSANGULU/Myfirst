import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myfirst/constants/routes.dart';
import 'package:myfirst/firebase_options.dart';
import 'package:myfirst/views/Register_view.dart';
import 'package:myfirst/views/login_view.dart';
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
      },
    );
  }
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:  Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              if(user !=null) {
                if(user.emailVerified){
                  devtools.log('Email is verified');
                } else{
                  return const LoginView();
                }
              }else{
                return const LoginView();
              }
              return const NotesView();
            default:
              return const Text('Loading...');
          }

        },
      );

  }
}

enum MenuAction{logout}
class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        actions: [
          PopupMenuButton<MenuAction>(onSelected: (value) async{
            switch(value){
              case MenuAction.logout:
              final shouldLogout = await showLogOutDialog(context);
              if (shouldLogout){
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute, 
                  (_) => false,
                );
              }
              
            }
          },
         itemBuilder: (context) {
           return const[
           PopupMenuItem<MenuAction>(value:MenuAction.logout,
             child: Text('Log out'),
             ),
           ];
         },
         )
        ],
      ),
      body: const Text('Hello World'),
    ); 
  }
}
Future <bool> showLogOutDialog(BuildContext context){
  return showDialog<bool>(
    context: context,
    builder:(context){
      return AlertDialog(
         title: const Text('Log Out'),
         content: const Text('Are you sure you want to Log out?'),
         actions: [
          TextButton(onPressed: (){
            Navigator.of(context).pop(false);
          }, child: const Text('Cancel')),
           TextButton(onPressed: (){
            Navigator.of(context).pop(false);
           }, child: const Text('Log Out')),
         ],
      );
    },
    ).then((value) => value ?? false);
}

