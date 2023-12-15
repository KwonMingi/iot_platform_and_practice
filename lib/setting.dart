import 'package:flutter/material.dart';

class NCubeSettingScreen extends StatefulWidget {
  const NCubeSettingScreen({super.key});

  @override
  _NCubeSettingScreenState createState() => _NCubeSettingScreenState();
}

class _NCubeSettingScreenState extends State<NCubeSettingScreen> {
  final TextEditingController _configController =
      TextEditingController(text: getDefaultConfig());

  static String getDefaultConfig() {
    return '''
      {
        "useprotocol": "http",
        "cse": {
          "cbhost": "203.253.128.161",
          "cbport": "7579",
          // Other configuration details...
        },
        // Rest of the default configuration...
      }
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('nCube Settings')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _configController,
              maxLines: null, // Allow multiple lines
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(labelText: 'Configuration'),
            ),
            ElevatedButton(
              onPressed: _submitSettings,
              child: const Text('Submit'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _configController.text = getDefaultConfig();
                });
              },
              child: const Text('Load Default'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitSettings() {
    String configData = _configController.text;
    // Handle the submission logic here
    // For example, navigate to another screen with the config data
  }

  @override
  void dispose() {
    _configController.dispose();
    super.dispose();
  }
}

void main() {
  runApp(const MaterialApp(home: NCubeSettingScreen()));
}
