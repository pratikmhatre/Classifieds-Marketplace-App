class StoreList {
  int id;
  String name;
  String foodTypes;
  String workingHours; //"08:00-14:00,16:00-20:00"
  bool isHomeDelivery = false;
  String? deliveryNote;
  String contactNumber;
  bool isPureVeg = false;
  bool isUpiAvailable = false;
  bool isCardAccepted = false;
  String? upiAddress;
  String? coordinates;
  String locality;
  String address;
  List<dynamic>? details;
  List<ImageModel>? images;
  List<Review>? reviews;
  List<Category>? categories;

  StoreList.fromJsonMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        foodTypes = map["foodTypes"],
        workingHours = map["workingHours"],
        isHomeDelivery = map["isHomeDelivery"],
        deliveryNote = map["deliveryNote"],
        contactNumber = map["contactNumber"],
        isPureVeg = map["isPureVeg"],
        isUpiAvailable = map["isPureVeg"],
        isCardAccepted = map["isCardAccepted"],
        upiAddress = map["upiAddress"],
        coordinates = map["coordinates"],
        locality = map["locality"],
        address = map["address"],
        images =
            List.from((map["images"] as List).map((e) => ImageModel.fromJson(e))),
        categories =
            List.from((map["seller_categories"] as List).map((e) => Category.fromJson(e))),
        details = map["details"];
}

class Category {
  String? name;

  Category.fromJson(Map<String, dynamic> map) : name = map['name'];
}

class ImageModel {
  String? image;

  ImageModel.fromJson(Map<String, dynamic> map) : image = map['image'];
}

class Review {
  String rating;
  String review;
  String dateCreated;
  String name;
  String? avatar;

  Review.fromJson(Map<String, dynamic> map)
      : rating = map['rating'],
        review = map['review'],
        dateCreated = map['dateCreated'],
        name = map['name'],
        avatar = map['avatar'];
}
