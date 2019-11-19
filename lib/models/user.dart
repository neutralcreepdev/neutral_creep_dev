enum UserType { Customer, Staff }

class User {
  String name, id, contactNum;
  Map dob;
  Map address;
  UserType type;

  User(this.id, this.name, this.dob, this.contactNum, this.address);

  @override
  String toString() {
    return "id=$id, name=$name, dob=$dob, contactNum=$contactNum, address=$address";
  }
}
