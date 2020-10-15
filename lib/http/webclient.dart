import 'package:bytebank_persist/http/interceptors/logging_interceptor.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

final String baseURL = 'http://192.168.0.26:8080/transactions';

final Client client = HttpClientWithInterceptor.build(
    interceptors: [LoggingInterceptor()], requestTimeout: Duration(seconds: 5));
