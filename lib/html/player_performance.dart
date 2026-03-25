import 'package:api_fussball_dart/dto/player_performance_transfer.dart';
import 'package:api_fussball_dart/html/font.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

class PlayerPerformance {
  ScoreFont scoreFont = ScoreFont();

  Future<PlayerPerformanceResultTransfer> parseHTML(String html) async {
    PlayerPerformanceResultTransfer result = PlayerPerformanceResultTransfer();

    var document = parse(html.replaceAll('&#', ''));

    _parseFilters(document, result);
    await _parseMatches(document, result);
    _parseSummary(document, result);
    _clearFontCache(document);

    return result;
  }

  void _parseFilters(
      Document document, PlayerPerformanceResultTransfer result) {
    Element? saisonSelect = document.querySelector('select[name="saison"]');
    if (saisonSelect != null) {
      result.seasons = _parseSelectOptions(saisonSelect);
    }

    Element? teamSelect = document.querySelector('select[name="team-id"]');
    if (teamSelect != null) {
      result.teams = _parseSelectOptions(teamSelect);
    }

    Element? staffelSelect = document.querySelector('select[name="staffel"]');
    if (staffelSelect != null) {
      result.competitions = _parseSelectOptions(staffelSelect);
    }
  }

  List<PlayerPerformanceFilterOption> _parseSelectOptions(Element select) {
    List<PlayerPerformanceFilterOption> options = [];
    for (var option in select.querySelectorAll('option')) {
      PlayerPerformanceFilterOption filter = PlayerPerformanceFilterOption();
      filter.value = option.attributes['value'] ?? '';
      filter.label = option.text.trim();
      filter.selected = option.attributes.containsKey('selected');
      options.add(filter);
    }
    return options;
  }

  Future<void> _parseMatches(
      Document document, PlayerPerformanceResultTransfer result) async {
    List<Element> rows = document.querySelectorAll('tbody tr');

    for (var row in rows) {
      if (row.classes.contains('row-headline')) {
        continue;
      }

      List<Element> cells = row.querySelectorAll('td');
      if (cells.length < 10) {
        continue;
      }

      PlayerPerformanceMatchTransfer match = PlayerPerformanceMatchTransfer();

      // Cell 0: Date (hidden-small)
      match.date = cells[0].text.trim();

      // Cell 1: Home team
      _parseTeam(cells[1], match, true);

      // Cell 2: Colon separator — skip

      // Cell 3: Away team
      _parseTeam(cells[3], match, false);

      // Cell 4: Score (obfuscated)
      await _parseScore(cells[4], match);

      // Cell 5: Goals
      match.goals = _cleanDash(cells[5].text);

      // Cell 6: Sub in
      match.subIn = _cleanDash(cells[6].text);

      // Cell 7: Sub out
      match.subOut = _cleanDash(cells[7].text);

      // Cell 8: Minutes
      match.minutes = _cleanDash(cells[8].text);

      // Cell 9: Match detail link
      Element? detailLink = cells[9].querySelector('a');
      if (detailLink != null) {
        match.matchUrl = detailLink.attributes['href'] ?? '';
      }

      result.matches.add(match);
    }
  }

  void _parseTeam(
      Element cell, PlayerPerformanceMatchTransfer match, bool isHome) {
    Element? clubName = cell.querySelector('.club-name');
    Element? clubLogo = cell.querySelector('.club-logo img');

    String name = (clubName?.text.trim() ?? '').replaceAll(RegExp(r'\d{4,};'), '');
    String logo = '';
    if (clubLogo != null) {
      logo = clubLogo.attributes['src'] ?? '';
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

  Future<void> _parseScore(
      Element cell, PlayerPerformanceMatchTransfer match) async {
    Element? scoreLeft = cell.querySelector('.score-left');
    Element? scoreRight = cell.querySelector('.score-right');

    if (scoreLeft != null) {
      String? fontName = scoreLeft.attributes['data-obfuscation'];
      if (fontName != null) {
        match.homeScore = await scoreFont.getScore(fontName, scoreLeft.innerHtml);
      }
    }

    if (scoreRight != null) {
      String? fontName = scoreRight.attributes['data-obfuscation'];
      if (fontName != null) {
        match.awayScore = await scoreFont.getScore(fontName, scoreRight.innerHtml);
      }
    }
  }

  String _cleanDash(String text) {
    String trimmed = text.trim();
    if (trimmed == '\u2013' || trimmed == '-' || trimmed.isEmpty) {
      return '';
    }
    return trimmed;
  }

  void _parseSummary(
      Document document, PlayerPerformanceResultTransfer result) {
    Element? summaryRow = document.querySelector('tfoot tr.summary');
    if (summaryRow != null) {
      List<Element> cells = summaryRow.querySelectorAll('td');
      if (cells.length >= 9) {
        result.totalAppearances = int.tryParse(cells[4].text.trim()) ?? 0;
        result.totalMinutes = int.tryParse(cells[8].text.trim()) ?? 0;
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
