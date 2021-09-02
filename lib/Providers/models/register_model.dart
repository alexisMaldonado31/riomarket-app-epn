
class RegisterModel {
  String firstname;
  String lastname;
  String email;
  String password;
  String idGender;

  RegisterModel({
    this.firstname,
    this.lastname,
    this.email,
    this.password,
    this.idGender,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
    firstname: json["firstname"],
    lastname: json["lastname"],
    email: json["email"],
    password: json["password"],
    idGender: json["id_gender"],
  );

  Map<String, dynamic> toJson() => {
    "firstname": firstname,
    "lastname": lastname,
    "email": email,
    "password": password,
    "id_gender": idGender,
  };
}
