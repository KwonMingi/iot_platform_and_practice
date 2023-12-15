import 'package:flutter/material.dart';
import 'package:iot/mqttViewModel.dart';

class MQTTView extends StatefulWidget {
  final String nfcData; // String 타입으로 변경

  // 생성자에서 Map 대신 String을 받도록 수정
  const MQTTView(BuildContext context, {Key? key, required this.nfcData})
      : super(key: key);

  @override
  State<MQTTView> createState() => _MQTTViewState();
}

class _MQTTViewState extends State<MQTTView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late MQTTManager mqttManager;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    mqttManager = MQTTManager(widget.nfcData); // nfcData를 사용하여 초기화
    initAsync();
  }

  void initAsync() async {
    await mqttManager.connect();
  }

  @override
  void dispose() {
    mqttManager.disconnect();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          10,
          30,
          10,
          10,
        ),
        child: Container(
          padding: const EdgeInsets.all(0),
          margin: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFF9F7BFF),
              width: 3,
            ),
            borderRadius: BorderRadius.circular(15), // 둥근 모서리 처리
          ),
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 200,
                ),
                SizedBox(
                  height: 80,
                  width: 200,
                  child: TextButton(
                    onPressed: () {
                      mqttManager.publish('{"action" : "open"}');
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF9F7BFF),
                      backgroundColor: Colors.white, // 배경 색상
                      shape: RoundedRectangleBorder(
                        // 테두리 스타일 정의
                        side: const BorderSide(
                            color: Color(0xFF9F7BFF),
                            width: 3), // 테두리 색상 및 두께 설정
                        borderRadius: BorderRadius.circular(4), // 테두리 둥근 모서리 반경
                      ),
                    ),
                    child: const Text(
                      "문 열기",
                    ),
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                SizedBox(
                  height: 80,
                  width: 200,
                  child: TextButton(
                    onPressed: () {
                      mqttManager.publish('{"action" : "close"}');
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF9F7BFF),
                      backgroundColor: Colors.white, // 배경 색상
                      shape: RoundedRectangleBorder(
                        // 테두리 스타일 정의
                        side: const BorderSide(
                            color: Color(0xFF9F7BFF),
                            width: 3), // 테두리 색상 및 두께 설정
                        borderRadius: BorderRadius.circular(4), // 테두리 둥근 모서리 반경
                      ),
                    ),
                    child: const Text(
                      "문 닫기",
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
