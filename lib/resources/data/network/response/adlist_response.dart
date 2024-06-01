import 'ads.dart';

class AdlistResponse {

  int status;
  List<Ads> data;

	AdlistResponse.fromJsonMap(Map<String, dynamic> map): 
		status = map["status"],
				data = List<Ads>.from(map["data"].map((it) => Ads.fromJsonMap(it)));



	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['status'] = status;
		data['data'] = data != null ?
			this.data.map((v) => v.toJson()).toList()
			: null;
		return data;
	}
}
