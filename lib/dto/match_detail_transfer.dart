class MatchPlayerTransfer {
  String firstName = '';
  String lastName = '';
  String image = '';
  String profileUrl = '';
  String playerId = '';
  int shirtNumber = 0;
  String team = ''; // 'home' or 'away'
  String role = ''; // 'starter', 'substitute', 'bench'
  bool isCaptain = false;
  bool isGoalkeeper = false;
  int minuteIn = 0;
  int minuteOut = 0;
  int minutesPlayed = 0;
  int goals = 0;

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'image': image,
      'profileUrl': profileUrl,
      'playerId': playerId,
      'shirtNumber': shirtNumber,
      'team': team,
      'role': role,
      'isCaptain': isCaptain,
      'isGoalkeeper': isGoalkeeper,
      'minuteIn': minuteIn,
      'minuteOut': minuteOut,
      'minutesPlayed': minutesPlayed,
      'goals': goals,
    };
  }
}

class MatchEventTransfer {
  String type = ''; // 'goal', 'substitution', 'yellowCard', 'yellowRedCard', 'redCard'
  String team = ''; // 'home' or 'away'
  int minute = 0;
  int stoppageTime = 0;
  String playerIn = '';
  String playerOut = '';
  String scorer = '';
  String scoreLeft = '';
  String scoreRight = '';

  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{
      'type': type,
      'team': team,
      'minute': minute,
    };
    if (stoppageTime > 0) json['stoppageTime'] = stoppageTime;
    if (scorer.isNotEmpty) json['scorer'] = scorer;
    if (scoreLeft.isNotEmpty) json['score'] = '$scoreLeft:$scoreRight';
    if (playerIn.isNotEmpty) json['playerIn'] = playerIn;
    if (playerOut.isNotEmpty) json['playerOut'] = playerOut;
    return json;
  }
}

class MatchDetailTransfer {
  String homeTeam = '';
  String awayTeam = '';
  String homeLogo = '';
  String awayLogo = '';
  String homeScore = '';
  String awayScore = '';
  String endTime = '';
  List<MatchPlayerTransfer> players = [];
  List<MatchEventTransfer> events = [];

  Map<String, dynamic> toJson() {
    return {
      'homeTeam': homeTeam,
      'awayTeam': awayTeam,
      'homeLogo': homeLogo,
      'awayLogo': awayLogo,
      'homeScore': homeScore,
      'awayScore': awayScore,
      'endTime': endTime,
      'players': players.map((p) => p.toJson()).toList(),
      'events': events.map((e) => e.toJson()).toList(),
    };
  }
}
