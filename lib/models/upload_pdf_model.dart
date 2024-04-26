class UploadPdfModel {
  List<String>? commonNames;
  String? scientificName;
  String? file;
  String? image;
  Category? category;
  String? id;

  UploadPdfModel(
      {this.commonNames,
      this.scientificName,
      this.file,
      this.image,
      this.category,
      this.id});

  UploadPdfModel.fromJson(Map<String, dynamic> json) {
    commonNames = json['commonNames'].cast<String>();
    scientificName = json['scientificName'];
    file = json['file'];
    image = json['image'];
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['commonNames'] = commonNames;
    data['scientificName'] = scientificName;
    data['file'] = file;
    data['image'] = image;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    data['id'] = id;
    return data;
  }
}

class Category {
  String? id;

  Category({this.id});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}
