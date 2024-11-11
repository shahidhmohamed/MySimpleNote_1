import 'package:flutter/material.dart';
import 'package:MySimpleNotes/model/Note.dart';
import 'package:MySimpleNotes/screens/addNewNote.dart';
import 'package:MySimpleNotes/screens/noteTypes.dart';
import 'package:MySimpleNotes/screens/viewNote.dart';
import 'package:MySimpleNotes/service/noteService.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Note> _noteList = [];
  late List<Note> _filteredNoteList = [];
  final _noteService = NoteServices();
  final TextEditingController _searchController = TextEditingController();
  late List<bool> _bookmarkedList = [];

  _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _initializeDummyData() async {
    var notes = await _noteService.readAllNotes();

    // Only add dummy data if there are no notes
    if (notes.isEmpty) {
      List<Note> dummyNotes = [
        Note(
          title: "Project Overview",
          content:
              "This is a test note to summarize the main points of an upcoming project.The project involves multiple stages, including research, development, and testing. Each team member will be assigned specific tasks, and regular updates are expected. This note helps ensure that all relevant details are stored clearly for reference.",
          created_at: DateTime.now(),
          book_marked: false,
        ),
        Note(
          title: "Workout Plan",
          content:
              "This is a test note outlining a basic workout plan. The plan includes cardio exercises three times a week, strength training twice a week, and flexibility exercises once a week. Each session is aimed at enhancing overall fitness and health. The app should be able to handle and display this structured content efficiently.",
          created_at: DateTime.now(),
          book_marked: true,
        ),
        Note(
          title: "Book Summary - Atomic Habits",
          content:
              "This is a test note summarizing key points from by James Clear. The book explores how small habits, when built over time, can lead to significant positive changes. The author emphasizes creating systems instead of relying on motivation alone. This note tests how the app handles book summaries and longer texts.",
          created_at: DateTime.now(),
          book_marked: false,
        ),
        Note(
          title: "Workout Routine",
          content: "Monday: Chest, Tuesday: Back, Wednesday: Legs",
          created_at: DateTime.now(),
          book_marked: false,
        ),
      ];

      for (var note in dummyNotes) {
        await _noteService.saveNote(note);
      }
      getAllNotes();
    }
  }

  getAllNotes() async {
    var notes = await _noteService.readAllNotes();
    _noteList = <Note>[];
    _bookmarkedList = List.generate(notes.length, (_) => false);
    notes.forEach((notesData) {
      var notesModel = Note();
      notesModel.note_id = notesData['note_id'];
      notesModel.title = notesData['title'];
      notesModel.content = notesData['content'];
      notesModel.created_at = DateTime.tryParse(notesData['created_at'] ?? '');
      notesModel.book_marked = notesData['book_marked'] == 1;
      _noteList.add(notesModel);
      _noteList.sort((a, b) {
        return (b.book_marked == true ? 1 : 0) -
            (a.book_marked == true ? 1 : 0);
      });
    });

    _filterNotes();
  }

  void _filterNotes() {
    setState(() {
      _filteredNoteList = _noteList.where((note) {
        return note.title!
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
      }).toList();
    });
  }

  _deleteNoteDialog(BuildContext context, noteId) {
    return showDialog(
      context: context,
      builder: (param) {
        return AlertDialog(
          title: const Text(
            'Are You Sure to delete',
            style: TextStyle(color: Colors.teal, fontSize: 20),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.red),
              onPressed: () async {
                var result = await _noteService.deleteNote(noteId);
                Navigator.pop(context);
                if (result != null) {
                  getAllNotes();
                  _showSuccessSnackBar('Note Deleted Successfully');
                }
              },
              child: const Text('Delete'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.teal),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeDummyData();
    getAllNotes();
    _searchController.addListener(_filterNotes);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth -
        40; // Assuming you want to subtract 20 padding on both sides

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  textAlign: TextAlign.left,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'My,\n',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'Alata',
                        ),
                      ),
                      TextSpan(
                        text: 'Simple ',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'Alata',
                        ),
                      ),
                      TextSpan(
                        text: 'Notes',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontFamily: 'Alata',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width:
                      cardWidth, // Set the width of the search bar to match the card width
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search Notes',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _filteredNoteList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 20, bottom: 0, right: 20, top: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ViewNote(note: _filteredNoteList[index]),
                        ),
                      ).then((data) {
                        if (data != null) {
                          getAllNotes();
                          _showSuccessSnackBar('Note Updated Successfully');
                        }
                      });
                    },
                    child: Card(
                      color: Colors.grey[80],
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _filteredNoteList[index].created_at != null
                                      ? DateFormat('d MMM').format(
                                          _filteredNoteList[index].created_at!)
                                      : 'No Date',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[600],
                                      fontFamily: 'Abyssinica SIL'),
                                ),
                                IconButton(
                                  icon: Icon(
                                    _filteredNoteList[index].book_marked == true
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    color:
                                        _filteredNoteList[index].book_marked ==
                                                true
                                            ? Colors.yellow
                                            : Colors.grey,
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      _filteredNoteList[index].toggleBookmark();
                                    });
                                    await _noteService.updateBookmarkStatus(
                                        _filteredNoteList[index]);
                                    await getAllNotes();
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _filteredNoteList[index].title ?? '',
                              style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Abyssinica SIL'),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _filteredNoteList[index].content ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontFamily: 'Abyssinica SIL',
                                height: 1.2,
                              ),
                              textAlign: TextAlign.left,
                              softWrap: true,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _deleteNoteDialog(context,
                                        _filteredNoteList[index].note_id);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNewNote()),
          ).then((data) {
            if (data != null) {
              getAllNotes();
              _showSuccessSnackBar('Note Added Successfully');
            }
          });
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[300],
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Notetypes()));
                },
                icon: const Icon(Icons.menu)),
          ],
        ),
      ),
    );
  }
}
