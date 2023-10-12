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