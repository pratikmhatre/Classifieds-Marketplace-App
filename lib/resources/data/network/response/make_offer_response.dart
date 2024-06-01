
class MakeOfferResponse {

  int id;
  String offer;
  Object message;
  String dateCreated;
  int ad;
  int fromUser;

	MakeOfferResponse.fromJsonMap(Map<String, dynamic> map): 
		id = map["id"],
		offer = map["offer"],
		message = map["message"],
		dateCreated = map["dateCreated"],
		ad = map["ad"],
		fromUser = map["fromUser"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = id;
		data['offer'] = offer;
		data['message'] = message;
		data['dateCreated'] = dateCreated;
		data['ad'] = ad;
		data['fromUser'] = fromUser;
		return data;
	}
}
