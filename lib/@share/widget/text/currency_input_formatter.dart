import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  CurrencyInputFormatter({required this.maxDigits});
  final int maxDigits;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    if (maxDigits > 0 && newValue.selection.baseOffset > maxDigits) {
      return oldValue;
    }

    double value = double.parse(newValue.text.replaceAll(',', ''));
    final formatter = NumberFormat('#,###', 'pt_BR');
    String newText = formatter.format(value);
    return newValue.copyWith(
      text: newText.replaceAll('.', ','),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
