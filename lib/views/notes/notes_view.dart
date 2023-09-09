import 'package:flutter/material.dart';
import 'package:myfirst/services/auth/auth_service.dart';
import 'package:myfirst/services/cloud/cloud_note.dart';
import 'package:myfirst/services/cloud/firebase_cloud_storage.dart';
import 'package:myfirst/views/notes/notes_list_view.dart';
import '../../constants/routes.dart';
import '../../enums/menu_action.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).pushNamed(createOrUpdateNoteRoute); 
          }, icon: const Icon(Icons.add)),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async{
            switch(value){
              case MenuAction.logout:
              final shouldLogout = await showLogOutDialog(context);
              if (shouldLogout){
                await AuthService.firebase().logOut();
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
      body: StreamBuilder(
              stream: _notesService.allNotes(ownerUserId: userId),
              builder: (context, snapshot){
                switch(snapshot.connectionState){
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    if (snapshot.hasData){
                      final allNotes = snapshot.data as Iterable<CloudNote>;
                      return NotesListView(
                        notes: allNotes,
                         onDeleteNote: (note) async{
                          await _notesService.deleteNote(documentId: note.documentId);
                         },
                         onTap: (note) {
                          Navigator.of(context).pushNamed(
                            createOrUpdateNoteRoute,
                            arguments: note,
                            );
                         },
                         );
                    } else{
                      return const CircularProgressIndicator();
                    }
                  default:
                  return const CircularProgressIndicator();
                }
              }
              ),
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
            Navigator.of(context).pop(true);
           }, child: const Text('Log Out' )),
         ],
      );
    },
    ).then((value) => value ?? false);
}

