import 'package:api_fussball_dart/dto/match_detail_transfer.dart';
import 'package:api_fussball_dart/html/font.dart';
import 'package:api_fussball_dart/html/match_detail.dart';
import 'package:test/test.dart';

class MockFont implements FontInterface {
  @override
  Future<Map<String, String>> decodeFont(String fontName) async {
    return {
      'x4d': 'M',
      'x61': 'a',
      'x78': 'x',
      'x20': ' ',
      'x48': 'H',
      'x65': 'e',
      'x6e': 'n',
      'x72': 'r',
      'x69': 'i',
      'x6b': 'k',
      'x52': 'R',
      'x63': 'c',
      'x68': 'h',
      'x74': 't',
      'x41': 'A',
      'x6c': 'l',
      'x4a': 'J',
      'x6f': 'o',
      'x73': 's',
      'x75': 'u',
      'x42': 'B',
      'x4c': 'L',
      'x54': 'T',
      'x6d': 'm',
      'x4e': 'N',
      'x50': 'P',
      'x31': '1',
      'x32': '2',
      'x33': '3',
      'x30': '0',
    };
  }
}

const String lineupHtml = '''
<div id="match_course_body">
  <div class="match-lineup">
    <div class="field-wrapper">
      <div class="field">
        <div class="head container">
          <div class="home">
            <div class="club-name"><a href="/mannschaft/home-team">Home FC</a></div>
            <div class="club-logo table-image">
              <div class="hexagon xsmall white"><span class="icon-hexagon"></span>
                <div class="inner"><div class="valign-wrapper"><div class="valign-inner">
                  <a href="/verein/home"><img src="//www.fussball.de/logo/home.png" alt="Home FC"></a>
                </div></div></div>
              </div>
            </div>
          </div>
          <div class="away">
            <div class="club-logo table-image">
              <div class="hexagon xsmall white"><span class="icon-hexagon"></span>
                <div class="inner"><div class="valign-wrapper"><div class="valign-inner">
                  <a href="/verein/away"><img src="https://www.fussball.de/logo/away.png" alt="Away United"></a>
                </div></div></div>
              </div>
            </div>
            <div class="club-name"><a href="/mannschaft/away-team">Away United</a></div>
          </div>
        </div>
        <div class="starting container">
          <div class="club-wrapper">
            <div class="club">
              <div class="group">
                <div class="group-inner">
                  <a href="https://www.fussball.de/spielerprofil/-/userid/PLAYER_H1" class="player-wrapper home">
                    <div class="player-image table-image hidden-small"><span data-alt="player-thumbnail" data-responsive-image="https://cdn.fussball.de/img/h1.jpg"></span></div>
                    <div class="player-name"><span data-obfuscation="testfont" class="firstname">x4d;x61;x78;</span><span data-obfuscation="testfont" class="lastname">x52;x69;x63;x68;x74;x65;x72;</span></div>
                    <span class="player-number">01</span>
                    <div class="captain"><span class="c">T</span></div>
                  </a>
                  <a href="https://www.fussball.de/spielerprofil/-/userid/PLAYER_H2" class="player-wrapper home">
                    <div class="player-name"><span data-obfuscation="testfont" class="firstname">x41;x6c;x65;x78;</span><span data-obfuscation="testfont" class="lastname">x4d;x75;x6c;x6c;x65;x72;</span></div>
                    <span class="player-number">10</span>
                    <div class="captain"><span class="c">C</span></div>
                  </a>
                  <a href="https://www.fussball.de/spielerprofil/-/player-id/PLAYER_H3" class="player-wrapper home">
                    <div class="player-name"><span data-obfuscation="testfont" class="firstname">x4a;x6f;x6e;x61;x73;</span><span data-obfuscation="testfont" class="lastname">x42;x65;x63;x6b;x65;x72;</span></div>
                    <span class="player-number">09</span>
                  </a>
                </div>
              </div>
            </div>
            <div class="club last">
              <div class="group">
                <div class="group-inner">
                  <a href="https://www.fussball.de/spielerprofil/-/userid/PLAYER_A1" class="player-wrapper away">
                    <div class="player-name"><span data-obfuscation="testfont" class="firstname">x54;x6f;x6d;</span><span data-obfuscation="testfont" class="lastname">x4e;x65;x75;x65;x72;</span></div>
                    <span class="player-number">01</span>
                    <div class="captain"><span class="c">T</span></div>
                  </a>
                  <a href="https://www.fussball.de/spielerprofil/-/player-id/PLAYER_A2" class="player-wrapper away">
                    <div class="player-name"><span data-obfuscation="testfont" class="firstname">x50;x61;x75;x6c;</span><span data-obfuscation="testfont" class="lastname">x4c;x61;x6e;x67;</span></div>
                    <span class="player-number">07</span>
                  </a>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="extra-wrapper">
      <div class="extra container">
        <div class="substitutes club-wrapper">
          <div class="club">
            <div class="group home">
              <a href="https://www.fussball.de/spielerprofil/-/userid/PLAYER_H4" class="player-wrapper home">
                <div class="player-name"><span data-obfuscation="testfont" class="firstname">x4c;x75;x6b;x61;x73;</span><span data-obfuscation="testfont" class="lastname">x48;x61;x68;x6e;</span></div>
                <span class="player-number">14</span>
              </a>
            </div>
          </div>
          <div class="club last">
            <div class="group away">
              <a href="https://www.fussball.de/spielerprofil/-/player-id/PLAYER_A3" class="player-wrapper away">
                <div class="player-name"><span data-obfuscation="testfont" class="firstname">x4e;x69;x6c;x73;</span><span data-obfuscation="testfont" class="lastname">x42;x65;x72;x6e;x74;</span></div>
                <span class="player-number">15</span>
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
''';

