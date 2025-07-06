class MerchantListModel {
  final int id;
  final String? companyName;
  final String? name;
  final String? address;
  final String? latitude;
  final String? longitude;
  final String? phoneCode;
  final String? mobile;

  MerchantListModel({
    required this.id,
    this.companyName,
    this.name,
    this.address,
    this.latitude,
    this.longitude,
    this.phoneCode,
    this.mobile,
  });

  // Convert JSON to Merchant object
  factory MerchantListModel.fromJson(Map<String, dynamic> json) {
    return MerchantListModel(
      id: json["id"],
      companyName: json["company_name"],
      name: json["name"],
      address: json["address"],
      latitude: json["latitude"]?.toString(),
      longitude: json["longitude"]?.toString(),
      phoneCode: json["phonecode"],
      mobile: json["mobile"]
    );
  }
}
