// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AppStore on _AppStore, Store {
  final _$accountAtom = Atom(name: '_AppStore.account');

  @override
  AccountStore get account {
    _$accountAtom.context.enforceReadPolicy(_$accountAtom);
    _$accountAtom.reportObserved();
    return super.account;
  }

  @override
  set account(AccountStore value) {
    _$accountAtom.context.conditionallyRunInAction(() {
      super.account = value;
      _$accountAtom.reportChanged();
    }, _$accountAtom, name: '${_$accountAtom.name}_set');
  }

  final _$assetsAtom = Atom(name: '_AppStore.assets');

  @override
  AssetsStore get assets {
    _$assetsAtom.context.enforceReadPolicy(_$assetsAtom);
    _$assetsAtom.reportObserved();
    return super.assets;
  }

  @override
  set assets(AssetsStore value) {
    _$assetsAtom.context.conditionallyRunInAction(() {
      super.assets = value;
      _$assetsAtom.reportChanged();
    }, _$assetsAtom, name: '${_$assetsAtom.name}_set');
  }

  final _$stakingAtom = Atom(name: '_AppStore.staking');

  @override
  StakingStore get staking {
    _$stakingAtom.context.enforceReadPolicy(_$stakingAtom);
    _$stakingAtom.reportObserved();
    return super.staking;
  }

  @override
  set staking(StakingStore value) {
    _$stakingAtom.context.conditionallyRunInAction(() {
      super.staking = value;
      _$stakingAtom.reportChanged();
    }, _$stakingAtom, name: '${_$stakingAtom.name}_set');
  }

  final _$settingsAtom = Atom(name: '_AppStore.settings');

  @override
  SettingsStore get settings {
    _$settingsAtom.context.enforceReadPolicy(_$settingsAtom);
    _$settingsAtom.reportObserved();
    return super.settings;
  }

  @override
  set settings(SettingsStore value) {
    _$settingsAtom.context.conditionallyRunInAction(() {
      super.settings = value;
      _$settingsAtom.reportChanged();
    }, _$settingsAtom, name: '${_$settingsAtom.name}_set');
  }

  final _$_AppStoreActionController = ActionController(name: '_AppStore');

  @override
  void init(BuildContext context) {
    final _$actionInfo = _$_AppStoreActionController.startAction();
    try {
      return super.init(context);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }
}