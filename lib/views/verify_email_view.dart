import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myfirst/services/auth/bloc/auth_bloc.dart';
import 'package:myfirst/services/auth/bloc/auth_event.dart';

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
          TextButton(
            onPressed: (){
          context.read<AuthBloc>().add(
            const AuthEventSendEmailVerification(),
          );
       },
           child: const Text('send email verification'),
           ),
           TextButton(onPressed: () async{
            context.read<AuthBloc>().add(
              const AuthEventLogOut(),
            );
           }, 
           child: const Text('Restart'),
            )
        ],),
    )
      ;
  }
}
