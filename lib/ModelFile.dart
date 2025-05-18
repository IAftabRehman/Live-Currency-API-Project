class ModelFile {
  late final Map<String, dynamic> rates;
  ModelFile({required this.rates});


  factory ModelFile.fromJson(Map<String, dynamic> json) {
    return ModelFile(
      rates: json['rates'],
    );
  }
}