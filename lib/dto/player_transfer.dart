class PlayerTransfer {
  String name = '';
  String image = '';
  String profileUrl = '';
  int appearances = 0;
  int minutes = 0;
  int goals = 0;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'profileUrl': profileUrl,
      'appearances': appearances,
      'minutes': minutes,
      'goals': goals,
    };
  }
}
