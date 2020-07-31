class Teammember {
  String memberemail;
  bool access;
  Teammember({this.memberemail, this.access});

  toJson() {
    return {"memberemail": memberemail, "access": access};
  }

  Teammember.fromJson(Map<String, dynamic> json) {
    memberemail = json['memberemail'];
    access = json["access"];
  }
}
