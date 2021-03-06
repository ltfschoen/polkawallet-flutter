import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polka_wallet/common/components/addressIcon.dart';
import 'package:polka_wallet/utils/UI.dart';
import 'package:polka_wallet/utils/format.dart';

class AccountInfo extends StatelessWidget {
  AccountInfo({this.accInfo, this.address});
  final Map accInfo;
  final String address;
  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    bool hasJudgements = false;
    if (accInfo != null) {
      List<Widget> ls = [];
      accInfo['identity'].keys.forEach((k) {
        if (k != 'judgements' && k != 'other') {
          ls.add(Row(
            children: <Widget>[
              Container(
                width: 80,
                child: Text(k),
              ),
              Text(accInfo['identity'][k].toString()),
            ],
          ));
        }
      });
      List judgements = accInfo['identity']['judgements'];
      hasJudgements = judgements.length > 0;

      if (ls.length > 0) {
        list.add(Divider());
        list.add(Container(height: 4));
        list.addAll(ls);
      }
    }

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 16, bottom: 8),
          child: AddressIcon(address),
        ),
//        accInfo != null ? Text(accInfo['accountIndex']) : Container(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            hasJudgements
                ? Container(
                    width: 16,
                    margin: EdgeInsets.only(right: 8),
                    child: Image.asset('assets/images/assets/success.png'),
                  )
                : Container(),
            Text(Fmt.address(address)),
            IconButton(
              icon: Image.asset('assets/images/public/copy.png'),
              onPressed: () => UI.copyAndNotify(context, address),
            )
          ],
        ),
        accInfo == null
            ? Container()
            : Container(
                padding: EdgeInsets.only(left: 24, right: 24, bottom: 4),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: list),
              )
      ],
    );
  }
}
