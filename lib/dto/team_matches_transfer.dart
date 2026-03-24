class TeamMatchTransfer {
  String date = '';
  String time = '';
  String competition = '';
  String homeTeam = '';
  String homeTeamLogo = '';
  String awayTeam = '';
  String awayTeamLogo = '';
  String homeScore = '';
  String awayScore = '';
  String matchUrl = '';
  String status = '';

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'time': time,
      'competition': competition,
      'homeTeam': homeTeam,
      'homeTeamLogo': homeTeamLogo,
      'awayTeam': awayTeam,
      'awayTeamLogo': awayTeamLogo,
      'homeScore': homeScore,
      'awayScore': awayScore,
      'matchUrl': matchUrl,
      'status': status,
    };
  }
}
