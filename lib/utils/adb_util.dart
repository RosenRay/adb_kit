import 'dart:io';

import 'package:adb_tool/app/modules/home/controllers/devices_controller.dart';
import 'package:adb_tool/app/modules/list/devices_list.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';

class AdbUtil {
  static Future<void> connectDevices(String ip, [String port]) async {
    port ??= '5555';
    final String ipAndPort = '$ip:$port';
    final DevicesController controller = Get.find<DevicesController>();
    final DevicesEntity devicesEntity = controller.getDevicesByIp(ip);
    if (devicesEntity != null && !devicesEntity.connect()) {
      // 注释先别删，投屏 app 可能需要
      await Process.run(
        'adb',
        [
          'disconnect',
          ip + ':5555',
        ],
        runInShell: true,
        includeParentEnvironment: true,
        environment: PlatformUtil.environment(),
      );
      // TODO 这儿有问题，有的设备远程调试的端口可能不是5555
      // Global.instance.pseudoTerminal.write('adb disconnect $ip:5555\n');
    }
    // Todo
    final ProcessResult result = await Process.run(
      'adb',
      [
        'connect',
        ipAndPort,
      ],
      runInShell: true,
      includeParentEnvironment: true,
      environment: PlatformUtil.environment(),
    );
    final String stdout = result.stdout.toString();
    if (stdout.contains('refused')) {
      showToast('$ip 下的 $port 端口无法连接');
    } else if (stdout.contains('unable to connect')) {
      showToast('连接失败，对方设备可能未打开网络ADB调试');
    } else if (stdout.contains('already connected')) {
      showToast('该设备已连接');
    } else if (stdout.contains('connect')) {
      showToast('连接成功');
    }
    print('result.stdout -> ${result.stdout}');
    print('result.stderr -> ${result.stderr}');
  }

  static Future<void> disconnectDevices(String ip) async {
    final ProcessResult result = await Process.run(
      'adb',
      [
        'disconnect',
        ip + ':5555',
      ],
      runInShell: true,
      includeParentEnvironment: true,
      environment: PlatformUtil.environment(),
    );

    print('result.stdout -> ${result.stdout}');
    print('result.stderr -> ${result.stderr}');
  }
}
