import 'package:MySimpleNotes/repository/repository.dart';
import '../model/Note.dart';

class NoteServices{
  late Repository _repository;
  NoteServices(){
    _repository = Repository();
  }

  saveNote(Note note) async{
    return await _repository.insertData('notes', note.noteMap());
  }

  readAllNotes() async{
    return await _repository.readData('notes');
  }

  updateNote(Note note) async{
    return await _repository.updateData('notes', note.noteMap());
  }

  deleteNote(noteId) async{
    return await _repository.deleteDataById('notes',noteId);
  }

  Future<void> updateBookmarkStatus(Note note) async {
    await _repository.updateData('notes', note.noteMap());
  }

  Future<List<Map<String, dynamic>>?> readDataByTitle(String table, String title) async {
    return await _repository.readDataByTitle(table, title);
  }

}