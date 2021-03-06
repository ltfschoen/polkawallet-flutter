import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:polka_wallet/common/components/JumpToBrowserLink.dart';
import 'package:polka_wallet/utils/i18n/index.dart';

class AboutPage extends StatelessWidget {
  static final String route = '/profile/about';

  @override
  Widget build(BuildContext context) {
    var dic = I18n.of(context).profile;
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(
        title: Text(dic['about']),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(48),
              child: Image.asset('assets/images/public/logo_about.png'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  dic['about.brif'],
                  style: Theme.of(context).textTheme.display1,
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 16),
                child: JumpToBrowserLink('https://polkawallet.io'),
              ),
            ),
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder:
                  (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
                return snapshot.hasData
                    ? Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                            '${dic['about.version']}: v${snapshot.data.version}'),
                      )
                    : Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
