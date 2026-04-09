enum CryptoCurrencyId {
  tatumTronUsdt,
}

extension CryptoCurrencyIdApi on CryptoCurrencyId {
  /// Valor de query `cryptoCurrencyId` (id alineado al asset sin `.png`).
  String get asApiId => switch (this) {
        CryptoCurrencyId.tatumTronUsdt => 'TATUM-TRON-USDT',
      };
}
