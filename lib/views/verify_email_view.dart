import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfirst/constants/routes.dart';

class verifyEmailView extends StatefulWidget {
  const verifyEmailView({super.key});

  @override
  State<verifyEmailView> createState() => _verifyEmailViewState();
}

class _verifyEmailViewState extends State<verifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email'),),
      body: Column(
        children: [
          const Text(
            "We've Sent You an Email verification, please open it to verify your account."),
           const Text("If you havent recieved an email, Press the button below"),
          TextButton(onPressed: () async{
            final user = FirebaseAuth.instance.currentUser;
            await user ?.sendEmailVerification();
          },
           child: const Text('send email verification'),
           ),
           TextButton(onPressed: () async{
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushNamedAndRemoveUntil(
              registerRoute, 
              (route) => false
              );
           }, 
           child: const Text('Restart'),
            )
        ],),
    )
      ;
  }
}
