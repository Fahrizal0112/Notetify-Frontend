import 'package:flutter/material.dart';
import 'package:frontend/models/note.dart';
import 'package:frontend/services/api_service.dart';
import 'package:intl/intl.dart';
import 'package:frontend/screens/note_detail_screen.dart';
import 'package:frontend/screens/create_note_screen.dart';

class NotesScreen extends StatefulWidget {
  final String token;
  
  NotesScreen({required this.token});

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late Future<List<Note>> _notes;

  @override
  void initState() {
    super.initState();
    print('Token: ${widget.token}');  // Print the token
    _fetchNotes();
  }

  Future<void> _fetchNotes() async {
    setState(() {
      _notes = ApiService.getNotes(widget.token);
    });
  }

  String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(dateTime);
  }

  Future<void> _deleteNoteById(int id) async {
    try {
      await ApiService.deleteNoteById(widget.token, id);
      _fetchNotes(); // Refresh the list after deletion
    } catch (e) {
      print('Failed to delete note: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchNotes, // Panggil fungsi untuk mengambil ulang data
          ),
        ],
      ),
      body: FutureBuilder<List<Note>>(
        future: _notes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No notes found'));
          } else {
            final notes = snapshot.data!;
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Dismissible(
                  key: Key(note.id.toString()),
                  background: Container(
                    color: Colors.blue,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.edit, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      // Edit action
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoteDetailScreen(
                            token: widget.token,
                            noteId: note.id,
                          ),
                        ),
                      );
                      return false; // Don't dismiss the item
                    } else if (direction == DismissDirection.endToStart) {
                      // Delete action
                      final bool? res = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Confirm"),
                            content: Text("Are you sure you want to delete this note?"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: Text("DELETE"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: Text("CANCEL"),
                              ),
                            ],
                          );
                        },
                      );
                      if (res == true) {
                        await _deleteNoteById(note.id);
                      }
                      return res;
                    }
                    return false;
                  },
                  child: ListTile(
                    title: Text(note.title),
                    trailing: Text(formatDateTime(note.createdAt)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoteDetailScreen(
                            token: widget.token,
                            noteId: note.id,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateNoteScreen(token: widget.token)),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
