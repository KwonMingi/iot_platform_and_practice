import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iot/ipConf.dart';
import 'package:iot/mqttView.dart';
import 'package:iot/mqttViewModel.dart';
import 'package:nfc_manager/nfc_manager.dart';

void myTask() {
  print('my task is running');
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: ThemeData.light().canvasColor, // 상태 표시 줄의 배경색 변경
      statusBarIconBrightness: Brightness.dark, // 상태 표시 줄 아이콘을 어둡게 설정
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Smooth Navigation with PageView',
      theme: ThemeData(primaryColor: Colors.green[700]),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _readNFC(); // NFC 읽기 시작
  }

  bool isReadingNfc = false; // NFC를 읽고 있는지 여부를 저장하는 변수 추가

  void _readNFC() async {
    if (isReadingNfc) return; // 이미 NFC를 읽고 있으면 return
    isReadingNfc = true; // NFC 읽기 시작 상태로 설정

    bool isAvailable = await NfcManager.instance.isAvailable();

    if (!isAvailable) {
      isReadingNfc = false; // NFC 읽기 종료 상태로 설정
      return;
    }

    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        Map tagData = tag.data;
        Map tagNdef = tagData['ndef'];
        Map cachedMessage = tagNdef['cachedMessage'];
        Map records = cachedMessage['records'][0];
        Uint8List payload = records['payload'];
        String payloadAsString = String.fromCharCodes(payload).substring(3);

        // payloadAsString의 유효성 검사
        if (IPConf.ips.contains(payloadAsString) &&
            payloadAsString.isNotEmpty) {
          if (IPConf.ips.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    MQTTView(context, nfcData: payloadAsString),
              ),
            );
          }
        } else {
          // 유효하지 않은 경우 경고 창 띄우기
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  '경고',
                  style: TextStyle(
                    color: Color(0xFF9F7BFF), // 원하는 글자 색을 지정합니다.
                  ),
                ),
                content: const Text(
                  '출입 권한이 없습니다.',
                  style: TextStyle(
                    color: Color(0xFF9F7BFF), // 원하는 글자 색을 지정합니다.
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text(
                      '확인',
                      style: TextStyle(
                        color: Color(0xFF9F7BFF), // 원하는 글자 색을 지정합니다.
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      },
    );
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
          child: const Center(
            child: Text(
              'NFC에 휴대폰을 가져다 대세요',
              style: TextStyle(
                  fontSize: 24, // 원하는 폰트 크기로 조정
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF9F7BFF) // 원하는 폰트 두께로 조정
                  ),
            ),
          ),
        ),
      ),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final Color color;

  const PlaceholderWidget(this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: Text(
          'Page with ${color.toString()}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
