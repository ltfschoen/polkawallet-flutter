import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polka_wallet/common/components/roundedButton.dart';
import 'package:polka_wallet/page/governance/council.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:polka_wallet/utils/format.dart';
import 'package:polka_wallet/utils/i18n/index.dart';

class CandidateList extends StatefulWidget {
  CandidateList(this.store);
  final AppStore store;
  @override
  _CandidateList createState() => _CandidateList(store);
}

class _CandidateList extends State<CandidateList> {
  _CandidateList(this.store);
  final AppStore store;

  final List<List<String>> _selected = List<List<String>>();
  final List<List<String>> _notSelected = List<List<String>>();
  Map<String, bool> _selectedMap = Map<String, bool>();

  String _filter = '';

  @override
  void initState() {
    super.initState();

    setState(() {
      store.gov.council.members.forEach((i) {
        _notSelected.add(i);
        _selectedMap[i[0]] = false;
      });
      store.gov.council.runnersUp.forEach((i) {
        _notSelected.add(i);
        _selectedMap[i[0]] = false;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    List args = ModalRoute.of(context).settings.arguments;
    if (args.length > 0) {
      List<List<String>> ls = List<List<String>>.from(args);
      setState(() {
        _selected.addAll(ls);
        _notSelected
            .removeWhere((i) => ls.indexWhere((arg) => arg[0] == i[0]) > -1);
        ls.forEach((i) {
          _selectedMap[i[0]] = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var dic = I18n.of(context).gov;

    List<List<String>> list = [];
    list.addAll(_selected);
    // filter the _notSelected list
    List<List<String>> retained = List.of(_notSelected);
    retained = Fmt.filterCandidateList(
        retained, _filter, store.account.accountIndexMap);
    list.addAll(retained);

    return Scaffold(
      appBar: AppBar(
        title: Text(dic['candidate']),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: CupertinoTextField(
                    padding: EdgeInsets.fromLTRB(16, 6, 16, 6),
                    placeholder: I18n.of(context).staking['filter'],
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                      border: Border.all(
                          width: 0.5, color: Theme.of(context).dividerColor),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _filter = value.trim();
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: list.map(
                (i) {
                  Map accInfo = store.account.accountIndexMap[i[0]];
                  return CandidateItem(
                    accInfo: accInfo,
                    balance: i,
                    tokenSymbol: store.settings.networkState.tokenSymbol,
                    switchValue: _selectedMap[i[0]],
                    onSwitch: (value) {
                      setState(() {
                        _selectedMap[i[0]] = value;
                      });
                      Timer(Duration(milliseconds: 300), () {
                        setState(() {
                          if (value) {
                            _selected.add(i);
                            _notSelected.removeWhere((item) => item[0] == i[0]);
                          } else {
                            _selected.removeWhere((item) => item[0] == i[0]);
                            _notSelected.add(i);
                          }
                        });
                      });
                    },
                  );
                },
              ).toList(),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 32),
            child: RoundedButton(
              text: I18n.of(context).home['ok'],
              onPressed: () => Navigator.of(context).pop(_selected),
            ),
          ),
        ],
      ),
    );
  }
}