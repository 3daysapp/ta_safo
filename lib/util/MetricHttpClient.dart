import 'package:firebase_performance/firebase_performance.dart';
import 'package:http/http.dart';

///
///
///
class MetricHttpClient extends BaseClient {
  final Client _inner;

  MetricHttpClient(this._inner);

  ///
  ///
  ///
  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    final HttpMetric metric = FirebasePerformance.instance
        .newHttpMetric(request.url.toString(), HttpMethod.Get);

    await metric.start();

    StreamedResponse response;
    try {
      response = await _inner.send(request);
      metric
        ..responsePayloadSize = response.contentLength ?? 0
        ..responseContentType = response.headers['Content-Type']
        ..requestPayloadSize = request.contentLength ?? 0
        ..httpResponseCode = response.statusCode ?? 0;
    } finally {
      await metric.stop();
    }

    return response;
  }
}
