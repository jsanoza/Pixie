import 'dart:async';
import 'dart:developer';
import 'package:coastrial/models/stablediffusion_request_model.dart';
import 'package:cross_file/cross_file.dart';
import 'package:get/get.dart';
import 'package:universal_io/io.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import '../models/chatcompletion_model.dart';

class OpenAICustomAPI {
  static final String _transcriptionUrl = 'https://api.openai.com/v1/audio/transcriptions';
  static final String _chatUrl = 'https://api.openai.com/v1/chat/completions';
  static final String _editImageUrl = "https://api.openai.com/v1/images/edits";
  static final String _generateUrl = 'https://api.openai.com/v1/images/generations';
  static final String _generateVariationUrl = 'https://api.openai.com/v1/images/variations';
  static late String _token;
  static late String _audioToken;
  static late String _audioID;
  static late String _stableDiffusionToken;

  static void setToken(String token) {
    _token = token;
  }

  static void setSDToken(String token) {
    _stableDiffusionToken = token;
  }

  static void setAudioToken(String token) {
    _audioToken = token;
  }

  static void setAudioID(String token) {
    _audioID = token;
  }

  static Future<String> transcribeAudio(String filePath, String model) async {
    //save the path from blob to a file
    final fileBytes = XFile(filePath);
    var finalBytes = await fileBytes.readAsBytes();
    List<int> list = finalBytes;

    final request = http.MultipartRequest('POST', Uri.parse(_transcriptionUrl))
      ..headers['Authorization'] = 'Bearer $_token'
      ..files.add(http.MultipartFile.fromBytes('file', list, filename: "voice.wav"))
      ..fields['response_format'] = "text"
      ..fields['model'] = 'whisper-1';

    final response = await request.send();

    if (response.statusCode == HttpStatus.ok) {
      final responseBody = await response.stream.bytesToString();
      return responseBody.toString();
    } else {
      throw Exception('Failed to transcribe audio: ${response.statusCode} ${response.reasonPhrase} ');
    }
  }

  static Future<String> completeChat(String model, List<Map<String, String>> messages) async {
    final body = {
      'model': model,
      'messages': messages,
    };

    final response = await http.post(
      Uri.parse(_chatUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: json.encode(body),
    );

    if (response.statusCode == HttpStatus.ok) {
      var responseBody = ChatCompletion.fromJson(jsonDecode(response.body));
      return responseBody.choices.first.message.content.toString().trim();
    } else {
      var responseBody = jsonDecode(response.body);
      log(responseBody['error']['message'].toString());
      throw Exception('Failed to complete chat: ${response.statusCode} ${responseBody['error']['message'].toString()}');
    }
  }

  static Future<String> convertAudio(List<String> content) async {
    final url = Uri.parse('https://play.ht/api/v1/convert');

    final headers = {
      'authorization': _audioToken,
      'x-user-id': _audioID,
      'Content-Type': 'application/json',
    };

    final body = {
      'voice': "Karen",
      'content': content,
      'title': "Audio",
      'speed': "0.5",
      'preset': "real-time",
    };

    final response = await http.post(
      url,
      headers: headers,
      body: json.encode(body),
    );

    if (response.statusCode == HttpStatus.created) {
      var responseBody = jsonDecode(response.body);
      return responseBody['transcriptionId'];
    } else {
      print('Failed to convert audio. Error code: ${response.statusCode}');
      return "${response.statusCode}";
    }
  }

  static Future<String> checkArticleStatus(String transcriptionId) async {
    final url = Uri.parse('https://play.ht/api/v1/articleStatus?transcriptionId=$transcriptionId');

    log("Parsed url: $url");
    final headers = {
      'authorization': _audioToken,
      'x-user-id': _audioID,
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return responseBody['audioUrl'];
    } else {
      return "${response.statusCode}";
    }
  }

  static Future<List<String>> generateImage(
    String prompt,
    int n,
    String size,
  ) async {
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $_token',
    };
    final body = jsonEncode({
      'prompt': prompt,
      'n': 4,
      'size': size,
      'response_format': 'b64_json',
    });
    final response = await http.post(Uri.parse(_generateUrl), headers: headers, body: body);

    if (response.statusCode == HttpStatus.ok) {
      final data = jsonDecode(response.body);
      List<String> urls = [];
      for (var data in data['data']) {
        urls.add(data['b64_json']);
      }

      return urls;
    } else {
      var responseBody = jsonDecode(response.body);
      log(responseBody['error']['message'].toString());
      throw Exception('Failed to complete chat: ${response.statusCode} ${responseBody['error']['message'].toString()}');
    }
  }