const String courseHtml = '''
<div id="match_course_body">
  <div class="match-course">
    <div class="first-half ingame">
      <div class="events">
        <div class="container">
          <div class="row-event event-left">
            <div class="column-player">
              <div class="valign-table"><div class="valign-cell">
                <a href="https://www.fussball.de/spielerprofil/-/player-id/PLAYER_H3">
                  <div class="player-name"><span data-obfuscation="testfont">x4a;x6f;x6e;x61;x73;</span></div>
                </a>
              </div></div>
            </div>
            <div class="column-event">
              <div class="valign-table"><div class="valign-cell">
                <div class="even"><span data-obfuscation="scorefont" class="score-left">x31;</span><span class="colon">:</span><span data-obfuscation="scorefont" class="score-right">x30;</span></div>
              </div></div>
            </div>
            <div class="column-time">
              <div class="hexagon green"><span class="icon-hexagon"></span>
                <div class="inner"><div class="valign-wrapper"><div class="valign-inner">23&rsquo;</div></div></div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="row-time">45&#039;</div>
    </div>
    <div class="second-half ingame">
      <div class="events">
        <div class="container">
          <div class="row-event event-left">
            <div class="column-player">
              <div class="valign-table"><div class="valign-cell">
                <div>Auswechslung</div>
                <div class="substitute">
                  <a href="https://www.fussball.de/spielerprofil/-/userid/PLAYER_H4">
                    <div class="player-name"><span data-obfuscation="testfont">x4c;x75;x6b;x61;x73;</span></div>
                  </a>
                  <div class="substitute">f&uuml;r
                    <a href="https://www.fussball.de/spielerprofil/-/player-id/PLAYER_H3"><span data-obfuscation="testfont">x4a;x6f;x6e;x61;x73;</span></a>
                  </div>
                </div>
              </div></div>
            </div>
            <div class="column-event">
              <div class="valign-table"><div class="valign-cell">
                <i class="icon-substitute"></i>
              </div></div>
            </div>
            <div class="column-time">
              <div class="hexagon black"><span class="icon-hexagon"></span>
                <div class="inner"><div class="valign-wrapper"><div class="valign-inner">60&rsquo;</div></div></div>
              </div>
            </div>
          </div>
          <div class="row-event event-right">
            <div class="column-time">
              <div class="hexagon black"><span class="icon-hexagon"></span>
                <div class="inner"><div class="valign-wrapper"><div class="valign-inner">75&rsquo;</div></div></div>
              </div>
            </div>
            <div class="column-event">
              <div class="valign-table"><div class="valign-cell">
                <i class="icon-card yellow-card"></i>
              </div></div>
            </div>
            <div class="column-player">
              <div class="valign-table"><div class="valign-cell">Gelbe Karte</div></div>
            </div>
          </div>
          <div class="row-event event-right">
            <div class="column-time">
              <div class="hexagon black"><span class="icon-hexagon"></span>
                <div class="inner"><div class="valign-wrapper"><div class="valign-inner">
                  70&rsquo;
                </div></div></div>
              </div>
            </div>
            <div class="column-event">
              <div class="valign-table"><div class="valign-cell">
                <i class="icon-substitute"></i>
              </div></div>
            </div>
            <div class="column-player">
              <div class="valign-table"><div class="valign-cell">
                <div>Auswechslung</div>
                <div class="substitute">
                  <a href="https://www.fussball.de/spielerprofil/-/player-id/PLAYER_A3">
                    <div class="player-name"><span data-obfuscation="testfont">x4e;x69;x6c;x73;</span></div>
                  </a>
                  <div class="substitute">f&uuml;r
                    <a href="https://www.fussball.de/spielerprofil/-/player-id/PLAYER_A2"><span data-obfuscation="testfont">x50;x61;x75;x6c;</span></a>
                  </div>
                </div>
              </div></div>
            </div>
          </div>
          <div class="row-event event-left">
            <div class="column-player">
              <div class="valign-table"><div class="valign-cell">Gelbe Karte</div></div>
            </div>
            <div class="column-event">
              <div class="valign-table"><div class="valign-cell">
                <i class="icon-card yellow-card"></i>
              </div></div>
            </div>
            <div class="column-time">
              <div class="hexagon black"><span class="icon-hexagon"></span>
                <div class="inner"><div class="valign-wrapper"><div class="valign-inner">
                  90
                  &rsquo;
                  <div>+2</div>
                </div></div></div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="row-time">90&#039;</div>
    </div>
    <div class="final">
      <div class="headline">
        <h3>Abpfiff</h3>
        <span>16:45Uhr</span>
      </div>
    </div>
  </div>
</div>
''';

