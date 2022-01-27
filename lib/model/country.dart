class CountryModel {
  final String id;
  final String name;
  final String flag;

  CountryModel(this.id, this.name, this.flag);

  CountryModel.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        name = json['name'],
        flag = json['flag'];
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'flag': flag,
    };
  }
}
