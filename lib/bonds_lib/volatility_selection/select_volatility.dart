class SelectVolatility {
  int? higherProfitability;

  SelectVolatility(
      {required this.higherProfitability,
      required this.lowerProfitability,
      required this.priceMore,
      required this.lessPrice,
      required this.durationIsLonger,
      required this.durationIsLess,
      required this.transactionVolume,
      required this.totalVolumeTransactions,
      required this.cashPaymentsToMaturity});

  int? lowerProfitability;
  int? priceMore;
  int? lessPrice;
  int? durationIsLonger;
  int? durationIsLess;
  int? transactionVolume;
  int? totalVolumeTransactions;
  bool? cashPaymentsToMaturity;
}
