import 'package:postgres/postgres.dart';


class User {
  bool status; //student or teacher (boolean student = true)
  String name;
  String osis;
  String email;
  String homeroom;
  bool detention;
  String password;
  User(
      this.status,
      this.name,
      this.osis,
      this.email,
      this.homeroom,
      this.detention,
      this.password,
      );
  void editName(String n, var connection) async {
    name = n;
    await connection.open();
    await connection.query(
        "UPDATE users SET name  = @newname WHERE email = @currentemail",
        substitutionValues: {"newname": name, "currentemail": email});
  }


  void editOSIS(String n, var connection) async {
    osis = n;
    await connection.open();
    await connection.query(
        "UPDATE users SET osis  = @newosis WHERE email = @currentemail",
        substitutionValues: {"newosis": n, "currentemail": email});
  }


  void editHomeroom(String n, var connection) async {
    homeroom = n;
    await connection.open();
    await connection.query(
        "UPDATE users SET homeroom  = @newhr WHERE email = @currentemail",
        substitutionValues: {"newhr": n, "currentemail": email});
  }
}

