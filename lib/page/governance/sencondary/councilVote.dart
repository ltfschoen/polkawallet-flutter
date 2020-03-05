import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:polka_wallet/common/components/addressIcon.dart';
import 'package:polka_wallet/common/components/roundedButton.dart';
import 'package:polka_wallet/common/regInputFormatter.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:polka_wallet/utils/UI.dart';
import 'package:polka_wallet/utils/format.dart';
import 'package:polka_wallet/utils/i18n/index.dart';

class CouncilVote extends StatefulWidget {
  CouncilVote(this.store);
  final AppStore store;
  @override
  _CouncilVote createState() => _CouncilVote(store);
}

class _CouncilVote extends State<CouncilVote> {
  _CouncilVote(this.store);
  final AppStore store;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _amountCtrl = new TextEditingController();

  List<List<String>> _selected = List<List<String>>();

  Future<void> _handleCandidateSelect() async {
    var res = await Navigator.of(context)
        .pushNamed('/gov/candidates', arguments: _selected);
    if (res != null) {
      _selected = List<List<String>>.of(res);
    }
  }

  void _onSubmit() {
    if (_formKey.currentState.validate()) {
      var govDic = I18n.of(context).gov;
      int decimals = store.settings.networkState.tokenDecimals;
      String amt = _amountCtrl.text.trim();
      List selected = _selected.map((i) => i[0]).toList();
      var args = {
        "title": govDic['vote.candidate'],
        "txInfo": {
          "module": 'electionsPhragmen',
          "call": 'vote',
        },
        "detail": jsonEncode({
          "votes": selected,
          "voteValue": amt,
        }),
        "params": [
          // "votes"
          selected,
          // "voteValue"
          (double.parse(amt) * pow(10, decimals)).toInt(),
        ],
        'onFinish': (BuildContext txPageContext) {
          Navigator.popUntil(txPageContext, ModalRoute.withName('/'));
          globalCouncilRefreshKey.currentState.show();
        }
      };
      Navigator.of(context).pushNamed('/staking/confirm', arguments: args);
    }
  }

  Widget _buildSelectedList() {
    return Column(
      children: List<Widget>.from(_selected.map((i) {
        var accInfo = store.account.accountIndexMap[i[0]];
        return Container(
          margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            children: <Widget>[
              Container(
                width: 28,
                margin: EdgeInsets.only(right: 8),
                child: AddressIcon(address: i[0], size: 28),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  accInfo != null
                      ? accInfo['identity']['display'] != null
                          ? Text(accInfo['identity']['display']
                              .toString()
                              .toUpperCase())
                          : Container()
                      : Container(),
                  Text(
                    Fmt.address(i[0]),
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              )
            ],
          ),
        );
      })),
    );
  }

  @override
  Widget build(BuildContext context) {
    var govDic = I18n.of(context).gov;
    return Scaffold(
      appBar: AppBar(
        title: Text(govDic['vote.candidate']),
        centerTitle: true,
      ),
      body: Observer(
        builder: (_) {
          final Map<String, String> dic = I18n.of(context).assets;
          int decimals = store.settings.networkState.tokenDecimals;

          int balance = Fmt.balanceInt(store.assets.balance);

          return Column(
            children: <Widget>[
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: TextFormField(
                          decoration:
                              InputDecoration(labelText: dic['address']),
                          initialValue: store.account.currentAddress,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: dic['amount'],
                            labelText:
                                '${dic['amount']} (${dic['balance']}: ${Fmt.token(balance)})',
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
                              return dic['amount.error'];
                            }
                            if (double.parse(v.trim()) >=
                                balance / pow(10, decimals) - 0.02) {
                              return dic['amount.low'];
                            }
                            return null;
                          },
                        ),
                      ),
                      ListTile(
                        title: Text(govDic['candidate']),
                        trailing: Icon(Icons.arrow_forward_ios, size: 18),
                        onTap: () {
                          _handleCandidateSelect();
                        },
                      ),
                      _buildSelectedList()
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 32),
                child: RoundedButton(
                  text: I18n.of(context).home['submit.tx'],
                  onPressed: _selected.length == 0 ? null : _onSubmit,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}