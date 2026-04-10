import 'package:conversion_calculator/data/model/enum/change_type.dart';
import 'package:conversion_calculator/data/model/enum/crypto_currency_id.dart';
import 'package:conversion_calculator/data/model/enum/fiat_currency_id.dart';
import 'package:conversion_calculator/data/model/request/calculator_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('toQueryParameters mapea type, monedas, amount y amountCurrencyId', () {
    final dto = CalculatorDto(
      changeType: ChangeType.cryptoToFiat,
      cryptoCurrencyId: CryptoCurrencyId.tatumTronUsdt,
      fiatCurrencyId: FiatCurrencyId.ves,
      amount: 5,
      amountCurrencyId: 100,
    );

    final q = dto.toQueryParameters();

    expect(q['type'], 0);
    expect(q['cryptoCurrencyId'], 'TATUM-TRON-USDT');
    expect(q['fiatCurrencyId'], 'VES');
    expect(q['amount'], 5);
    expect(q['amountCurrencyId'], 100);
  });

  test('type 1 cuando origen fiat → crypto', () {
    final dto = CalculatorDto(
      changeType: ChangeType.fiatToCrypto,
      cryptoCurrencyId: CryptoCurrencyId.tatumTronUsdt,
      fiatCurrencyId: FiatCurrencyId.cop,
      amount: 100,
      amountCurrencyId: 100.0,
    );

    expect(dto.toQueryParameters()['type'], 1);
  });
}
