class UserModel {
  late String id;
  late String fullname;
  late String email;

  //Default constructor
  UserModel({required this.id, required this.fullname, required this.email});

  //In flutter we can make named constructor
  //not complete Deserialization. map to object
  UserModel.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.fullname = map['fullname'];
    this.email = map["email"];
  }

  //object to map
  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "fullname": this.fullname, 
      "email": this.email
    };
    
  }
}
