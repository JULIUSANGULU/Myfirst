import 'package:flutter/material.dart';
import 'package:myfirst/services/crud/notes_services.dart';

import '../../utilities/dialogs/delete_dialog.dart';
import '../../utilities/dialogs/logout_dialog.dart';
typedef DeleteNoteCallback = void Function(DataBaseNote note);

class NotesListView extends StatelessWidget {
  final List <DataBaseNote> notes;
  final DeleteNoteCallback onDeleteNote;

  const NotesListView({
    Key? key,
    required this.notes,
    required this.onDeleteNote,
  }) :super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemCount: notes.length, itemBuilder: (context, index ){
    final note = notes[index];
    return ListTile(
      title: Text(
        note.text,
        maxLines: 1,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          onPressed: () async{
            final shouldDelete = await showDeleteDialog(context);
            if (shouldDelete){
              onDeleteNote(note);
            }
          },
          icon: const Icon(Icons.delete),
        ),
    );
  },
  );
  }
}