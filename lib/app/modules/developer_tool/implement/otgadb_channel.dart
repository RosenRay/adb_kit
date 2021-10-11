import 'package:adb_tool/app/modules/developer_tool/foundation/adb_channel.dart';
import 'package:adb_tool/utils/plugin_util.dart';

class OTGADBChannel extends ADBChannel {
  @override
  Future<String> execCmmand(String cmd) async {
    final String shell = cmd.replaceAll(RegExp('.*shell'), '');
    PluginUtil.writeToOTG(shell + '\n');
    return '';
  }
}
