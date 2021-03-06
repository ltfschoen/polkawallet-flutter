import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polka_wallet/common/components/addressFormItem.dart';
import 'package:polka_wallet/common/components/roundedButton.dart';
import 'package:polka_wallet/common/regInputFormatter.dart';
import 'package:polka_wallet/page/account/txConfirmPage.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:polka_wallet/utils/UI.dart';
import 'package:polka_wallet/utils/format.dart';
import 'package:polka_wallet/utils/i18n/index.dart';

class BondExtraPage extends StatefulWidget {
  BondExtraPage(this.store);
  static final String route = '/staking/bondExtra';
  final AppStore store;
  @override
  _BondExtraPageState createState() => _BondExtraPageState(store);
}

class _BondExtraPageState extends State<BondExtraPage> {
  _BondExtraPageState(this.store);
  final AppStore store;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _amountCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    var dic = I18n.of(context).staking;
    var assetDic = I18n.of(context).assets;
    String symbol = store.settings.networkState.tokenSymbol;
    int decimals = store.settings.networkState.tokenDecimals;

    int balance = Fmt.balanceInt(store.assets.balance);
    int bonded = store.staking.ledger['stakingLedger']['active'];
    int unlocking = 0;
    List unlockingList = store.staking.ledger['stakingLedger']['unlocking'];
    unlockingList.forEach((i) => unlocking += i['value']);
    int available = balance - bonded - unlocking;
    String address = store.account.currentAddress;

    return Scaffold(
      appBar: AppBar(
        title: Text(dic['action.bondExtra']),
        centerTitle: true,
      ),
      body: Builder(builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: EdgeInsets.all(16),
                    children: <Widget>[
                      AddressFormItem(
                        dic['stash'],
                        store.account.currentAccount,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: assetDic['amount'],
                          labelText:
                              '${assetDic['amount']} (${dic['available']}: ${Fmt.token(available)} $symbol)',
                        ),
                        inputFormatters: [
                          RegExInputFormatter.withRegex(
                              '^[0-9]{0,6}(\\.[0-9]{0,$decimals})?\$')
                        ],
                        controller: _amountCtrl,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        validator: (v) {
                          if (v.isEmpty) {
                            return assetDic['amount.error'];
                          }
                          if (double.parse(v.trim()) >=
                              available / pow(10, decimals) - 0.02) {
                            return assetDic['amount.low'];
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: RoundedButton(
                  text: I18n.of(context).home['submit.tx'],
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      var args = {
                        "title": dic['action.bondExtra'],
                        "txInfo": {
                          "module": 'staking',
                          "call": 'bondExtra',
                        },
                        "detail": jsonEncode({
                          "amount": _amountCtrl.text.trim(),
                        }),
                        "params": [
                          // "amount"
                          (double.parse(_amountCtrl.text.trim()) *
                                  pow(10, decimals))
                              .toInt(),
                        ],
                        'onFinish': (BuildContext txPageContext) {
                          Navigator.popUntil(
                              txPageContext, ModalRoute.withName('/'));
                          globalBondingRefreshKey.currentState.show();
                        }
                      };
                      Navigator.of(context)
                          .pushNamed(TxConfirmPage.route, arguments: args);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
