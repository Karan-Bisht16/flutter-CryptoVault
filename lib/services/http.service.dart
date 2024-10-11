import 'package:dio/dio.dart';
import 'package:cryptovault/constants/constants.dart';

class HTTPService {
  final Dio dio = Dio();
  HTTPService() {
    configureDio();
  }

  void configureDio() {
    dio.options = BaseOptions(
      baseUrl: "https://api.cryptorank.io/v1/",
      queryParameters: {
        "api_key": cryptorankAPIKey,
      },
    );
  }

  Future<dynamic> get(String path) async {
    try {
      Response res = await dio.get(path);
      return res.data;
    } catch (error) {
      // print(error);
    }
  }
}
