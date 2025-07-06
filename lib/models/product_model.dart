class ProductModel {
  final int id;
  final String name;
  final String barcode;
  final String description;
  final String brand;
  final int? brand_id;  // Can be null
  final int category_id;
  final int sub_categories;
  final String keywords;
  final int regular_price;
  final int sale_price;
  final String country;
  final String currency;
  final String units;
  final int quantity;  // Changed to int
  final String default_image;
  final String? image1;
  final String? image2;
  final String? image3;
  final String? image4;
  final int isFeatured;  // Changed to int
  final String created_at;
  final String updated_at;
  final String default_image_url;
  final List<String> images_urls;  // List of image URLs
  final String? brand_details;

  ProductModel({
    required this.id,
    required this.name,
    required this.barcode,
    required this.description,
    required this.brand,
    this.brand_id,
    required this.category_id,
    required this.sub_categories,
    required this.keywords,
    required this.regular_price,
    required this.sale_price,
    required this.country,
    required this.currency,
    required this.units,
    required this.quantity,
    required this.default_image,
    this.image1,
    this.image2,
    this.image3,
    this.image4,
    required this.isFeatured,
    required this.created_at,
    required this.updated_at,
    required this.default_image_url,
    required this.images_urls,
    this.brand_details,
  });

  // Convert JSON to Product object
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    String parseString(dynamic value) {
      if (value is Map) return value.toString();
      return value?.toString() ?? "";
    }

    List<String> parseImageUrls(dynamic imagesUrls) {
      if (imagesUrls is List) {
        return imagesUrls.map((url) => url.toString()).toList();
      } else if (imagesUrls is String) {
        return [imagesUrls];
      } else {
        return [];
      }
    }

    return ProductModel(
      id: json["id"] ?? 0,
      name: parseString(json["name"]),
      barcode: parseString(json["barcode"]),
      description: parseString(json["description"]),
      brand: parseString(json["brand"]),
      brand_id: json["brand_id"],
      category_id: int.tryParse(json["category_id"]?.toString() ?? '') ?? 0,
      sub_categories: int.tryParse(json["sub_categories"]?.toString() ?? '') ?? 0,
      keywords: parseString(json["keywords"]),
      regular_price: int.tryParse(json["regular_price"]?.toString() ?? '') ?? 0,
      sale_price: int.tryParse(json["sale_price"]?.toString() ?? '') ?? 0,
      country: parseString(json["country"]),
      currency: parseString(json["currency"]),
      units: parseString(json["units"]),
      quantity: int.tryParse(json["quantity"]?.toString() ?? '') ?? 0,
      default_image: parseString(json["default_image"]),
      image1: json.containsKey("image1") ? parseString(json["image1"]) : null,
      image2: json.containsKey("image2") ? parseString(json["image2"]) : null,
      image3: json.containsKey("image3") ? parseString(json["image3"]) : null,
      image4: json.containsKey("image4") ? parseString(json["image4"]) : null,
      isFeatured: int.tryParse(json["isFeatured"]?.toString() ?? '') ?? 0,
      created_at: parseString(json["created_at"]),
      updated_at: parseString(json["updated_at"]),
      default_image_url: parseString(json["default_image_url"]),
      images_urls: parseImageUrls(json["images_urls"]),
      brand_details: json.containsKey("brand_details") ? parseString(json["brand_details"]) : null,
    );
  }
}
