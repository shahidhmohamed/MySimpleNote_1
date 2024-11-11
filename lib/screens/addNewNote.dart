import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:MySimpleNotes/service/noteService.dart';

import '../model/Note.dart';

class AddNewNote extends StatefulWidget {
  const AddNewNote({super.key});
  @override
  State<AddNewNote> createState() => _AddNewNoteState();
}
class _AddNewNoteState extends State<AddNewNote> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _createdAt = TextEditingController();
  final _noteService = NoteServices();
  late bool _validateNote = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 50 , left: 16 , right: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.notes),
                  onPressed: () {
                    Navigator.pop(context, null);
                  },
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(CupertinoIcons.share, color: Colors.amberAccent),
                      onPressed: () {
                        Navigator.pop(context, null);
                      },
                    ),
                    TextButton(
                      onPressed: () async {
                        setState(() {
                          _titleController.text.isEmpty
                              ? _validateNote = true
                              : _validateNote = false;
                        });
                        if (!_validateNote) {
                          var note = Note();
                          note.title = _titleController.text;
                          note.content = _contentController.text;
                          note.created_at = DateTime.now();
                          var result = await _noteService.saveNote(note);
                          Navigator.pop(context, result);
                        }
                      },
                      child: const Text(
                        'Done',
                        style: TextStyle(
                            fontSize: 25, fontFamily:'Abyssinica SIL'
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),

            const SizedBox(height: 10),
            TextField(
              controller: _titleController,
              maxLines: null,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Title',
                errorText: _validateNote ? 'Value can\'t be empty' : null,
              ),
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                height: 1,
                fontFamily: 'SF Pro',
              ),
            ),
            const SizedBox(height: 0,),
            TextField(
              controller: _contentController,
              maxLines: null,
              textAlignVertical: TextAlignVertical.top,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Content',
              ),
              style: const TextStyle(
                fontSize: 16,
                height: 1,
                fontFamily: 'SF Pro',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
