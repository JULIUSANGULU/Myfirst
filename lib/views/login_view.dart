import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:myfirst/constants/routes.dart';

import '../utilities/show_error_dialog.dart';



class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _Password;

  @override
  void initState() {
    _email = TextEditingController();
    _Password = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    _email.dispose();
    _Password.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    
    return  Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Column(
                  children: [
                    TextField(
                      controller: _email,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType:TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Enter your email here',
                      ),
                    ),
                    TextField(
                      controller: _Password,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        hintText: 'Enter your password here',
                      ),
                    ),
    
                    TextButton(
                      onPressed: () async{
    
    
                        final email = _email.text;
                        final password =_Password.text;
                        try{
                           await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                          final user = FirebaseAuth.instance.currentUser;
                          if (user?.emailVerified ?? false){
                            //user's email is verified
                           Navigator.of(context).pushNamedAndRemoveUntil(
                            notesRoute, 
                            (route) => false);
                          } else{
                            //User's email is not verified
                           Navigator.of(context).pushNamedAndRemoveUntil(
                             verifyEmailRoute, 
                            (route) => false);
                          }
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            notesRoute, 
                            (route) => false);
                        } on FirebaseAuthException catch (e){
                          if(e.code =='user-not-found'){
                            await showErrorDialog(
                              context,
                               'User not found',
                               );
                          } else if(e.code == 'wrong-password'){
                            await showErrorDialog(
                              context,
                               'Wrong Credentials',
                               );
                          }else if(e.code == 'invalid-email'){
                            devtools.log('Invalid Email Entered');
                          } else{
                            await showErrorDialog(
                              context,
                               'Error: (e.code)',
                               ); 
                          } 
                        }
                        catch (e) {
                            await showErrorDialog(
                              context,
                              e.toString(),
                              );
                          }
    
                      },
                      child: const Text('Login'),),
                      TextButton(onPressed: () async{
            Navigator.of(context).pushNamedAndRemoveUntil(
              registerRoute, (route) => false
             );
    
          },
           child: const Text('Not registered yet? Register here!'),
           )
                      
                  ],
                ),
    );
  }
}
