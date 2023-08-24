import 'package:flutter/material.dart';
import 'package:myfirst/constants/routes.dart';
import 'package:myfirst/services/auth/auth_exceptions.dart';
import 'package:myfirst/services/auth/auth_service.dart';
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
                         await  AuthService.firebase().createUser(
                          email: email, 
                          password: password
                          );
                         AuthService.firebase().sendEmailVerification();
                          Navigator.of(context).pushNamed(verifyEmailRoute);
                        
                        } on WeakPasswordAuthException {
                          await showErrorDialog(context,'Weak Password', );
                        } on EmailAlreadyInUseAuthException{
                           await showErrorDialog(context,'Email Already In Use',);
                        } on InvalidEmailAuthException{
                           await showErrorDialog(context,'Invalid Email Entered', );
                        } on GenericAuthException{
                            await showErrorDialog(
                            context,
                            'Failed To Register',
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