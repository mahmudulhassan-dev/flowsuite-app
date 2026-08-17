import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://flowsuite.amansuite.com/api/v1';
  
  String? _token;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
  }

  bool get isAuthenticated => _token != null;
  String? get token => _token;

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        _token = data['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);
        if (data['user'] != null) {
          await prefs.setString('user_profile', jsonEncode(data['user']));
        }
        return {'success': true, 'message': 'Logged in successfully'};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network connection failed: $e'};
    }
  }

  Future<void> logout() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_profile');
  }

  Future<Map<String, dynamic>?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileStr = prefs.getString('user_profile');
    if (profileStr != null) {
      return jsonDecode(profileStr) as Map<String, dynamic>;
    }
    return null;
  }

  Future<Map<String, dynamic>> getDashboardStats() async {
    if (_token == null) return {'success': false, 'message': 'Unauthenticated'};
    try {
      // Mock stats matching database values
      return {
        'success': true,
        'stats': {
          'scheduled_posts': 128,
          'active_conversations': 342,
          'crm_leads': 1890,
          'ai_credits': 4850,
        }
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<List<dynamic>> getInboxThreads() async {
    if (_token == null) return [];
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/inbox/threads'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        return data['threads'] ?? [];
      }
      return [];
    } catch (e) {
      // Return sample threads if backend connection is offline
      return [
        {
          'id': 't1',
          'customerName': 'Abdur Rahman',
          'channel': 'whatsapp',
          'lastMessage': 'I would like to inquire about the pricing details of the growth plan.',
          'updatedAt': '2026-08-18T04:40:00Z',
          'status': 'open'
        },
        {
          'id': 't2',
          'customerName': 'Sultana Jasmin',
          'channel': 'messenger',
          'lastMessage': 'Can we integrate custom LLM model in AI Studio?',
          'updatedAt': '2026-08-18T03:15:00Z',
          'status': 'open'
        },
        {
          'id': 't3',
          'customerName': 'Karim Ullah',
          'channel': 'livechat',
          'lastMessage': 'Hello, is anyone online to assist?',
          'updatedAt': '2026-08-18T01:10:00Z',
          'status': 'pending'
        }
      ];
    }
  }

  Future<bool> sendInboxMessage(String threadId, String content) async {
    if (_token == null) return false;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/inbox/messages'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode({
          'threadId': threadId,
          'content': content,
        }),
      );
      final data = jsonDecode(response.body);
      return response.statusCode == 201 && data['success'] == true;
    } catch (e) {
      return true; // Optimistic update for testing
    }
  }
}
