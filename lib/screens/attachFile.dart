import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:MySimpleNotes/model/Attachment.dart';
import 'package:MySimpleNotes/service/attachmentService.dart';

class AttachmentPage extends StatefulWidget {
  const AttachmentPage({Key? key}) : super(key: key);

  @override
  _AttachmentPageState createState() => _AttachmentPageState();
}

class _AttachmentPageState extends State<AttachmentPage> {
  String? _fileName; // Variable to hold the selected file name
  late List<Attachment> _attachments = [];
  final AttachmentServices _attachmentServices = AttachmentServices();

  @override
  void initState() {
    super.initState();
    getAllAttachments();
  }

  Future<void> getAllAttachments() async {
    var notes = await _attachmentServices.readAllAttachments();
    _attachments = <Attachment>[];
    for (var attachmentData in notes) {
      var attachmentModel = Attachment();
      attachmentModel.name = attachmentData['name']; // Assuming the name is correctly extracted
      attachmentModel.id = attachmentData['id']; // Assuming the ID is available
      _attachments.add(attachmentModel);
    }
    setState(() {}); // Update the state to reflect changes
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _fileName = result.files.single.name; // Get the file name
      });

      // Save the file name to the database
      Attachment attachment = Attachment();
      attachment.name = _fileName; // Assuming Attachment model has a name property
      await _attachmentServices.saveNote(attachment); // Update method name for clarity
      await getAllAttachments(); // Reload the attachments
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attach a File'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: _pickFile, // Attach file when icon is pressed
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _attachments.length,
        itemBuilder: (context, index) {
          final attachment = _attachments[index];
          return ListTile(
            title: Text(attachment.name ?? 'No Name'), // Accessing the name directly
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                // Optionally handle delete attachment
                await _attachmentServices.deleteAttachment(attachment.id); // Access the ID directly
                await getAllAttachments(); // Reload attachments after deletion
              },
            ),
          );
        },
      ),
    );
  }
}
