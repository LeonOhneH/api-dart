import 'dart:convert';
import 'dart:io';

import 'package:api_fussball_dart/controller/api.dart';
import 'package:api_fussball_dart/dto/response_dto.dart';
import 'package:api_fussball_dart/middleware.dart';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

ApiController gamesController = ApiController();

// Configure routes.
final _router = Router()
  ..get('/api/club/<id>',  (Request request) => headerTokenCheckMiddleware()(gamesController.clubAction)(request))
  ..get('/api/club/info/<id>',  (Request request) => headerTokenCheckMiddleware()(gamesController.clubInfoAction)(request))
  ..get('/api/club/next_games/<id>',  (Request request) => headerTokenCheckMiddleware()(gamesController.nextGameAction)(request))
  ..get('/api/club/prev_games/<id>',  (Request request) => headerTokenCheckMiddleware()(gamesController.prevGameAction)(request))
  ..get('/api/team/next_games/<id>',  (Request request) => headerTokenCheckMiddleware()(gamesController.nextTeamAction)(request))
  ..get('/api/team/prev_games/<id>',  (Request request) => headerTokenCheckMiddleware()(gamesController.prevTeamAction)(request))
  ..get('/api/team/table/<id>',  (Request request) => headerTokenCheckMiddleware()(gamesController.tableAction)(request))
  ..get('/api/team/squad/<id>',  (Request request) => headerTokenCheckMiddleware()(gamesController.squadAction)(request))
  ..get('/api/team/<id>',  (Request request) => headerTokenCheckMiddleware()(gamesController.teamAction)(request))
  ..get('/api/team/matches/<id>',  (Request request) => headerTokenCheckMiddleware()(gamesController.teamMatchesAction)(request))
  ..get('/api/player/performance/<id>',  (Request request) => headerTokenCheckMiddleware()(gamesController.playerPerformanceAction)(request))
  ..get('/api/match/<id>',  (Request request) => headerTokenCheckMiddleware()(gamesController.matchDetailAction)(request))

  ..all('/api/<anything|.*>', (Request request) {
    ResponseErrorDto responseErrorDto = ResponseErrorDto('Route not found');
    return Response.notFound(jsonEncode(responseErrorDto), headers: {'Content-Type': 'application/json'});
  })
;

Middleware corsMiddleware() {
  return (Handler handler) {
    return (Request request) async {
      // Handle preflight requests (OPTIONS)
      if (request.method == 'OPTIONS') {
        return Response.ok('',
            headers: {
              'Access-Control-Allow-Origin': '*',
              'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
              'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept, Authorization, x-auth-token',
              'Access-Control-Max-Age': '86400', // cache preflight for 1 day
            });
      }

      // Handle actual request
      final response = await handler(request);

      // Always add CORS headers
      return response.change(headers: {
        ...response.headers,
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept, Authorization, x-auth-token',
      });
    };
  };
}

void main(List<String> args) async {
  final ip = InternetAddress.anyIPv4;

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsMiddleware()) 
      .addMiddleware(jsonResponseMiddleware)
      .addMiddleware(globalErrorMiddleware())
      .addHandler(_router.call);

  final port = int.parse(Platform.environment['PORT'] ?? '8081');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
