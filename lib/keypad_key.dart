import 'package:flutter/material.dart';

class _NumericKey extends KeypadKey {
  const _NumericKey({Key? key, required this.number}) : super(key: key);

  final int number;

  @override
  String get value => '$number';

  @override
  Widget build(BuildContext context) => Text(
        value,
        style: Theme.of(context).textTheme.headline1?.copyWith(fontSize: 27),
      );
}

class _BackspaceKey extends KeypadKey {
  const _BackspaceKey({Key? key}) : super(key: key);

  @override
  String get value => '<';

  @override
  Widget build(BuildContext context) => const Icon(
        Icons.backspace,
        color: Colors.white,
      );
}

class _DecimalSeparatorKey extends KeypadKey {
  const _DecimalSeparatorKey({Key? key}) : super(key: key);

  @override
  String get value => '.';

  @override
  Widget build(BuildContext context) => Text(
        ".",
        style: Theme.of(context).textTheme.headline1?.copyWith(fontSize: 27),
      );
}

abstract class KeypadKey extends StatelessWidget {
  const KeypadKey({Key? key}) : super(key: key);

  const factory KeypadKey.number({required int number}) = _NumericKey;

  const factory KeypadKey.backspace() = _BackspaceKey;

  const factory KeypadKey.decimalSeparator() = _DecimalSeparatorKey;

  String get value;
}