  static Future<List<String>> generateImageVariation(
    String imageFile,
    int n,
    String size,
  ) async {
    final fileBytes = XFile(imageFile);
    var finalBytes = await fileBytes.readAsBytes();
    List<int> list = finalBytes;

    log("hey im here23!");
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(_generateVariationUrl),
    )
      ..headers['Authorization'] = 'Bearer $_token'
      ..fields['n'] = "4"
      ..fields['size'] = size
      ..fields['response_format'] = "b64_json"
      ..files.add(http.MultipartFile.fromBytes('image', list, filename: "file.png"));
    final response = await http.Response.fromStream(await request.send());
    if (response.statusCode == HttpStatus.ok) {
      final data = jsonDecode(response.body);
      log("hey im here2!");
      List<String> urls = [];
      int i = 0;
      for (var data in data['data']) {
        urls.add(data['b64_json']);
        log((i++).toString());
      }

      return urls;
    } else {
      var responseBody = jsonDecode(response.body);
      log(responseBody['error']['message'].toString());
      throw Exception('Failed to complete chat: ${response.statusCode} ${responseBody['error']['message'].toString()}');
    }
  }

  static Future<List<String>> editImage({
    required String imagePath,
    required String maskPath,
    required String prompt,
    required int n,
    required String size,
  }) async {
    final fileBytes = XFile(imagePath);
    var finalBytes = await fileBytes.readAsBytes();
    List<int> list = finalBytes;

    final fileBytes2 = XFile(maskPath);
    var finalBytes2 = await fileBytes2.readAsBytes();
    List<int> list2 = finalBytes2;

    final request = http.MultipartRequest('POST', Uri.parse(_editImageUrl))
      ..headers['Authorization'] = 'Bearer $_token'
      ..files.add(
        http.MultipartFile.fromBytes('image', list, filename: "file.png"),
      )
      ..files.add(
        http.MultipartFile.fromBytes('mask', list2, filename: "mask.png"),
      )
      ..fields['prompt'] = prompt
      ..fields['n'] = n.toString()
      ..fields['size'] = size
      ..fields['response_format'] = "b64_json";

    final response = await http.Response.fromStream(await request.send());
    if (response.statusCode == HttpStatus.ok) {
      final data = jsonDecode(response.body);
      List<String> urls = [];
      int i = 0;
      for (var data in data['data']) {
        urls.add(data['b64_json']);
        log((i++).toString());
      }

      return urls;
    } else {
      var responseBody = jsonDecode(response.body);
      log(responseBody['error']['message'].toString());
      throw Exception('Failed to complete chat: ${response.statusCode} ${responseBody['error']['message'].toString()}');
    }

    // return decodedResponse;
  }

  static Future<List<String>> sendSDRequest(String prompt, String link) async {
    final url = Uri.parse('https://stablediffusionapi.com/api/v3/img2img');
    final headers = {
      'Content-Type': 'application/json',
      "Access-Control-Allow-Origin": "*", // Required for CORS support to work
      "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
      "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "POST, OPTIONS"
    };

    // final sdRequest = StableDiffusion(
    //   key: _stableDiffusionToken,
    //   prompt: prompt,
    //   initImage: link,
    //   width: '512',
    //   height: '512',
    //   samples: '3',
    //   numInferenceSteps: '30',
    //   guidanceScale: 7.5,
    //   safetyChecker: 'yes',
    //   strength: 0.7,
    // );

    final body = json.encode({
      "key": "L9Mo4yUGVuRaSPtXp3lSmUVXVrAr9J0mJpO9APDsOG7CbO7x6H2EHls104EE",
      "prompt": "a cat sitting on a bench",
      "negative_prompt": null,
      "init_image": "https://raw.githubusercontent.com/CompVis/stable-diffusion/main/data/inpainting_examples/overture-creations-5sI6fQgYIuo.png",
      "width": "512",
      "height": "512",
      "samples": "1",
      "num_inference_steps": "30",
      "guidance_scale": 7.5,
      "safety_checker": "yes",
      "strength": 0.7,
      "seed": null,
      "webhook": null,
      "track_id": null,
    });

    final response = await http.post(url, headers: headers, body: body);

    // final request = await html.HttpRequest.requestCrossOrigin(
    //   "https://stablediffusionapi.com/api/v3/img2img",
    //   method: 'POST',
    //   sendData: jsonEncode(body),
    // );

    // final response = request;
    // // final parsedResponse = jsonDecode(response);
    // // final output = parsedResponse['output'] as List<String>;
    // // log(output.toString());

    // log(response.toString());

    log(response.statusCode.toString());
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      // final List<String> output = List<String>.from(responseData['output']);

      List<String> urls = [];
      int i = 0;
      log(responseData.toString());
      log(responseData['output'].toString());
      // for (var data in responseData['output']) {
      //   // urls.add(data.toString());
      //   final responseTobytes = await http.get(data);

      //   if (responseTobytes.statusCode == 200) {
      //     final bytes = responseTobytes.bodyBytes;
      //     // do something with the image bytes
      //     urls.add(bytes.toString());
      //   } else {
      //     // handle errors
      //     print('Error: ${responseTobytes.reasonPhrase}');
      //     throw Exception('Failed to generate image variation');
      //   }

      //   // urls.add(data['b64_json']);
      //   log((i++).toString());
      // }

      // do something with the output list
      return urls;
    } else {
      // handle errors
      print('Error: ${response.reasonPhrase}');
      throw Exception('Failed to generate image variation');
    }
  }
}
