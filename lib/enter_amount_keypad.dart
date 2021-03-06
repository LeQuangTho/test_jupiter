import 'dart:math' as math;

import 'package:dfunc/dfunc.dart';
import 'package:flutter/material.dart';
import 'package:test_jupiter/keypad_key.dart';

class EnterAmountKeypad extends StatelessWidget {
  const EnterAmountKeypad({
    Key? key,
    required this.controller,
    required this.maxDecimals,
    this.size,
  }) : super(key: key);

  final TextEditingController controller;
  final int maxDecimals;
  final double? size;

  static const _keys = [
    KeypadKey.number(number: 1),
    KeypadKey.number(number: 2),
    KeypadKey.number(number: 3),
    KeypadKey.number(number: 4),
    KeypadKey.number(number: 5),
    KeypadKey.number(number: 6),
    KeypadKey.number(number: 7),
    KeypadKey.number(number: 8),
    KeypadKey.number(number: 9),
    KeypadKey.decimalSeparator(),
    KeypadKey.number(number: 0),
    KeypadKey.backspace(),
  ];

  void _manageKey(String key, String decimalSeparator) {
    String value = controller.text;
    if (key == '<') {
      if (value.isNotEmpty) {
        final start = controller.selection.start;
        final end = controller.selection.end;
        final offset = start == end ? 1 : 0;
        final firstPartEnd = math.max(start - offset, 0);
        final secondPartStart = math.max(end, 0);
        final firstPart = value.substring(0, firstPartEnd);
        final secondPart = value.substring(secondPartStart, value.length);
        value = '$firstPart$secondPart';
      }
    } else if (key == '.') {
      // If we already have it, ignore it
      if (value.contains(decimalSeparator)) {
        return;
      } else if (value.isEmpty) {
        value = '0$decimalSeparator';
      } else {
        value = '$value$decimalSeparator';
      }
    } else {
      if (value.isEmpty && key == '0') {
        value = '0$decimalSeparator';
      } else {
        value = '$value$key'.replaceFirst(RegExp('^[0]+'), '');
        if (value.startsWith(decimalSeparator)) {
          value = '0$value';
        }
      }
    }

    final decimals = value
        .split(decimalSeparator)
        .let((v) => v.length > 1 ? v[1] : '')
        .let((v) => v.length);

    if (decimals <= maxDecimals) {
      controller.value = controller.value.copyWith(
        text: value,
        selection: TextSelection.collapsed(offset: value.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const decimalSeparator = ".";

    final size = this.size ?? MediaQuery.of(context).size.height / 2;

    return SizedBox(
      height: size,
      width: size,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          childAspectRatio: 3 / 2,
          crossAxisCount: 3,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          children: _keys
              .map(
                (KeypadKey child) => InkWell(
                  onTap: () => _manageKey(child.value, decimalSeparator),
                  child: Center(child: child),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
