enum FiatCurrencyId {
  brl,
  cop,
  pen,
  ves,
}

extension FiatCurrencyIdApi on FiatCurrencyId {
  /// Valor de query `fiatCurrencyId` / códigos de asset en mayúsculas.
  String get asApiId => switch (this) {
        FiatCurrencyId.brl => 'BRL',
        FiatCurrencyId.cop => 'COP',
        FiatCurrencyId.pen => 'PEN',
        FiatCurrencyId.ves => 'VES',
      };
}
