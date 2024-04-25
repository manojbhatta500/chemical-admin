class SignInModel {
  bool? success;
  String? id;
  String? accessToken;

  SignInModel({this.success, this.id, this.accessToken});

  SignInModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    id = json['id'];
    accessToken = json['access_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['id'] = this.id;
    data['access_token'] = this.accessToken;
    return data;
  }
}
