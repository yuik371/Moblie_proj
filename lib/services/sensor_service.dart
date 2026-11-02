import 'package:sensors_plus/sensors_plus.dart';

// 기기 가속도 센서 스트림을 제공하는 하드웨어 연동 서비스입니다.
class SensorService {
  // AR 화면이 사용할 적절한 주기의 가속도 이벤트 스트림을 반환합니다.
  Stream<AccelerometerEvent> get accelerometerStream => accelerometerEventStream(samplingPeriod: SensorInterval.normalInterval);
}
