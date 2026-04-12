import 'package:api_fussball_dart/dto/match_detail_transfer.dart';
import 'package:api_fussball_dart/html/font.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

class MatchDetail {
  ScoreFont scoreFont = ScoreFont();

  Future<MatchDetailTransfer> parseHTML(
      String lineupHtml, String courseHtml) async {
    var result = MatchDetailTransfer();

    var lineupDoc = parse(lineupHtml.replaceAll('&#', ''));
    var courseDoc = parse(courseHtml.replaceAll('&#', ''));

    _parseTeamInfo(lineupDoc, result);
    await _parseLineup(lineupDoc, result);
    await _parseCourse(courseDoc, result);
    _calculateMinutes(result);

    _clearFontCache(lineupDoc);
    _clearFontCache(courseDoc);

    return result;
  }

  void _parseTeamInfo(Document document, MatchDetailTransfer result) {
    var home = document.querySelector('.head .home');
    var away = document.querySelector('.head .away');

    if (home != null) {
      result.homeTeam =
          home.querySelector('.club-name a')?.text.trim() ?? '';
      var logoImg = home.querySelector('.club-logo img');
      if (logoImg != null) {
        var src = logoImg.attributes['src'] ?? '';
        result.homeLogo = src.startsWith('http') ? src : 'https:$src';
      }
    }

    if (away != null) {
      result.awayTeam =
          away.querySelector('.club-name a')?.text.trim() ?? '';
      var logoImg = away.querySelector('.club-logo img');
      if (logoImg != null) {
        var src = logoImg.attributes['src'] ?? '';
        result.awayLogo = src.startsWith('http') ? src : 'https:$src';
      }
    }
  }

  Future<void> _parseLineup(
      Document document, MatchDetailTransfer result) async {
    // Starting XI
    await _parsePlayers(document, '.starting .club-wrapper', 'starter', result);

    // Substitutes
    await _parsePlayers(document, '.substitutes', 'bench', result);
  }

  Future<void> _parsePlayers(Document document, String wrapperSelector,
      String role, MatchDetailTransfer result) async {
    var wrapper = document.querySelector(wrapperSelector);
    if (wrapper == null) return;

    var clubs = wrapper.querySelectorAll('.club');
    for (var club in clubs) {
      bool isAway = club.classes.contains('last');
      String team = isAway ? 'away' : 'home';
      var players = club.querySelectorAll('a.player-wrapper');
      for (var playerEl in players) {
        var player = await _parsePlayer(playerEl, team, role);
        result.players.add(player);
      }
    }
  }

  Future<MatchPlayerTransfer> _parsePlayer(
      Element element, String team, String role) async {
    var player = MatchPlayerTransfer();
    player.team = team;
    player.role = role;

    player.profileUrl = element.attributes['href'] ?? '';
    player.playerId = _extractPlayerId(player.profileUrl);

    var numberSpan = element.querySelector('.player-number');
    if (numberSpan != null) {
      player.shirtNumber = int.tryParse(numberSpan.text.trim()) ?? 0;
    }

    var captain = element.querySelector('.captain .c');
    if (captain != null) {
      var text = captain.text.trim();
      if (text == 'C') player.isCaptain = true;
      if (text == 'T') player.isGoalkeeper = true;
    }

    var imageSpan = element.querySelector('span[data-responsive-image]');
    if (imageSpan != null) {
      var image = imageSpan.attributes['data-responsive-image'] ?? '';
      player.image = image.startsWith('http') ? image : 'https:$image';
    }

    await _parsePlayerName(element, player);

    return player;
  }

  Future<void> _parsePlayerName(
      Element element, MatchPlayerTransfer player) async {
    var firstNameSpan =
        element.querySelector('.player-name .firstname[data-obfuscation]');
    var lastNameSpan =
        element.querySelector('.player-name .lastname[data-obfuscation]');

    if (firstNameSpan != null) {
      String fontName = firstNameSpan.attributes['data-obfuscation']!;
      player.firstName =
          await scoreFont.getScore(fontName, firstNameSpan.innerHtml);
    }
    if (lastNameSpan != null) {
      String fontName = lastNameSpan.attributes['data-obfuscation']!;
      player.lastName =
          await scoreFont.getScore(fontName, lastNameSpan.innerHtml);
    }
  }

  Future<void> _parseCourse(
      Document document, MatchDetailTransfer result) async {
    // Parse end time
    var finalSection = document.querySelector('.final .headline');
    if (finalSection != null) {
      var timeSpan = finalSection.querySelector('span');
      if (timeSpan != null) {
        result.endTime = timeSpan.text.trim();
      }
    }

    // Parse events from both halves
    var containers = document.querySelectorAll('.match-course .events .container');
    for (var container in containers) {
      var rows = container.querySelectorAll('.row-event');
      for (var row in rows) {
        var event = await _parseEvent(row);
        if (event != null) {
          result.events.add(event);
        }
      }
    }
  }

