import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:acne_detector/pages/root_app.dart' as root_app;
import 'package:acne_detector/pages/login.dart';

//var resJson;
//
// void main(List<String> args, File image) {
//   print("IM RUNNING");
//
//   // hello().then((i) {
//   //   print(i);
//   // });
//
//   onUploadImage(image).then((i) {
//     print(i);
//   });
//
// }

Future<String> onUploadImage(File image) async {
  var request = http.MultipartRequest(
    'POST',
    //Uri.parse("http://10.0.2.2:8000/model"),
    //Uri.parse("http://192.168.0.183:8000/server/prediction"),
    Uri.parse("http://192.168.0.183:8000/server/prediction"),
    //Uri.parse("http://172.17.48.46:8000/model"),
  );
  Map<String, String> headers = {"Content-type": "multipart/form-data"};
  request.fields['UID'] = UserID as String;
  request.files.add(
    http.MultipartFile(
      'image',
      image.readAsBytes().asStream(),
      image.lengthSync(),
      filename: image.path.split('/').last,
    ),
  );
  request.headers.addAll(headers);
  print("request: " + request.toString());
  var res = await request.send();
  http.Response response = await http.Response.fromStream(res);
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to load');
  }
}

Future<String> request() async {
  var request = http.MultipartRequest(
    'POST',
    //Uri.parse("http://10.0.2.2:8000/model"),
    //Uri.parse("http://192.168.0.183:8000//server/history"),
    Uri.parse("http://192.168.0.183:8000/server/history"),
    //Uri.parse("http://172.17.48.46:8000/model"),
  );
  Map<String, String> headers = {"Content-type": "multipart/form-data"};
  request.fields['UID'] = UserID as String;
  request.headers.addAll(headers);
  print("request: " + request.toString());
  var res = await request.send();
  http.Response response = await http.Response.fromStream(res);
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to load');
  }
}

Future<String> updatePredictions(String time, String acneType) async {
  var request = http.MultipartRequest(
    'POST',
    //Uri.parse("http://10.0.2.2:8000/model"),
    //Uri.parse("http://192.168.0.183:8000//server/history"),
    Uri.parse("http://192.168.0.183:8000/server/select"),
    //Uri.parse("http://172.17.48.46:8000/model"),
  );
  Map<String, String> headers = {"Content-type": "multipart/form-data"};
  request.fields['UID'] = UserID as String;
  request.fields['time'] = time;
  request.fields['acneType'] = acneType;

  request.headers.addAll(headers);
  print("request: " + request.toString());
  var res = await request.send();
  http.Response response = await http.Response.fromStream(res);
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to load');
  }
}

Future<String> deletePredictions(String time) async {
  var request = http.MultipartRequest(
    'POST',
    //Uri.parse("http://10.0.2.2:8000/model"),
    //Uri.parse("http://192.168.0.183:8000//server/history"),
    Uri.parse("http://192.168.0.183:8000/server/remove"),
    //Uri.parse("http://172.17.48.46:8000/model"),
  );
  Map<String, String> headers = {"Content-type": "multipart/form-data"};
  request.fields['UID'] = UserID as String;
  request.fields['time'] = time;

  request.headers.addAll(headers);
  print("request: " + request.toString());
  var res = await request.send();
  http.Response response = await http.Response.fromStream(res);
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to load');
  }
}

//
// Future<String> hello() async {
//   final response =
//   await http.get(Uri.parse('http://10.0.2.2:8000/hello'));
//   print("Buddygi");
//   if (response.statusCode == 200) {
//     print("MM");
//     return response.body;
//   } else {
//     throw Exception('Failed to load');
//   }
// }

