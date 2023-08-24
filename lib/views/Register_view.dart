import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:myfirst/constants/routes.dart';
import 'package:myfirst/utilities/show_error_dialog.dart';


class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

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
    appBar: AppBar(title: const Text('Register'),),  
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
                         await FirebaseAuth.instance.createUserWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                          Navigator.of(context).pushNamed(verifyEmailRoute);
                        } on FirebaseAuthException catch (e){
                          if(e.code =='weak-password'){
                           await showErrorDialog(context,'Weak Password', );
                          } else if(e.code == 'email-already-in-use'){
                             await showErrorDialog(context,'Email Already In Use',);
                          }else if(e.code == 'invalid-email'){
                             await showErrorDialog(context,'Invalid Email Entered', );
   
                          } else{
                            'Error: (e.code)';
                          }
                        } catch (e){
                          await showErrorDialog(
                            context,
                             e.toString(),
                             );
                        }
   
                      },
                      child: const Text('Register'),),
                    TextButton(onPressed: (){
                      Navigator.of(context).pushNamedAndRemoveUntil(
                         loginRoute, (route) => false
                        );

                    }, child: const Text(
                      'Already Registered? Login Here!'),
                      )
                  ],
                ),
   );
  }
}