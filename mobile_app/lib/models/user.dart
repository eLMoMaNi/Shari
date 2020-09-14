class User {
  final String username;
  final String fname;
  final String lname;
  final String number;
  final String profilePicture;

  ///create a user from JSON
  ///
  ///The json MUST be decoded.
  User.fromJSON(Map<String, dynamic> json)
      : username = json["username"] ?? "unknown",
        fname = json["firstname"] ?? "unknown",
        lname = json["lastname"] ?? "unknown",
        number = json["number"]?.toString() ?? "unknown",
        profilePicture = json["pic"] ?? "https://via.placeholder.com/150";

  ///return User details as a map
  ///
  ///you must send userId and currentUser token
  static Future<Map<String, String>> getUserbyId(
      String userId, String token) async {
    //TODO implement get user API
  }
}
