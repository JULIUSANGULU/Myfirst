import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

// class Homepage extends StatelessWidget {
//   const Homepage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: AuthService.firebase().initialize(),
//         builder: (context, snapshot) {
//           switch (snapshot.connectionState) {
//             case ConnectionState.done:
//               final user = AuthService.firebase().currentUser;
//               if(user !=null) {
//                 if(user.isEmailVerified){
//                   devtools.log('Email is verified');
//                 } else{
//                   return const LoginView();
//                 }
//               } else{
//                 return const NotesView();
//               }
//               return const LoginView();
//             default:
//               return const Text('Loading...');
//           }

//         },
//       );

//   }
// }
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late final TextEditingController _controller;

  @override
  void initState(){
    _controller = TextEditingController();
    super.initState();
  }
  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Testing bloc'),
        ),
        body: BlocConsumer<CounterBloc, CounterState>(
          listener: (context, state){
            _controller.clear();
          },
          builder: (context, state){
            final invalidValue = 
             (state is CounterStateInvalidNumber) ? state.invalidValue : '';

            return Column(
              children: [
                Text('Current value => ${state.value}'),
                Visibility(
                  visible: state is CounterStateInvalidNumber,
                  child: Text('Invalid input: $invalidValue'),
                  ),
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter a number here',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: (){
                          context
                          .read<CounterBloc>()
                          .add(DecrementEvent(_controller.text));
                        },
                        child: const Text('-')
                        ),
                        TextButton(
                        onPressed: (){
                           context
                          .read<CounterBloc>()
                          .add(IncrementEvent(_controller.text));
                        },
                        child: const Text('+')
                        ),
                    ],
                  )
              ]
            );
          }
        ),
      ),
    );
  }
}

@immutable
abstract class CounterState{
  final int value;
  const CounterState(this.value);
}

class CounterStateValid extends CounterState{
  const CounterStateValid(int value) : super(value);
}

class CounterStateInvalidNumber extends CounterState{
  final String invalidValue;
  const CounterStateInvalidNumber({
    required this.invalidValue,
    required int previousValue,
  }) : super(previousValue);
}

abstract class CounterEvent{
  final String value;
  const CounterEvent(this.value);
}

class IncrementEvent extends CounterEvent {
  const IncrementEvent(String value) : super(value);
}

class DecrementEvent extends CounterEvent{
  const DecrementEvent(String value) : super(value);
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterStateValid(0)){
    on<IncrementEvent>((event, emit){
      final integer = int.tryParse(event.value);
      if (integer == null){
        emit(CounterStateInvalidNumber(
         invalidValue: event.value,
         previousValue: state.value),
         );
      } else{
       emit(CounterStateValid(state.value + integer));
      }
    });
     on<DecrementEvent>((event, emit){
      final integer = int.tryParse(event.value);
      if (integer == null){
        emit(CounterStateInvalidNumber(
         invalidValue: event.value,
         previousValue: state.value),
         );
      } else{
       emit(CounterStateValid(state.value - integer));
      }
    });
  }
}
