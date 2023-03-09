// import 'package:adb_tool/app/modules/about/about_page.dart';
import 'package:adb_tool/app/modules/drawer/desktop_phone_drawer.dart';
import 'package:adb_tool/app/modules/drawer/tablet_drawer.dart';
import 'package:adb_tool/config/config.dart';
import 'package:adb_tool/core/interface/adb_page.dart';
import 'package:adb_tool/generated/l10n.dart';
import 'package:adb_tool/global/instance/global.dart';
import 'package:flutter/material.dart';
import 'package:global_repository/global_repository.dart';

class About extends ADBPage {
  @override
  Widget buildDrawer(BuildContext context) {
    return DrawerItem(
      value: runtimeType.toString(),
      groupValue: Global().drawerRoute,
      title: S.of(context).about,
      iconData: Icons.info_outline,
    );
  }

  @override
  Widget buildTabletDrawer(BuildContext context) {
    return TabletDrawerItem(
      value: runtimeType.toString(),
      groupValue: Global().drawerRoute,
      title: S.of(context).about,
      iconData: Icons.info_outline,
    );
  }

  @override
  bool get isActive => true;

  @override
  Widget buildPage(BuildContext context) {
    return AboutPage(
      versionCode: Config.versionCode.toString(),
      appVersion: Config.versionName,
      logo: Container(
        width: 100.w,
        height: 100.w,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(20.w),
        ),
        child: Icon(
          Icons.adb,
          color: Colors.white,
          size: 72.w,
        ),
      ),
      license: '''BSD 3-Clause License

Copyright (c) 2021,  Nightmare
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its
   contributors may be used to endorse or promote products derived from
   this software without specific prior written permission.''',
    );
  }

  @override
  void onTap() {}
}
