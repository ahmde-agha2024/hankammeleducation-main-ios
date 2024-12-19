class RegisterUser {
  String? firstName;
  String? lastName;
  String? gender;
  String? phoneNumber;

  RegisterUser({this.firstName, this.lastName, this.gender, this.phoneNumber});

  RegisterUser.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    gender = json['gender'];
    phoneNumber = json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['gender'] = this.gender;
    data['phone_number'] = this.phoneNumber;
    return data;
  }
}
