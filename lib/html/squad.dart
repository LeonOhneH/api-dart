import 'package:api_fussball_dart/dto/player_transfer.dart';
import 'package:api_fussball_dart/html/font.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

class Squad {
  ScoreFont scoreFont = ScoreFont();

  Future<List<PlayerTransfer>> parseHTML(String html) async {
    List<PlayerTransfer> results = [];

    var document = parse(html.replaceAll('&#', ''));
    List<Element> rows = document.querySelectorAll('table.table-striped tr');

    for (var row in rows) {
      if (row.classes.contains('thead')) {
        continue;
      }

      List<Element> cells = row.querySelectorAll('td');
      if (cells.isEmpty) {
        continue;
      }

      PlayerTransfer player = PlayerTransfer();

      Element playerCell = cells[0];
      _addPlayerInfo(playerCell, player);
      await _addPlayerName(playerCell, player);

      if (cells.length > 1) {
        player.appearances = _parseIntOrZero(cells[1].text);
      }
      if (cells.length > 2) {
        player.minutes = _parseIntOrZero(cells[2].text);
      }
      if (cells.length > 3) {
        player.goals = _parseIntOrZero(cells[3].text);
      }

      results.add(player);
    }

    _clearFontCache(document);

    return results;
  }

  void _addPlayerInfo(Element playerCell, PlayerTransfer player) {
    Element? link = playerCell.querySelector('a.player-wrapper');
    if (link != null) {
      player.profileUrl = link.attributes['href'] ?? '';
    }

    Element? imageSpan = playerCell.querySelector('span[data-responsive-image]');
    if (imageSpan != null) {
      var image = imageSpan.attributes['data-responsive-image'];
      if (image != null) {
        player.image = image.startsWith('http') ? image : 'https:$image';
      }
    }
  }

  Future<void> _addPlayerName(Element playerCell, PlayerTransfer player) async {
    Element? nameSpan = playerCell.querySelector('.player-name span[data-obfuscation]');
    if (nameSpan != null) {
      String fontName = nameSpan.attributes['data-obfuscation']!;
      String fullName = await scoreFont.getScore(fontName, nameSpan.innerHtml);

      List<String> parts = fullName.split(',');
      if (parts.length >= 2) {
        player.lastName = parts[0].trim();
        player.firstName = _addSpacesBeforeUppercase(parts.sublist(1).join(',').trim());
      } else {
        player.lastName = fullName.trim();
      }
    }
  }

  String _addSpacesBeforeUppercase(String name) {
    return name.replaceAllMapped(
      RegExp(r'(?<=[a-zäöü])(?=[A-ZÄÖÜ])'),
      (match) => ' ',
    );
  }

  int _parseIntOrZero(String value) {
    String trimmed = value.trim();
    return int.tryParse(trimmed) ?? 0;
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
