import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatbotRemoteDataSource {
  Future<String> getBotReply(String query) async {
    final response = await http.post(
      Uri.parse("https://advance-chatbot.onrender.com/chat"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"user_query": query}),
    );

    if (response.statusCode == 200) { 
      final decoded = jsonDecode(response.body);

      return decoded["response"] ?? "Sorry, I couldn't understand that.";
    } else {
      return "Server error (${response.statusCode}).";
    }
  }
}
