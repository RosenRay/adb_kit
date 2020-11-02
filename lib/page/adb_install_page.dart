import 'dart:io';

import 'package:adb_tool/config/config.dart';
import 'package:adb_tool/config/dimens.dart';
import 'package:adb_tool/global/widget/custom_card.dart';
import 'package:adb_tool/utils/platform_util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdbInstallPage extends StatefulWidget {
  @override
  _AdbInstallPageState createState() => _AdbInstallPageState();
}

class _AdbInstallPageState extends State<AdbInstallPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0.0,
        title: Text(
          '未找到Adb',
          style: TextStyle(
            height: 1.0,
            color: Theme.of(context).textTheme.bodyText2.color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          _CheckBusybox(),
        ],
      ),
    );
  }
}

class _CheckBusybox extends StatefulWidget {
  const _CheckBusybox({Key key, this.callback}) : super(key: key);
  final void Function() callback;
  @override
  __CheckBusyboxState createState() => __CheckBusyboxState();
}

class __CheckBusyboxState extends State<_CheckBusybox> {
  final Dio dio = Dio();
  Response<String> response;
  final String filesPath = PlatformUtil.getFilsePath(Config.packageName);
  List<String> adbFiles = [
    'http://nightmare.fun/File/MToolkit/android/adb/adb',
    'http://nightmare.fun/File/MToolkit/android/adb/adb.bin'
  ];
  double busyboxDownratio = 0.0;
  String downloadName = '';
  Future<void> downloadFile(String urlPath) async {
    response = await dio.head<String>(urlPath);
    final int fullByte = int.tryParse(
      response.headers.value('content-length'),
    ); //得到服务器文件返回的字节大小
    // final String _human = getFileSize(_fullByte); //拿到可读的文件大小返回给用户
    // print('_human======$_human');
    final String savePath =
        filesPath + Platform.pathSeparator + PlatformUtil.getFileName(urlPath);
    updateBusyboxProgress(fullByte, savePath);
    await dio.download(
      urlPath,
      savePath,
    );
    Process.runSync('chmod', <String>['0777', savePath]);
  }

  Future<void> updateBusyboxProgress(int fullByte, String filePath) async {
    while (mounted) {
      if (await File(filePath).exists()) {
        busyboxDownratio = await File(filePath).length() / fullByte;
        setState(() {});
      }
      await Future<void>.delayed(const Duration(milliseconds: 300));
    }
  }

  @override
  void initState() {
    super.initState();
    execDownload();
  }

  Future<void> execDownload() async {
    for (final String urlPath in adbFiles) {
      downloadName = PlatformUtil.getFileName(urlPath);
      setState(() {});
      print(urlPath);
      await downloadFile(urlPath);
    }
    widget.callback?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(
        Dimens.gap_dp8,
      ),
      child: NiCard(
        child: Padding(
          padding: EdgeInsets.all(
            12.w.toDouble(),
          ),
          child: Column(
            children: [
              Text(
                '下载 $downloadName 中',
                style: TextStyle(
                  fontSize: 18.w.toDouble(),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '进度',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: Dimens.gap_dp12,
              ),
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                child: LinearProgressIndicator(
                  value: busyboxDownratio,
                ),
              ),
              SizedBox(
                child: Text(
                  '下载到的目录为 $filesPath',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: Dimens.font_sp12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
