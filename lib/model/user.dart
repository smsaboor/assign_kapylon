class User {
  int? userId;
  final String imagePath;
  final String name;
  final String address;
  final String dob;

   User({
   this.userId,
    required this.imagePath,
    required this.name,
    required this.address,
    required this.dob,
  });

  Map<String, dynamic> toJson() {
    //below line is instantiation for empty map object
    var map = <String, dynamic>{};
    map['userId'] = userId;
    map['name'] = name;
    map['address'] = address;
    map['dob'] = dob;
    map['imagePath'] = imagePath;
    return map;
  }

  static User fromJson(Map<String, dynamic> json) => User(
        userId: json['name'],
        name: json['name'],
        address: json['name'],
        dob: json['name'],
        imagePath: json['name'],
      );
}
