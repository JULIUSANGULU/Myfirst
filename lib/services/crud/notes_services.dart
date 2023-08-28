import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;

import 'crud_exceptions.dart';


class NotesService{
  Database? _db;

  Future <DataBaseNote> updateNote({required DataBaseNote note, required String text,}) async{
    final db = _getDatabaseOrThrow();

    await getNote(id: note.id);
    final updatesCount = await db.update(noteTable,{
      textColumn: text,
      isSyncedWithCloudColumn: 0,
    });

    if (updatesCount == 0){
      throw CouldNotUpdateNote();
    } else {
      return await getNote(id: note.id);
    }
  }

  Future <Iterable <DataBaseNote>> getAllNotes() async{
    final db = _getDatabaseOrThrow();
    final notes = await db.query(noteTable);

    return notes.map((noteRow) => DataBaseNote.fromRow(noteRow));

  }

  Future <DataBaseNote> getNote({required int id}) async{
    final db = _getDatabaseOrThrow();
    final notes = await db.query (
      noteTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );

    if(notes.isEmpty){
      throw CouldNotFindNote();
    } else{
      return DataBaseNote.fromRow(notes.first);
    }
  }

  Future <int> deleteAllNotes() async{
    final db = _getDatabaseOrThrow();
    return await db.delete(noteTable);
  }

  Future<void> deleteNote({required int id}) async{
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      noteTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deletedCount == 0){
      throw CouldNotDeleteNote();
    }
  }
  Future <DataBaseNote> createNote({required DataBaseUser owner}) async {
    final db = _getDatabaseOrThrow();

    // make sure owner exists in the the database with the correct id

    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner){
      throw CouldNotFindUser();
    }

    const text = '';
    //create the note
    final noteId= await db.insert(noteTable, {
      userIdColumn: owner.id,
      textColumn: text,
      isSyncedWithCloudColumn: 1
    });

    final note = DataBaseNote(
      id: noteId, 
      userId: owner.id,
      text: text,
      isSyncedWithCloud: true,
      );

      return note;


  }

  Future <DataBaseUser> getUser({required String email}) async{
    final db = _getDatabaseOrThrow();

     final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isEmpty){
      throw CouldNotFindUser();
    } else{
      return DataBaseUser.fromRow(results.first);
    }
  }

  Future <DataBaseUser> createUser({required String email}) async{
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isNotEmpty){
      throw UserAlreadyExists();
    }

    final userId = await db.insert(userTable, {
      emailColumn: email.toLowerCase(),
    });

    return DataBaseUser(id: userId, email: email,);
  }

  Future<void> deleteUser({required String email}) async{
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable, 
      where: 'email = ?', 
      whereArgs: [email.toLowerCase()],
      );
  }

  Database _getDatabaseOrThrow(){
    final db = _db;
    if(db == null){
      throw DataBaseIsNotOpen();
    } else{
      return db;
    }
  }

  Future <void> close() async{
    final db = _db;
    if (db == null){
      throw DataBaseIsNotOpen();
    } else{
      await db.close();
      _db = null;
    }
  }
  Future<void> open() async{
    if (_db != null){
      throw DataBaseAlreadyOpenException();
    }
    try{
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;
    ///createusertable
    
      await db.execute(createUserTable);
      //create note table
    await db.execute(createNoteTable);

    } on MissingPlatformDirectoryException{
      throw UnableToGetDocumentsDirectory();
    }
  }
}

@immutable
class DataBaseUser{
  final int id;
  final String email;
  const DataBaseUser({
    required this.id, 
    required this.email,
    });

    DataBaseUser.fromRow(Map<String, Object?> map) 
    : id = map[idColumn] as int, 
    email = map [emailColumn] as String;

    @override
  String toString() =>'person ID = $id, email = $email';

  @override bool operator == (covariant DataBaseUser other ) => id == other.id;
  
  @override
  int get hashCode => id.hashCode;
}

class DataBaseNote{
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  DataBaseNote({
     required this.id,
     required this.userId, 
     required this.text, 
     required this.isSyncedWithCloud,
     });
  
  DataBaseNote.fromRow(Map<String, Object?> map) 
    : id = map[idColumn] as int, 
    userId = map [userIdColumn] as int,
    text = map[textColumn] as String,
    isSyncedWithCloud =
     (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

     @override
  String toString() => 'Note, ID = $id, userId = $userId, isSyncedWIthCloud = $isSyncedWithCloud';

   @override bool operator == (covariant DataBaseNote other ) => id == other.id;
  
  @override
  int get hashCode => id.hashCode;
}

const dbName = 'notes.db';
const noteTable = 'note';
const userTable = 'user';
const idColumn = 'id';
const emailColumn = 'email';
const userIdColumn = 'user_id';
const textColumn = 'text';
const isSyncedWithCloudColumn = 'is_synced_with_cloud'; 
  const createUserTable = ''' CREATE TABLE IF NOT EXISTS "User" (
	"id"	INTEGER NOT NULL,
	"email"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("id" AUTOINCREMENT)
);  
      ''';
const createNoteTable = ''' CREATE TABLE IF NOT EXISTS "Notes" (
      "id"	INTEGER NOT NULL,
      "user_id"	INTEGER NOT NULL,
      "text"	TEXT,
      "is_synced_with_cloud"	NUMERIC NOT NULL DEFAULT 0,
      FOREIGN KEY("user_id") REFERENCES "User"("id"),
      PRIMARY KEY("id" AUTOINCREMENT)
      );

    ''';