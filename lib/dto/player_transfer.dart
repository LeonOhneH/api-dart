class PlayerTransfer {
  String firstName = '';
  String lastName = '';
  String image = '';
  String profileUrl = '';
  int appearances = 0;
  int minutes = 0;
  int goals = 0;

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'image': image,
      'profileUrl': profileUrl,
      'appearances': appearances,
      'minutes': minutes,
      'goals': goals,
    };
  }
}
