import 'package:flutter/material.dart';
import 'package:frontend/models/note.dart';
import 'package:frontend/services/api_service.dart';

class CreateNoteScreen extends StatefulWidget {
  final String token;
  
  CreateNoteScreen({required this.token});

  @override
  _CreateNoteScreenState createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  Future<void> _saveNote() async {
    final newNote = Note(
      id: 0, // ID will be set by the backend
      userId: 0, // Update with actual userId if neede
      title: _titleController.text,
      content: _contentController.text,
      createdAt: DateTime.now(),
    );
    await ApiService.createNote(widget.token, newNote);
    Navigator.of(context).pop(); // Go back to the previous screen
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Note'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: null,
            ),
          ],
        ),
      ),
    );
  }
}
