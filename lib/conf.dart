class MQTTConfig {
  static final Map<String, dynamic> config = {
    "useprotocol": "mqtt",
    "cse": {
      "cbhost": "192.168.84.62",
      "cbport": "7579",
      "cbname": "Mobius",
      "cbcseid": "/Mobius2",
      "mqttport": "1883"
    },
    "ae": {
      "aeid": "S",
      "appid": "0.2.481.1.1",
      "appname": "ae-test1",
      "appport": "9727",
      "bodytype": "xml",
      "tasport": "3105"
    },
    "cnt": [
      {"parentpath": "/ae-test1", "ctname": "cnt-co2"},
      {"parentpath": "/ae-test1", "ctname": "cnt-led"}
    ],
    "sub": [
      {
        "parentpath": "/ae-test1/cnt-led",
        "subname": "sub-ctrl",
        "nu": "mqtt://AUTOSET"
      }
    ],
  };

  static String getCbhost() {
    return config['cse']['cbhost'];
  }

  static String getCbport() {
    return config['cse']['cbport'];
  }

  static String getMqttport() {
    return config['cse']['mqttport'];
  }

  static String getAppname() {
    return config['ae']['appname'];
  }
}
