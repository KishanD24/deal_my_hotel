import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../screens/login_screen.dart';

import '../../main.dart';
import '../extensions/common.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/shared_pref.dart';
import '../utils/app_config.dart';
import '../utils/constants.dart';

Map<String, String> buildHeaderTokens() {
  Map<String, String> header = {
    HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
    HttpHeaders.cacheControlHeader: 'no-cache',
    HttpHeaders.acceptHeader: 'application/json; charset=utf-8',
    'Access-Control-Allow-Headers': '*',
    'Access-Control-Allow-Origin': '*',
  };

  if (appStore.isLoggedIn) {
    header.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer ${userStore.token}');
  }
  log(jsonEncode(header));
  return header;
}

Uri buildBaseUrl(String endPoint) {
  Uri url = Uri.parse(endPoint);
  if (!endPoint.startsWith('http')) url = Uri.parse('$mBaseUrl$endPoint');
  log('URL: ${url.toString()}');

  return url;
}

Future<Response> buildHttpResponse(String endPoint, {HttpMethod method = HttpMethod.GET, Map? request, String? req}) async {
  if (await isNetworkAvailable()) {
    var headers = buildHeaderTokens();
    Uri url = buildBaseUrl(endPoint);

    try {
      final stopwatch = Stopwatch()..start();

      Response response;
      String requestData = request != null ? jsonEncode(request) : "";

      if (method == HttpMethod.POST) {
        response = await http.post(url, body: req ?? jsonEncode(request), headers: headers)
            .timeout(Duration(seconds: 20), onTimeout: () => throw 'Timeout');
      } else if (method == HttpMethod.DELETE) {
        response = await delete(url, headers: headers)
            .timeout(Duration(seconds: 20), onTimeout: () => throw 'Timeout');
      } else if (method == HttpMethod.PUT) {
        response = await put(url, body: req ?? jsonEncode(request), headers: headers)
            .timeout(Duration(seconds: 20), onTimeout: () => throw 'Timeout');
      } else {
        response = await get(url, headers: headers)
            .timeout(Duration(seconds: 20), onTimeout: () => throw 'Timeout');
      }

      stopwatch.stop();

      print("\n📢 ┌───────────────────────────── Start log report from App: ${DateTime.now()} ─────────────────────────────┐");
      print("⏱️ Api execution time (mm:ss:ms):  ${stopwatch.elapsed.inMinutes}:${stopwatch.elapsed.inSeconds % 60}:${stopwatch.elapsed.inMilliseconds % 1000}");
      print("🌐 Url:  $url");
      print("📩 Header:  ${jsonEncode(headers)}");
      if (requestData.isNotEmpty) print("📤 Request:  $requestData");
      print("✅ Response ($method): ${response.statusCode}  ");
      print("📦 Body: ${response.body}");
      print("📢 └───────────────────────────── End log report from App: ${DateTime.now()} ───────────────────────────────┘\n");

      return response;
    } catch (e) {
      throw 'somethingWentWrong';
    }
  } else {
    throw errorInternetNotAvailable;
  }
}

Future handleResponse(Response response) async {
  if (!await isNetworkAvailable()) {
    throw errorInternetNotAvailable;
  }

  if (response.statusCode.isSuccessful()) {
    return jsonDecode(response.body);
  } else {
    var string = await (isJsonValid(response.body));
    print("jsonDecode(response.body)" + string.toString());
    if (string!.isNotEmpty) {
      if (string.toString().contains("Unauthenticated")) {
        await removeKey(IS_LOGIN);
        await removeKey(USER_ID);
        await removeKey(FIRSTNAME);
        await removeKey(LASTNAME);
        await removeKey(PHONE_NUMBER);
        await removeKey(GENDER);
        await removeKey(IS_OTP);

        userStore.clearUserData();
        userStore.setLogin(false);
        push(LoginScreen());
      } else {
        throw string;
      }
    } else {
      throw 'Please try again later.';
    }
  }
}

enum HttpMethod { GET, POST, DELETE, PUT }

class TokenException implements Exception {
  final String message;

  const TokenException([this.message = ""]);

  String toString() => "FormatException: $message";
}

Future<String?> isJsonValid(json) async {
  try {
    var f = jsonDecode(json) as Map<String, dynamic>;
    return f['message'];
  } catch (e) {
    log(e.toString());
    return "";
  }
}

Future<MultipartRequest> getMultiPartRequest(String endPoint, {String? baseUrl}) async {
  String url = '${baseUrl ?? buildBaseUrl(endPoint).toString()}';
  log(url);
  return MultipartRequest('POST', Uri.parse(url));
}

Future<void> sendMultiPartRequest(MultipartRequest multiPartRequest, {Function(dynamic)? onSuccess, Function(dynamic)? onError}) async {
  http.Response response = await http.Response.fromStream(await multiPartRequest.send());
  print("Result:${response.statusCode} ${response.body}");

  if (response.statusCode.isSuccessful()) {
    onSuccess?.call(response.body);
  } else {
    onError?.call(errorSomethingWentWrong);
  }
}

Future<bool> isNetworkAvailable() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult != ConnectivityResult.none;
}

Future<bool> isConnectedToMobile() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult == ConnectivityResult.mobile;
}

Future<bool> isConnectedToWiFi() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult == ConnectivityResult.wifi;
}

JsonDecoder decoder = JsonDecoder();
JsonEncoder encoder = JsonEncoder.withIndent('  ');
void prettyPrintJson(String input) {
  var object = decoder.convert(input);
  var prettyString = encoder.convert(object);
  prettyString.split('\n').forEach((element) => log(element));
}

void apiURLResponseLog(
    {String url = "", String endPoint = "", String headers = "", String request = "", int statusCode = 0, dynamic responseBody = "", String methodType = "", bool hasRequest = false}) {
  log("\u001B[39m \u001b[96m┌───────────────────────────────────────────────────────────────────────────────────────────────────────┐\u001B[39m");
  log("\u001B[39m \u001b[96m Time: ${DateTime.now()}\u001B[39m");
  log("\u001b[31m Url: \u001B[39m $url");
  log("\u001b[31m Header: \u001B[39m \u001b[96m$headers\u001B[39m");
  if (request.isNotEmpty) log("\u001b[31m Request: \u001B[39m \u001b[96m$request\u001B[39m");
  log("${statusCode.isSuccessful() ? "\u001b[32m" : "\u001b[31m"}");
  log('Response ($methodType) $statusCode ${statusCode.isSuccessful() ? "\u001b[32m" : "\u001b[31m"} ');
  prettyPrintJson(responseBody);
  log("\u001B[0m");
  log("\u001B[39m \u001b[96m└───────────────────────────────────────────────────────────────────────────────────────────────────────┘\u001B[39m");
}