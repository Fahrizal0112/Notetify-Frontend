import 'dart:convert';
import 'package:frontend/models/note.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.1.8:8080'; // Ensure this is correct

  static Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final token = responseData['token'];
        print('Token : $token');
        return responseData;
      } else {
        print('Failed to login: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error during login: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> register(String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        print('Failed to register: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error during registration: $e');
      return null;
    }
  }

  static Future<List<Note>> getNotes(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/notes'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        print('Retrieved notes: $body');  // Print the retrieved notes
        List<Note> notes = body.map((dynamic item) {
          return Note.fromJson(item);
        }).toList();
        return notes;
      } else {
        print('Failed to load notes: ${response.body}');
        throw Exception('Failed to load notes');
      }
    } catch (e) {
      print('Error during fetching notes: $e');
      throw Exception('Failed to load notes');
    }
  }

  static Future<Note> getNoteById(String token, int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/note/$id'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(response.body);
        print('Retrieved note: $body'); 
        return Note.fromJson(body);
      } else {
        print('Failed to load note: ${response.body}');
        throw Exception('Failed to load note');
      }
    } catch (e) {
      print('Error during fetching note: $e');
      throw Exception('Failed to load note');
    }
  }
  static Future<void> deleteNoteById(String token, int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/note/$id'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        print('Failed to delete note: ${response.body}');
        throw Exception('Failed to delete note');
      }
    } catch (e) {
      print('Error during deleting note: $e');
      throw Exception('Failed to delete note');
    }
  }

  static Future<void> updateNoteById(String token, int id, Note note) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/note/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(note.toJson()),
      );

      if (response.statusCode != 200) {
        print('Failed to update note: ${response.body}');
        throw Exception('Failed to update note');
      }
    } catch (e) {
      print('Error during updating note: $e');
      throw Exception('Failed to update note');
    }
  }
    static Future<void> createNote(String token, Note note) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/note'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(note.toJson()),
      );

      if (response.statusCode != 201) {
        print('Failed to create note: ${response.body}');
        throw Exception('Failed to create note');
      }
    } catch (e) {
      print('Error during creating note: $e');
      throw Exception('Failed to create note');
    }
  }
}