  Future<MatchEventTransfer?> _parseEvent(Element row) async {
    var event = MatchEventTransfer();

    // Determine team
    event.team = row.classes.contains('event-right') ? 'away' : 'home';

    // Parse minute
    var minuteEl = row.querySelector('.column-time .valign-inner');
    if (minuteEl != null) {
      var stoppageEl = minuteEl.querySelector('div');
      if (stoppageEl != null) {
        event.stoppageTime = int.tryParse(stoppageEl.text.trim().replaceAll('+', '')) ?? 0;
        stoppageEl.remove();
      }
      var minuteText = minuteEl.text.replaceAll(RegExp(r'[^0-9]'), '');
      event.minute = int.tryParse(minuteText) ?? 0;
    }

    // Determine event type
    var eventCell = row.querySelector('.column-event');
    var playerCell = row.querySelector('.column-player');

    if (eventCell == null) return null;

    if (eventCell.querySelector('.icon-card.yellow-card') != null) {
      event.type = 'yellowCard';
    } else if (eventCell.querySelector('.icon-card.yellow-red-card') != null) {
      event.type = 'yellowRedCard';
    } else if (eventCell.querySelector('.icon-card.red-card') != null) {
      event.type = 'redCard';
    } else if (eventCell.querySelector('.icon-substitute') != null) {
      event.type = 'substitution';
      if (playerCell != null) {
        var links = playerCell.querySelectorAll('a[href*="spielerprofil"]');
        if (links.isNotEmpty) {
          event.playerIn = _extractPlayerId(links[0].attributes['href'] ?? '');
        }
        if (links.length > 1) {
          event.playerOut =
              _extractPlayerId(links[1].attributes['href'] ?? '');
        }
      }
    } else if (eventCell.querySelector('.score-left') != null) {
      event.type = 'goal';
      if (playerCell != null) {
        var link = playerCell.querySelector('a[href*="spielerprofil"]');
        if (link != null) {
          event.scorer = _extractPlayerId(link.attributes['href'] ?? '');
        }
      }
      var scoreLeft = eventCell.querySelector('.score-left');
      var scoreRight = eventCell.querySelector('.score-right');
      if (scoreLeft != null && scoreRight != null) {
        String fontName =
            scoreLeft.attributes['data-obfuscation'] ?? '';
        if (fontName.isNotEmpty) {
          event.scoreLeft =
              await scoreFont.getScore(fontName, scoreLeft.innerHtml);
          event.scoreRight =
              await scoreFont.getScore(fontName, scoreRight.innerHtml);
        }
      }
    } else {
      return null;
    }

    return event;
  }

  String _extractPlayerId(String url) {
    var parts = url.split('/');
    return parts.isNotEmpty ? parts.last : '';
  }

  void _calculateMinutes(MatchDetailTransfer result) {
    Map<String, int> subInMinute = {};
    Map<String, int> subOutMinute = {};
    Map<String, int> goalCount = {};

    for (var event in result.events) {
      if (event.type == 'substitution') {
        if (event.playerIn.isNotEmpty) {
          subInMinute[event.playerIn] = event.minute;
        }
        if (event.playerOut.isNotEmpty) {
          subOutMinute[event.playerOut] = event.minute;
        }
      } else if (event.type == 'goal' && event.scorer.isNotEmpty) {
        goalCount[event.scorer] = (goalCount[event.scorer] ?? 0) + 1;
      }
    }

    for (var player in result.players) {
      player.goals = goalCount[player.playerId] ?? 0;
      if (player.role == 'starter') {
        player.minuteIn = 0;
        if (subOutMinute.containsKey(player.playerId)) {
          player.minuteOut = subOutMinute[player.playerId]!;
          player.minutesPlayed = player.minuteOut;
        } else {
          player.minutesPlayed = 90;
        }
      } else if (subInMinute.containsKey(player.playerId)) {
        // Bench player who came on
        player.role = 'substitute';
        player.minuteIn = subInMinute[player.playerId]!;
        if (subOutMinute.containsKey(player.playerId)) {
          player.minuteOut = subOutMinute[player.playerId]!;
          player.minutesPlayed = player.minuteOut - player.minuteIn;
        } else {
          player.minutesPlayed = 91 - player.minuteIn;
        }
      }
    }
  }

  void _clearFontCache(Document document) {
    var elements = document.querySelectorAll('[data-obfuscation]');
    Set<String> uniqueValues = {};
    for (Element element in elements) {
      uniqueValues.add(element.attributes['data-obfuscation']!);
    }
    for (String value in uniqueValues) {
      scoreFont.fontCache.remove(value);
    }
  }
}
