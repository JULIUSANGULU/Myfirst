import 'package:flutter/material.dart';
import 'package:myfirst/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context){
  return showGenericDialog(
    context: context, 
    title: 'Password Reset', 
    content: 
      'We have now sent you a password reset link. ', 
    optionsBuilder: () => {
      'OK': null,
      },
    );
}