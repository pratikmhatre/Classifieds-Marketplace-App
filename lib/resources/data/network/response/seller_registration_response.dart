class SellerRegistrationResponse {
  int id;

  SellerRegistrationResponse.fromJson(Map<String, dynamic> map)
      : id = map['id'];
}
