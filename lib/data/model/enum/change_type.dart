enum ChangeType {
  cryptoToFiat,
  fiatToCrypto,
}

extension ChangeTypeApi on ChangeType {
  /// Valor de query `type` del API (0 = CRYPTO→FIAT, 1 = FIAT→CRYPTO).
  int get asApiType => switch (this) {
        ChangeType.cryptoToFiat => 0,
        ChangeType.fiatToCrypto => 1,
      };
}