void main() {
  late MatchDetail matchDetail;

  setUp(() {
    matchDetail = MatchDetail();
    matchDetail.scoreFont = ScoreFont();
    matchDetail.scoreFont.font = MockFont();
  });

  test('parses team info from lineup', () async {
    var result = await matchDetail.parseHTML(lineupHtml, courseHtml);

    expect(result.homeTeam, equals('Home FC'));
    expect(result.awayTeam, equals('Away United'));
    expect(result.homeLogo, equals('https://www.fussball.de/logo/home.png'));
    expect(result.awayLogo, equals('https://www.fussball.de/logo/away.png'));
  });

  test('parses starting lineup players', () async {
    var result = await matchDetail.parseHTML(lineupHtml, courseHtml);

    var starters =
        result.players.where((p) => p.role == 'starter').toList();
    expect(starters.length, equals(5));

    var homeStarters =
        starters.where((p) => p.team == 'home').toList();
    expect(homeStarters.length, equals(3));

    var awayStarters =
        starters.where((p) => p.team == 'away').toList();
    expect(awayStarters.length, equals(2));
  });

  test('parses player details', () async {
    var result = await matchDetail.parseHTML(lineupHtml, courseHtml);

    var goalkeeper = result.players
        .firstWhere((p) => p.playerId == 'PLAYER_H1');
    expect(goalkeeper.firstName, equals('Max'));
    expect(goalkeeper.lastName, equals('Richter'));
    expect(goalkeeper.shirtNumber, equals(1));
    expect(goalkeeper.isGoalkeeper, isTrue);
    expect(goalkeeper.isCaptain, isFalse);
    expect(goalkeeper.team, equals('home'));
    expect(goalkeeper.role, equals('starter'));
    expect(goalkeeper.image, equals('https://cdn.fussball.de/img/h1.jpg'));

    var captain = result.players
        .firstWhere((p) => p.playerId == 'PLAYER_H2');
    expect(captain.firstName, equals('Alex'));
    expect(captain.lastName, equals('Muller'));
    expect(captain.isCaptain, isTrue);
    expect(captain.isGoalkeeper, isFalse);
    expect(captain.shirtNumber, equals(10));
  });

  test('parses bench players', () async {
    var result = await matchDetail.parseHTML(lineupHtml, courseHtml);

    var homeBench = result.players
        .where((p) => p.team == 'home' && p.role != 'starter')
        .toList();
    expect(homeBench.length, equals(1));
    expect(homeBench[0].playerId, equals('PLAYER_H4'));
    expect(homeBench[0].firstName, equals('Lukas'));
    expect(homeBench[0].lastName, equals('Hahn'));
  });

  test('parses match events', () async {
    var result = await matchDetail.parseHTML(lineupHtml, courseHtml);

    expect(result.events.length, equals(5));

    // Goal at 23'
    var goal = result.events[0];
    expect(goal.type, equals('goal'));
    expect(goal.minute, equals(23));
    expect(goal.team, equals('home'));
    expect(goal.scorer, equals('PLAYER_H3'));
    expect(goal.scoreLeft, equals('1'));
    expect(goal.scoreRight, equals('0'));

    // Substitution at 60' (home)
    var sub1 = result.events[1];
    expect(sub1.type, equals('substitution'));
    expect(sub1.minute, equals(60));
    expect(sub1.team, equals('home'));
    expect(sub1.playerIn, equals('PLAYER_H4'));
    expect(sub1.playerOut, equals('PLAYER_H3'));

    // Yellow card at 75' (away)
    var card1 = result.events[2];
    expect(card1.type, equals('yellowCard'));
    expect(card1.minute, equals(75));
    expect(card1.team, equals('away'));

    // Substitution at 70' (away)
    var sub2 = result.events[3];
    expect(sub2.type, equals('substitution'));
    expect(sub2.minute, equals(70));
    expect(sub2.team, equals('away'));
    expect(sub2.playerIn, equals('PLAYER_A3'));
    expect(sub2.playerOut, equals('PLAYER_A2'));

    // Yellow card at 90'+2 (home)
    var card2 = result.events[4];
    expect(card2.type, equals('yellowCard'));
    expect(card2.minute, equals(90));
    expect(card2.stoppageTime, equals(2));
    expect(card2.team, equals('home'));
  });

  test('parses stoppage time', () async {
    var result = await matchDetail.parseHTML(lineupHtml, courseHtml);

    // Yellow card at 90'+2
    var stoppageEvent = result.events
        .firstWhere((e) => e.stoppageTime > 0);
    expect(stoppageEvent.minute, equals(90));
    expect(stoppageEvent.stoppageTime, equals(2));
  });

  test('calculates minutes played for starters', () async {
    var result = await matchDetail.parseHTML(lineupHtml, courseHtml);

    // H1 (goalkeeper) - played full match = 90, never subbed out
    var h1 = result.players.firstWhere((p) => p.playerId == 'PLAYER_H1');
    expect(h1.minuteIn, equals(0));
    expect(h1.minuteOut, equals(0));
    expect(h1.minutesPlayed, equals(90));

    // H3 (Jonas) - subbed out at 60', scored 1 goal
    var h3 = result.players.firstWhere((p) => p.playerId == 'PLAYER_H3');
    expect(h3.minuteIn, equals(0));
    expect(h3.minuteOut, equals(60));
    expect(h3.minutesPlayed, equals(60));
    expect(h3.goals, equals(1));
    expect(h3.role, equals('starter'));

    // A2 (Paul) - subbed out at 70', no goals
    var a2 = result.players.firstWhere((p) => p.playerId == 'PLAYER_A2');
    expect(a2.minuteIn, equals(0));
    expect(a2.minuteOut, equals(70));
    expect(a2.minutesPlayed, equals(70));
    expect(a2.goals, equals(0));
  });

  test('calculates minutes played for substitutes', () async {
    var result = await matchDetail.parseHTML(lineupHtml, courseHtml);

    // H4 (Lukas) - came on at 60', played until end: 91 - 60 = 31
    var h4 = result.players.firstWhere((p) => p.playerId == 'PLAYER_H4');
    expect(h4.role, equals('substitute'));
    expect(h4.minuteIn, equals(60));
    expect(h4.minuteOut, equals(0));
    expect(h4.minutesPlayed, equals(31));

    // A3 (Nils) - came on at 70', played until end: 91 - 70 = 21
    var a3 = result.players.firstWhere((p) => p.playerId == 'PLAYER_A3');
    expect(a3.role, equals('substitute'));
    expect(a3.minuteIn, equals(70));
    expect(a3.minuteOut, equals(0));
    expect(a3.minutesPlayed, equals(21));
  });

  test('parses end time', () async {
    var result = await matchDetail.parseHTML(lineupHtml, courseHtml);
    expect(result.endTime, equals('16:45Uhr'));
  });

  test('derives final score from last goal event', () async {
    var result = await matchDetail.parseHTML(lineupHtml, courseHtml);
    expect(result.homeScore, equals('1'));
    expect(result.awayScore, equals('0'));
  });

  group('MatchDetailTransfer', () {
    test('toJson', () {
      var result = MatchDetailTransfer();
      result.homeTeam = 'Home FC';
      result.awayTeam = 'Away United';

      var json = result.toJson();
      expect(json['homeTeam'], equals('Home FC'));
      expect(json['awayTeam'], equals('Away United'));
      expect(json['players'], isList);
      expect(json['events'], isList);
    });
  });

  group('MatchEventTransfer', () {
    test('toJson includes score for goals', () {
      var event = MatchEventTransfer()
        ..type = 'goal'
        ..team = 'home'
        ..minute = 23
        ..scorer = 'PLAYER1'
        ..scoreLeft = '1'
        ..scoreRight = '0';

      var json = event.toJson();
      expect(json['score'], equals('1:0'));
      expect(json['scorer'], equals('PLAYER1'));
    });

    test('toJson includes substitution players', () {
      var event = MatchEventTransfer()
        ..type = 'substitution'
        ..team = 'away'
        ..minute = 60
        ..playerIn = 'P_IN'
        ..playerOut = 'P_OUT';

      var json = event.toJson();
      expect(json['playerIn'], equals('P_IN'));
      expect(json['playerOut'], equals('P_OUT'));
    });

    test('toJson omits empty optional fields', () {
      var event = MatchEventTransfer()
        ..type = 'yellowCard'
        ..team = 'home'
        ..minute = 45;

      var json = event.toJson();
      expect(json.containsKey('scorer'), isFalse);
      expect(json.containsKey('score'), isFalse);
      expect(json.containsKey('playerIn'), isFalse);
      expect(json.containsKey('stoppageTime'), isFalse);
    });
  });
}
