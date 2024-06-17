import 'package:flutter/material.dart';
import 'package:frontend/models/note.dart';
import 'package:frontend/services/api_service.dart';
import 'package:intl/intl.dart';

class NoteDetailScreen extends StatefulWidget {
  final String token;
  final int noteId;

  NoteDetailScreen({required this.token, required this.noteId});

  @override
  _NoteDetailScreenState createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late Future<Note> _note;
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _note = ApiService.getNoteById(widget.token, widget.noteId);
    _note.then((note) {
      _titleController = TextEditingController(text: note.title);
      _contentController = TextEditingController(text: note.content);
    });
  }

  String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(dateTime);
  }

  Future<void> _saveNote() async {
    final updatedNote = Note(
      id: widget.noteId,
      userId: 0, // Update with actual userId if needed
      title: _titleController.text,
      content: _contentController.text,
      createdAt: DateTime.now(), // Update with actual createdAt if needed
    );
    await ApiService.updateNoteById(widget.token, widget.noteId, updatedNote);
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
        title: Text('Note Detail'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            await _saveNote();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FutureBuilder<Note>(
        future: _note,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No note found'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _contentController,
                    decoration: InputDecoration(labelText: 'Content'),
                    style: TextStyle(fontSize: 18),
                    maxLines: null,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Created at: ${formatDateTime(snapshot.data!.createdAt)}',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
