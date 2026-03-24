import 'package:api_fussball_dart/dto/player_transfer.dart';
import 'package:api_fussball_dart/html/font.dart';
import 'package:api_fussball_dart/html/squad.dart';
import 'package:test/test.dart';

class MockFont implements FontInterface {
  @override
  Future<Map<String, String>> decodeFont(String fontName) async {
    return {
      'x41': 'A',
      'x6e': 'n',
      'x64': 'd',
      'x72': 'r',
      'x65': 'e',
      'x61': 'a',
      'x73': 's',
      'x20': ' ',
      'x4d': 'M',
      'x75': 'u',
      'x6c': 'l',
      'x2c': ',',
      'x52': 'R',
      'x69': 'i',
      'x63': 'c',
      'x68': 'h',
      'x74': 't',
      'x4e': 'N',
      'x48': 'H',
      'x6b': 'k',
      'x78': 'x',
    };
  }
}

void main() {
  test('squad parses players with first and last name', () async {
    // Names in format: LastName,FirstName (as fussball.de delivers them)
    // "Richter,MaxHenrik" -> firstName: "Max Henrik", lastName: "Richter"
    // "Muller,Anna" -> firstName: "Anna", lastName: "Muller"
    final String htmlString = '''
<div class="team-squad-table">
  <div class="table-container table-full">
    <table class="table table-striped table-full-width">
      <thead>
        <tr class="thead">
          <th>Spieler</th>
          <th>Einsätze</th>
          <th class="hidden-small">Einsatzminuten</th>
          <th>Tore</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td class="column-player">
            <a href="https://www.fussball.de/spielerprofil/-/userid/ABC123" class="player-wrapper">
              <div class="player-image table-image hidden-small"><span data-alt="player-thumbnail" data-responsive-image="//cdn.fussball.de/public/image1.jpg"></span></div>
              <div class="player-name"><span data-obfuscation="testfont1">x52;x69;x63;x68;x74;x65;x72;x2c;x4d;x61;x78;x48;x65;x6e;x72;x69;x6b;</span></div>
            </a>
          </td>
          <td>18</td>
          <td class="hidden-small">1419</td>
          <td>5</td>
        </tr>
        <tr>
          <td class="column-player">
            <a href="https://www.fussball.de/spielerprofil/-/player-id/DEF456" class="player-wrapper">
              <div class="player-image table-image hidden-small"><span data-alt="player-thumbnail" data-responsive-image="//cdn.fussball.de/public/image2.jpg"></span></div>
              <div class="player-name"><span data-obfuscation="testfont1">x4d;x75;x6c;x6c;x65;x72;x2c;x41;x6e;x6e;x61;</span></div>
            </a>
          </td>
          <td>10</td>
          <td class="hidden-small">800</td>
          <td>3</td>
        </tr>
        <tr>
          <td class="column-player">
            <a href="https://www.fussball.de/spielerprofil/-/userid/GHI789" class="player-wrapper">
              <div class="player-image table-image hidden-small"><span data-alt="player-thumbnail" data-responsive-image="//cdn.fussball.de/public/image3.jpg"></span></div>
              <div class="player-name"><span data-obfuscation="testfont1">x41;x6e;x6e;x61;</span></div>
            </a>
          </td>
          <td>&nbsp;</td>
          <td class="hidden-small">&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
      </tbody>
    </table>
  </div>
</div>
''';

    Squad squad = Squad();
    squad.scoreFont = ScoreFont();
    squad.scoreFont.font = MockFont();

    List<PlayerTransfer> players = await squad.parseHTML(htmlString);

    expect(players.length, equals(3));

    // First player: "Richter,MaxHenrik" -> split into first/last, space before uppercase
    expect(players[0].firstName, equals('Max Henrik'));
    expect(players[0].lastName, equals('Richter'));
    expect(players[0].profileUrl, equals('https://www.fussball.de/spielerprofil/-/userid/ABC123'));
    expect(players[0].image, equals('https://cdn.fussball.de/public/image1.jpg'));
    expect(players[0].appearances, equals(18));
    expect(players[0].minutes, equals(1419));
    expect(players[0].goals, equals(5));

    // Second player: "Muller,Anna" -> single first name, no space needed
    expect(players[1].firstName, equals('Anna'));
    expect(players[1].lastName, equals('Muller'));
    expect(players[1].profileUrl, equals('https://www.fussball.de/spielerprofil/-/player-id/DEF456'));
    expect(players[1].image, equals('https://cdn.fussball.de/public/image2.jpg'));
    expect(players[1].appearances, equals(10));
    expect(players[1].minutes, equals(800));
    expect(players[1].goals, equals(3));

    // Third player: no comma, only "Anna" -> goes to lastName
    expect(players[2].firstName, equals(''));
    expect(players[2].lastName, equals('Anna'));
    expect(players[2].appearances, equals(0));
    expect(players[2].minutes, equals(0));
    expect(players[2].goals, equals(0));
  });

  group('PlayerTransfer', () {
    test('toJson', () {
      var player = PlayerTransfer()
        ..firstName = 'Max'
        ..lastName = 'Mustermann'
        ..image = 'https://example.com/image.jpg'
        ..profileUrl = 'https://www.fussball.de/spielerprofil/-/userid/ABC'
        ..appearances = 15
        ..minutes = 1200
        ..goals = 7;

      var expectedJson = {
        'firstName': 'Max',
        'lastName': 'Mustermann',
        'image': 'https://example.com/image.jpg',
        'profileUrl': 'https://www.fussball.de/spielerprofil/-/userid/ABC',
        'appearances': 15,
        'minutes': 1200,
        'goals': 7,
      };

      expect(player.toJson(), expectedJson);
    });
  });
}
