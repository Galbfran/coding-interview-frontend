import 'package:conversion_calculator/data/model/enum/crypto_currency_id.dart';
import 'package:conversion_calculator/data/model/enum/fiat_currency_id.dart';
import 'package:conversion_calculator/presentation/models/selection_option.dart';

/// Listas y mapeos para el selector (rutas alineadas a los PNG en assets).
abstract final class CurrencySelectionCatalog {
  static const String _fiatDir = 'assets/fiat_currencies';
  static const String _cryptoDir = 'assets/cripto_currencies';

  static List<SelectionOption> fiatOptions() => [
        SelectionOption(
          code: FiatCurrencyId.ves.asApiId,
          title: FiatCurrencyId.ves.asApiId,
          subtitle: 'Bolívares (Bs)',
          assetPath: '$_fiatDir/VES.png',
        ),
        SelectionOption(
          code: FiatCurrencyId.cop.asApiId,
          title: FiatCurrencyId.cop.asApiId,
          subtitle: 'Pesos Colombianos (COL\$)',
          assetPath: '$_fiatDir/COP.png',
        ),
        SelectionOption(
          code: FiatCurrencyId.pen.asApiId,
          title: FiatCurrencyId.pen.asApiId,
          subtitle: 'Soles Peruanos (S/)',
          assetPath: '$_fiatDir/PEN.png',
        ),
        SelectionOption(
          code: FiatCurrencyId.brl.asApiId,
          title: FiatCurrencyId.brl.asApiId,
          subtitle: 'Real brasileño (R\$)',
          assetPath: '$_fiatDir/BRL.png',
        ),
      ];

  static List<SelectionOption> cryptoOptions() => [
        SelectionOption(
          code: CryptoCurrencyId.tatumTronUsdt.asApiId,
          title: 'USDT',
          subtitle: 'Tether (USDT)',
          assetPath: '$_cryptoDir/TATUM-TRON-USDT.png',
        ),
      ];

  static FiatCurrencyId? fiatFromCode(String code) {
    for (final id in FiatCurrencyId.values) {
      if (id.asApiId == code) return id;
    }
    return null;
  }

  static CryptoCurrencyId? cryptoFromCode(String code) {
    for (final id in CryptoCurrencyId.values) {
      if (id.asApiId == code) return id;
    }
    return null;
  }

  static String displayTitleForFiat(FiatCurrencyId id) => id.asApiId;

  static String displayTitleForCrypto(CryptoCurrencyId id) => switch (id) {
        CryptoCurrencyId.tatumTronUsdt => 'USDT',
      };

  static String assetPathForFiat(FiatCurrencyId id) {
    return fiatOptions()
        .firstWhere((o) => o.code == id.asApiId)
        .assetPath;
  }

  static String assetPathForCrypto(CryptoCurrencyId id) {
    return cryptoOptions()
        .firstWhere((o) => o.code == id.asApiId)
        .assetPath;
  }
}
