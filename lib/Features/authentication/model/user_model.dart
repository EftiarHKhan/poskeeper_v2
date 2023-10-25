import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  final String? id;
  final String? fullname;
  final String? email;
  final String? phoneNo;
  final String? password;
  final String? storeName;

  const UserModel({
    this.id,
   required this.fullname,
   required this.email,
   required this.phoneNo,
   required this.password,
   required this.storeName,
});


  toJson(){
    return{
      "Email": email,
      "Name": fullname,
      "Password": password,
      "Phone_Number": phoneNo,
      "Store_Name": storeName
    };
  }
}

class UserModel2 {
  final String? id;
   String? image;
  final String? fullname;
  final String? email;
  final String? phoneNo;
  final String? password;
  final String? storeName;

   UserModel2({
    this.id,
    this.image,
    required this.fullname,
    required this.email,
    required this.phoneNo,
    required this.password,
    required this.storeName,
  });
  set setImage(String? newImage) {
    image = newImage;
  }

  toJson2(){
    return{
      "Email": email,
      "Name": fullname,
      "Password": password,
      "Phone_Number": phoneNo,
      "Store_Name": storeName,
      "Picture": image
    };
  }
  factory UserModel2.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data()!;
    return UserModel2(
      id: document.id,
      fullname: data["Name"],
      email: data["Email"],
      phoneNo: data["Phone_Number"],
      password: data["Password"],
      storeName: data["Store_Name"],
      image: data["Picture"],
    );
  }
}