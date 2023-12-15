import 'package:iot/conf.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:typed_data/src/typed_buffer.dart';

class MQTTManager {
  late final String cbhost;
  final String nfcData;
  late final String mqttport;
  late final String appname;
  String _topic = "/door/control";
  late final MqttServerClient _client;

  String get topic => _topic;

  set setTopic(String topic) => _topic = topic;

  MQTTManager(this.nfcData) {
    // MQTTConfig에서 설정을 가져옴
    cbhost = nfcData;
    mqttport = "1883";
    appname = "Mobius";

    // MqttServerClient 인스턴스 생성
    _client = MqttServerClient(cbhost, appname);

    // 초기화
    initializeMQTTClient();
    _client.onConnected = onConnected; // 연결 성공 시 콜백 추가
    _client.updates?.listen(onMessageReceived); // 메시지 수신 처리 추가
  }
// 연결 성공 콜백
  void onConnected() {
    print('MQTT 클라이언트가 연결되었습니다.');
  }

  // 메시지 수신 콜백
  void onMessageReceived(List<MqttReceivedMessage<MqttMessage>> messages) {
    for (var message in messages) {
      final payload = MqttPublishPayload.bytesToStringAsString(
          message.payload as Uint8Buffer);
      print('Received message: $payload from topic: ${message.topic}');
    }
  }

  void initializeMQTTClient() {
    _client.port = int.parse(mqttport); // MQTT 포트 설정
    _client.keepAlivePeriod = 60;
    _client.onDisconnected = onDisconnected;
    // 추가 초기화 설정
    // 예: 사용자 이름, 비밀번호, 클라이언트 ID 설정
  }

  Future<void> connect() async {
    try {
      await _client.connect();
    } catch (e) {
      print('MQTT 클라이언트 연결 실패: $e');
      _client.disconnect();
      return;
    }

    if (_client.connectionStatus?.state == MqttConnectionState.connected) {
      print('MQTT 클라이언트가 성공적으로 연결되었습니다.');
      subscribe(); // 연결 후 자동으로 구독
    } else {
      print('MQTT 클라이언트 연결 실패: ${_client.connectionStatus}');
      _client.disconnect();
    }
  }

  void onDisconnected() {
    print('MQTT 클라이언트가 연결 해제되었습니다.');
  }

  void publish(String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);

    _client.publishMessage(_topic, MqttQos.exactlyOnce, builder.payload!);
  }

  void subscribe() {
    _client.subscribe(_topic, MqttQos.atLeastOnce);
  }

  void unsubscribe() {
    _client.unsubscribe(_topic);
  }

  void disconnect() {
    _client.disconnect();
  }
}
