import 'dart:convert';
import 'dart:io';

import 'package:api_fussball_dart/database.dart';
import 'package:api_fussball_dart/dto/response_dto.dart';
import 'package:shelf/shelf.dart';

Middleware headerTokenCheckMiddleware() {
  final apiKey = Platform.environment['API_KEY'] ?? '';
  final rateLimit = int.tryParse(Platform.environment['RATE_LIMIT'] ?? '') ?? 30;

  return (Handler innerHandler) {
    return (Request request) async {
      String? token = request.headers['x-auth-token'];
      if (token == null || token != apiKey) {
        ResponseErrorDto responseErrorDto = ResponseErrorDto('Unauthorized');
        return Response.unauthorized(jsonEncode(responseErrorDto), headers: {'Content-Type': 'application/json'});
      }

      int current = await RateLimitManager().get(0);
      if (current > rateLimit) {
        ResponseErrorDto responseErrorDto = ResponseErrorDto('You are allowed a maximum of $rateLimit queries per minute. Please try again later.');
        return Response(429, body: jsonEncode(responseErrorDto), headers: {'Content-Type': 'application/json'});
      }
      await RateLimitManager().add(0);

      return innerHandler(request);
    };
  };
}

Middleware jsonResponseMiddleware = createMiddleware(
  responseHandler: (Response response) {
    return response.change(headers: {'Content-Type': 'application/json'});
  },
);

Middleware globalErrorMiddleware() {
  return (Handler innerHandler) {
    return (Request request) async {
      try {
        return await innerHandler(request);
      } catch (e) {
        ResponseErrorDto responseErrorDto = ResponseErrorDto(e.toString());
        return Response.badRequest(body: jsonEncode(responseErrorDto), headers: {'Content-Type': 'application/json'});
      }
    };
  };
}
