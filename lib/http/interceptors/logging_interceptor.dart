import 'package:http_interceptor/http_interceptor.dart';

class LoggingInterceptor extends InterceptorContract {
  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    print('====Request====');
    print('url: ${data.baseUrl}');
    print('headers: ${data.headers}');
    print('body: ${data.body}');

    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    print('====Response====');
    print('url: ${data.url}');
    print('status code: ${data.statusCode}');
    print('headers: ${data.headers}');
    print('body: ${data.body}');

    return data;
  }
}
