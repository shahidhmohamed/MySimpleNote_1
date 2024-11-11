import 'package:flutter/material.dart';
import 'package:MySimpleNotes/screens/attachFile.dart';

class Notetypes extends StatefulWidget {
  const Notetypes({super.key});
  @override
  State<Notetypes> createState() => _NotetypesState();
}

class _NotetypesState extends State<Notetypes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            const Text(
              'What Notes\nDo you Want??',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.attach_file, color: Colors.blue),
                    title: const Text(
                      'Attach File',
                      style: TextStyle(color: Colors.black),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blue),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const AttachmentPage()));
                    },
                  ),
                  const Divider(color: Colors.black),
                  ListTile(
                    leading: const Icon(Icons.mic, color: Colors.blue),
                    title: const Text(
                      'Audio File',
                      style: TextStyle(color: Colors.black),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blue),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.note, color: Colors.black),
                label: const Text('Notes'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 12.0),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.close, color: Colors.white),
      ),
    );
  }
}
