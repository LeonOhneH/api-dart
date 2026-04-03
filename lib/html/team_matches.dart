import 'package:api_fussball_dart/dto/team_matches_transfer.dart';
import 'package:api_fussball_dart/html/font.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

class TeamMatches {
  ScoreFont scoreFont = ScoreFont();

  Future<List<TeamMatchTransfer>> parseHTML(String html) async {
    List<TeamMatchTransfer> results = [];

    var document = parse(html.replaceAll('&#', ''));
    List<Element> rows = document.querySelectorAll('tbody tr');

    String currentCompetition = '';
    String currentDate = '';
    String currentTime = '';

    for (var row in rows) {
      if (row.classes.contains('row-headline')) {
        var parsed = await _parseHeadline(row);
        currentCompetition = parsed.$1;
        currentDate = parsed.$2;
        currentTime = parsed.$3;
        continue;
      }

      if (row.classes.contains('row-competition')) {
        continue;
      }

      if (row.classes.contains('row-venue')) {
        continue;
      }

      List<Element> clubs = row.querySelectorAll('.column-club');
      if (clubs.length < 2) {
        continue;
      }

      TeamMatchTransfer match = TeamMatchTransfer();
      match.competition = currentCompetition;
      match.date = currentDate;
      match.time = currentTime;

      _parseTeam(clubs[0], match, true);
      _parseTeam(clubs[1], match, false);
      await _parseScore(row, match);

      results.add(match);
    }

    _clearFontCache(document);

    return results;
  }

  Future<(String, String, String)> _parseHeadline(Element row) async {
    // row-headline contains: <span data-obfuscation="...">obfuscated date+time</span> Uhr | Competition
    // Decoded span: "Samstag, 05.04.2025 - 13:00"
    // Plaintext after span: " Uhr | Herren | Kreisliga C"
    Element? span = row.querySelector('span[data-obfuscation]');

    String date = '';
    String time = '';
    String competition = '';

    // Parse competition from plaintext part
    String text = row.text.trim();
    List<String> parts = text.split(' | ');
    if (parts.length >= 2) {
      competition = parts.sublist(1).join(' | ').trim();
    }

    RegExp dateRegex = RegExp(r'(\d{2}\.\d{2}\.\d{4})');
    RegExp timeRegex = RegExp(r'(\d{2}:\d{2})');

    if (span != null) {
      String? fontName = span.attributes['data-obfuscation'];
      if (fontName != null) {
        String decoded = await scoreFont.getScore(fontName, span.innerHtml);
        var dateMatch = dateRegex.firstMatch(decoded);
        if (dateMatch != null) date = dateMatch.group(1)!;
        var timeMatch = timeRegex.firstMatch(decoded);
        if (timeMatch != null) time = timeMatch.group(1)!;
      }
    } else {
      // Plaintext headline: "Sonntag, 29.03.2026 - 13:00 Uhr | Kreisliga C"
      var dateMatch = dateRegex.firstMatch(text);
      if (dateMatch != null) date = dateMatch.group(1)!;
      var timeMatch = timeRegex.firstMatch(text);
      if (timeMatch != null) time = timeMatch.group(1)!;
    }

    return (competition, date, time);
  }

  void _parseTeam(Element cell, TeamMatchTransfer match, bool isHome) {
    Element? nameEl = cell.querySelector('.club-name');
    Element? logoSpan = cell.querySelector('span[data-responsive-image]');

    String name = (nameEl?.text.trim() ?? '').replaceAll(RegExp(r'\d{4,};'), '');
    String logo = '';
    if (logoSpan != null) {
      logo = logoSpan.attributes['data-responsive-image'] ?? '';
      if (logo.startsWith('//')) {
        logo = 'https:$logo';
      }
    }

    if (isHome) {
      match.homeTeam = name;
      match.homeTeamLogo = logo;
    } else {
      match.awayTeam = name;
      match.awayTeamLogo = logo;
    }
  }

  Future<void> _parseScore(Element row, TeamMatchTransfer match) async {
    Element? scoreCell = row.querySelector('.column-score');
    if (scoreCell == null) return;

    match.matchUrl = scoreCell.querySelector('a')?.attributes['href'] ?? '';

    Element? scoreLeft = scoreCell.querySelector('.score-left');
    Element? scoreRight = scoreCell.querySelector('.score-right');

    // Check for info-text directly in score cell (not inside a score span)
    Element? infoText = scoreCell.querySelector('.info-text');
    bool hasScoreSpans = scoreLeft != null || scoreRight != null;

    if (infoText != null && !hasScoreSpans) {
      // No score spans — info-text is the main content
      String info = infoText.text.trim();
      RegExp dateRegex = RegExp(r'\d{2}\.\d{2}\.\d{4}');
      if (dateRegex.hasMatch(info)) {
        match.status = 'verlegt';
      } else {
        match.status = info;
      }
      return;
    }

    if (scoreLeft != null) {
      String? fontName = scoreLeft.attributes['data-obfuscation'];
      if (fontName != null) {
        match.homeScore =
            await scoreFont.getScore(fontName, scoreLeft.innerHtml);
      }
    }

    if (scoreRight != null) {
      String? fontName = scoreRight.attributes['data-obfuscation'];
      if (fontName != null) {
        match.awayScore =
            await scoreFont.getScore(fontName, scoreRight.innerHtml);
      }

      // Check for info-text inside score-right (e.g. walkover "w")
      Element? scoreInfo = scoreRight.querySelector('.info-text');
      if (scoreInfo != null) {
        match.status = scoreInfo.text.trim();
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
