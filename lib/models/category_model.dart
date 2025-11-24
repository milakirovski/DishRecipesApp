class Category {
  String idCategory;
  String strCategory;
  String strCategoryThumb;
  String strCategoryDescription;

  Category({
    required this.idCategory,
    required this.strCategory,
    required this.strCategoryThumb,
    required this.strCategoryDescription
  });

  Category.fromJson(Map<String, dynamic> data)
      : idCategory = data['idCategory'],
        strCategory = data['strCategory'],
        strCategoryThumb = data['strCategoryThumb'],
        strCategoryDescription = data['strCategoryDescription'];

  Map<String, dynamic> toJson() => {
        'idCategory': idCategory,
        'strCategory': strCategory,
        'strCategoryThumb': strCategoryThumb,
        'strCategoryDescription': strCategoryDescription
      };


}