import 'dart:async';
import 'dart:io';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class FileDownloaderService {
  static Future<File?> downloadedFile(
      {required String url,
      String? preferredExtension,
      Function(double progress)? progressCallback}) async {
    Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    final extension = preferredExtension ?? p.extension(url); // '.dart.js'
    String fileName = '${DateTime.now().microsecondsSinceEpoch}-file$extension';
    final String? fileId = await FlutterDownloader.enqueue(
      url: url,
      savedDir: directory!.path,
      fileName: fileName,
      allowCellular: true,
      openFileFromNotification:
          false, // click on notification to open downloaded file (for Android)
      showNotification: false,
    );
    final fileCompleter = Completer<bool?>();
    Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      List<DownloadTask> tasks = await FlutterDownloader.loadTasksWithRawQuery(
              query: 'SELECT * FROM task WHERE task_id="$fileId"') ??
          [];
      DownloadTaskStatus downloadTaskStatus = tasks.first.status;
      if (progressCallback != null) {
        progressCallback(tasks.first.progress.toDouble());
      }
      if (downloadTaskStatus == DownloadTaskStatus.complete) {
        fileCompleter.complete(true);
        timer.cancel();
      } else if (downloadTaskStatus == DownloadTaskStatus.failed) {
        fileCompleter.complete(false);
        timer.cancel();
      }
    });
    bool? downloadStatus = await fileCompleter.future;
    if (downloadStatus!) {
      final filePath = '${directory.path}/$fileName';
      // print(filePath);
      // OpenFile.open(filePath);
      return File(filePath);
    }
    return null;
  }
}
