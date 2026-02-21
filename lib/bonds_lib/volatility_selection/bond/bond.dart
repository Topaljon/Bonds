class Bond {
  final String name;
  final double volume; // Объем торгов (торговая активность)
  final String issuer; // Эмитент
  final double yield; // Доходность
  final int maturity; // Срок до погашения (в днях)
  final String creditRating; // Кредитный рейтинг
  final bool couponPayment; // Наличие купонных выплат

  Bond(this.name, this.volume, this.issuer, this.yield, this.maturity,
      this.creditRating, this.couponPayment);
}

List<Bond> filterLiquidBonds(
  List<Bond> bonds, {
  required double minVolume,
  required List<String> allowedIssuers,
  required double minYield,
  required int maxMaturity,
  required List<String> allowedCreditRatings,
  required bool requireCouponPayment,
}) {
  return bonds.where((bond) {
    return bond.volume >= minVolume &&
        allowedIssuers.contains(bond.issuer) &&
        bond.yield >= minYield &&
        bond.maturity <= maxMaturity &&
        allowedCreditRatings.contains(bond.creditRating) &&
        (!requireCouponPayment || bond.couponPayment);
  }).toList();
}
