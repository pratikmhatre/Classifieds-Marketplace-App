import 'package:dio/dio.dart';
import 'dart:convert';

class DioTransformer extends DefaultTransformer {

  @override
  Future transformResponse(RequestOptions options, ResponseBody response) {
   /* if (options.data is Map) {
      options.data = jsonDecode(jsonEncode(options.data));
    }*/
    return super.transformResponse(options, response);
  }



}
