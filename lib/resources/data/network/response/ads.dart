import 'package:digigad/resources/data/network/response/status.dart';
import 'package:digigad/resources/data/network/response/user_id.dart';
import 'category.dart';
import 'images.dart';

class Ads {
   int id;
   List<Images>? images;
   UserId userId;
   int likes;
   Category? category;
   Status? status;
   bool isLiked, isReported = false;
   String? title;
   String? locality;
   String? details;
   String? sellingPrice;
   int? condition;
   String? latitude;
   String? longitude;
   String? dateCreated;
   String? dateUpdated;
   int responseCount = 0;
   int? subCategory;

  Ads.fromJsonMap(Map<String, dynamic> map)
      : id = map["id"],
        title = map["title"],
        details = map["details"],
        images = List<Images>.from(
            map["images"].map((it) => Images.fromJsonMap(it))),
        userId = UserId.fromJsonMap(map["userId"]),
        isLiked = map["is_liked"],
        locality = map["locality"],
        isReported = map["is_reported"] == 'true',
        likes = map["likes"],
        sellingPrice = map["sellingPrice"],
        condition = map["condition"],
        latitude = map["latitude"],
        longitude = map["longitude"],
        dateCreated = map["dateCreated"],
        responseCount = map["response_count"],
        dateUpdated = map["dateUpdated"],
        category = Category.fromJsonMap(map["category"]),
        subCategory = map["subCategory"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = id;
    data['title'] = title;
    data['details'] = details;
    data['locality'] = locality;
    data['images'] =
        images != null ? this.images!.map((v) => v.toJson()).toList() : null;
    data['userId'] = userId == null ? null : userId.toJson();
    data['likes'] = likes;
    data['is_liked'] = isLiked;
    data['is_reported'] = isReported ? 'true' : 'false';
    data['sellingPrice'] = sellingPrice;
    data['condition'] = condition;
    data['response_count'] = responseCount;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['dateCreated'] = dateCreated;
    data['dateUpdated'] = dateUpdated;
    data['category'] = category == null ? null : category?.toJson();
    data['subCategory'] = subCategory;
    return data;
  }
}

class Approval {
  int adIdToApprove;
  bool approvalStatus;
  int disApprovedReason;
  String? dateCreated;
  String? dateUpdated;

  Approval.fromJsonMap(Map<String, dynamic> map)
      : adIdToApprove = map["adIdToApprove"],
        approvalStatus = map["approvalStatus"],
        disApprovedReason = map["disApprovedReason"],
        dateCreated = map["dateCreated"],
        dateUpdated = map["dateUpdated"];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['adIdToApprove'] = adIdToApprove;
    data['approvalStatus'] = approvalStatus;
    data['disApprovedReason'] = disApprovedReason;
    data['dateCreated'] = dateCreated;
    data['dateUpdated'] = dateUpdated;
    return data;
  }
}
