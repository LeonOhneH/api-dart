class PlayerPerformanceMatchTransfer {
  String date = '';
  String homeTeam = '';
  String homeTeamLogo = '';
  String awayTeam = '';
  String awayTeamLogo = '';
  String homeScore = '';
  String awayScore = '';
  String matchUrl = '';
  String goals = '';
  String subIn = '';
  String subOut = '';
  String minutes = '';

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'homeTeam': homeTeam,
      'homeTeamLogo': homeTeamLogo,
      'awayTeam': awayTeam,
      'awayTeamLogo': awayTeamLogo,
      'homeScore': homeScore,
      'awayScore': awayScore,
      'matchUrl': matchUrl,
      'goals': goals,
      'subIn': subIn,
      'subOut': subOut,
      'minutes': minutes,
    };
  }
}

class PlayerPerformanceFilterOption {
  String value = '';
  String label = '';
  bool selected = false;

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'label': label,
      'selected': selected,
    };
  }
}

class PlayerPerformanceResultTransfer {
  List<PlayerPerformanceFilterOption> seasons = [];
  List<PlayerPerformanceFilterOption> teams = [];
  List<PlayerPerformanceFilterOption> competitions = [];
  List<PlayerPerformanceMatchTransfer> matches = [];
  int totalAppearances = 0;
  int totalMinutes = 0;

  Map<String, dynamic> toJson() {
    return {
      'filters': {
        'seasons': seasons,
        'teams': teams,
        'competitions': competitions,
      },
      'matches': matches,
      'summary': {
        'totalAppearances': totalAppearances,
        'totalMinutes': totalMinutes,
      },
    };
  }
}
