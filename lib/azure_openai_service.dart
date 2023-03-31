import 'dart:convert';
import 'package:http/http.dart' as http;

const openaiUrl = String.fromEnvironment("AZ_OPENAI_URL");
const apiKey = String.fromEnvironment("AZ_OPENAI_KEY");

Future<OpenAIResponse> fetchNutriFacts(productsList) async {
  // print('Fetching Nutri Score...');
  
  var products = arrayToString(productsList);
  // var prompt =
  //     "My groceries basket: $products \nHow nutritive is it? \nWhat can I add to make it better?";

  var prompt = "<|im_start|>system\nMy groceries basket: $products \nHow nutritive is it? \nWhat can I add to make it better?\n<|im_end|>\n";

  // print(prompt);

  var data = {
    'prompt': prompt,
    "temperature": 0.7,
    "top_p": 0.95,
    "frequency_penalty": 0,
    "presence_penalty": 0,
    "max_tokens": 800,
    "stop": [
      "<|im_end|>"
    ]
  };

  final response = await http.post(
      Uri.parse(openaiUrl),
      headers: <String, String>{
        'api-key': apiKey,
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data));

  if (response.statusCode == 200) {
    print(response.body);
    return OpenAIResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}

Future<OpenAIResponse> fetchRecipe(productsList) async {
  print('Fetching Recipe...');
  var products = arrayToString(productsList);
  var prompt = "<|im_start|>system\nMy groceries basket: $products \nWhat would be a good recipe with a title and steps?\n<|im_end|>\n";

  // print(prompt);

  var data = {
    'prompt': prompt,
    "temperature": 0.7,
    "top_p": 0.95,
    "frequency_penalty": 0,
    "presence_penalty": 0,
    "max_tokens": 800,
    "stop": [
      "<|im_end|>"
    ]
  };

  final response = await http.post(
      Uri.parse(openaiUrl),
      headers: <String, String>{
        'api-key': apiKey,
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data));

  print(response.statusCode);

  if (response.statusCode == 200) {
    print(response.body);
    return OpenAIResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}

String arrayToString(list) {
  var string = "";
  for (var item in list) {
    string += item + ", ";
  }
  return string;
}

class OpenAIResponse {
  final String id;
  final String choices;

  const OpenAIResponse({required this.id, required this.choices});

  factory OpenAIResponse.fromJson(Map<String, dynamic> json) {
    return OpenAIResponse(
      id: json['id'],
      choices: json['choices'][0]['text'],
    );
  }
}