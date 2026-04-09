import 'package:conversion_calculator/data/model/enum/change_type.dart';
import 'package:conversion_calculator/data/model/enum/crypto_currency_id.dart';
import 'package:conversion_calculator/data/model/enum/fiat_currency_id.dart';

class CalculatorDto {
  final ChangeType changeType;
  final CryptoCurrencyId cryptoCurrencyId;
  final FiatCurrencyId fiatCurrencyId;
  final double amount;
  final double amountCurrencyId;

  CalculatorDto({
    required this.changeType,
    required this.cryptoCurrencyId,
    required this.fiatCurrencyId,
    required this.amount,
    required this.amountCurrencyId,
  });

  Map<String, dynamic> toQueryParameters() => {
        'type': changeType.asApiType,
        'cryptoCurrencyId': cryptoCurrencyId.asApiId,
        'fiatCurrencyId': fiatCurrencyId.asApiId,
        'amount': amount,
        'amountCurrencyId': amountCurrencyId,
      };
}
