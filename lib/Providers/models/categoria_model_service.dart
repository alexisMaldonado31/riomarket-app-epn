class CategoriaModelService {
    String idCategory;
    String name;
    String urlMiniBanner;
    String urlBanner;
    String urlIcon;

    CategoriaModelService({
        this.idCategory,
        this.name,
        this.urlMiniBanner,
        this.urlBanner,
        this.urlIcon
    });

    factory CategoriaModelService.fromJson(Map<String, dynamic> json) {
      return CategoriaModelService(
        idCategory: json["id_category"],
        name: json["name"],
        urlMiniBanner:  json["url_mini_banner"].toString() == 'false' ? '' : json["url_mini_banner"],
        urlBanner: json["url_banner"].toString() == 'false' ? '' : json["url_banner"],
        urlIcon:  json["url_icon"].toString() == 'false' ? '' : json["url_icon"],
      );
    }
    Map<String, dynamic> toJson() => {
        "id_category": idCategory,
        "name": name,
        "url_mini_banner": urlMiniBanner,
        "url_banner": urlBanner,
        "url_icon": urlIcon
    };

}