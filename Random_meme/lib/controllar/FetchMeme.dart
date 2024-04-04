import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class FetchMeme {
  final String baseUrl = 'https://api.imgflip.com/';

  Future<String> fetchNewMeme() async {
    final response = await http.get(Uri.parse('${baseUrl}get_memes'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final memes = data['data']['memes'];
      final randomMeme = memes[Random().nextInt(memes.length)];
      return randomMeme['url'];
    } else {
      throw Exception('Failed to load meme');
    }
  }
}
