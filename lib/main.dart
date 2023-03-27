import 'dart:io';

import 'package:deepar/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );
  FlutterDownloader.registerCallback(DummyDownloaderCallBack.callback);
  runApp(const MainApp());
}

class DummyDownloaderCallBack {
  static void callback(String id, DownloadTaskStatus status, int progress) {}
}
