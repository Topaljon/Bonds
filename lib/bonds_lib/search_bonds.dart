import 'package:bonds/bonds_lib/volatility_selection/responseUrl/response_url.dart';
import 'package:bonds/bonds_lib/volatility_selection/filter/search_volum_values_exchange.dart';
import 'package:intl/intl.dart';

class SearchBonds {
  SearchBonds();

  Future<void> searchBonds() async {
    //параметры фильтра 8 параметров
    const volumeIsLarger = 100;
    List bonds = [];
    const List bondsBoardGroups = [58, 193, 105, 77, 207, 167, 245];
    for (var i in bondsBoardGroups) {
      try {
        String urlBonds =
            'https://iss.moex.com/iss/engines/stock/markets/bonds/boardgroups/$i/securities.json?iss.dp=comma&iss.meta=off&iss.only=securities,marketdata&securities.columns=SECID,SECNAME,PREVLEGALCLOSEPRICE&marketdata.columns=SECID,YIELD,DURATION';
        Map<String, dynamic> list = await responseUrlBonds(urlBonds);

        final bondsCount = list['securities']['data'];
        final bondsMarket = list['marketdata']['data'];

        for (var bond = 0; bond < bondsCount.length; bond++) {
          final String? idBond = bondsCount[bond][0];
          //print(idBond);
          final String? nameBond = bondsCount[bond][1];
          //print(nameBond);
          final double? amountBond = bondsCount[bond][2];
          //print(amountBond);
          final double? yieldBond = bondsMarket[bond][1];
          // //print(yieldBond);
          final double? price = bondsMarket[bond][2];
          // //print(price.toString());
          final double durationOfTheBond = (price ?? 0.floor()) / 30;
          //print('$idBond $nameBond цена за облигацию - $amountBond, доходность - $yieldBond, оставшиеся месяцы - $durationOfTheBond');

          const double priceMore = 20; //__________________
          const double lessPrice = 505; //___________________

          bool morePriceLess = ((amountBond ?? 0) > priceMore) &&
              ((amountBond ?? 0) < lessPrice);

          const double lowerProfitability = 19;
          const double higherProfitability = 2;
          bool yieldHigherLower = ((yieldBond ?? 0) > higherProfitability) &&
              ((yieldBond ?? 0) < lowerProfitability);

          const double durationIsLonger = 20;
          const double durationIsLess = 35;
          bool durationLongerLess = (durationOfTheBond > durationIsLonger) &&
              (durationOfTheBond < durationIsLess);

          const int bondVolumeMore =
              50; // Совокупный объем сделок за n дней, шт. больше этой цифры //***********************
          bool offerYesNo = true;

          if (yieldHigherLower && durationLongerLess && morePriceLess) {
            print(
                "Условие доходности: $yieldBond > $higherProfitability < $lowerProfitability,"
                " цены: $priceMore < $price < $lessPrice,"
                " дюрация: $durationIsLonger < $durationOfTheBond < $durationIsLonger");

            final volume =
                await searchingVolumeValuesExchange(idBond, volumeIsLarger, 30);

            final BondVolume = volume["value"]; //******************

            if (volume["lowLiquid"] == 0 && BondVolume > bondVolumeMore) {
              //❗ 0 - чтобы оборот был строго больше заданного
              //❗ 1 - фильтр оборота не учитывается, в выборку попадают все бумаги, подходящие по остальным параметрам
              final monthsOfPayments = await monthsCouponPaymentsOccur(idBond);

              var monthsOfPaymentsDates = monthsOfPayments['formattedDates'];
              var monthsOfPaymentsNull = monthsOfPayments['valueNull'];

              if (offerYesNo == true && monthsOfPaymentsNull == 0) {
                bonds.add([
                  nameBond,
                  idBond,
                  price,
                  BondVolume,
                  yieldBond,
                  durationOfTheBond,
                  monthsOfPaymentsDates
                ]);
              }
              if (offerYesNo == false) {
                bonds.add([
                  nameBond,
                  idBond,
                  price,
                  BondVolume,
                  yieldBond,
                  durationOfTheBond,
                  monthsOfPaymentsDates
                ]);
              }
            }
          }
        }
      } catch (e) {
        print("Непредвиденная ошибка $e");
      }
    }
  }

  Future monthsCouponPaymentsOccur(id) async {
    //месяцы выплаты купонов
    try {
      String cupponsUrl =
          'https://iss.moex.com/iss/statistics/engines/stock/markets/bonds/bondization/${id}.json?iss.meta=off&iss.only=coupons';

      Map<String, dynamic> listCoupons = await responseUrlBonds(cupponsUrl);
      List<String> couponDates = [];
      int valueNull = 0;

      for (var j = 0; j < listCoupons['coupons']['data'].length; j++) {
        final couponDate = listCoupons['coupons']['data'][j][3];
        final valueCurrent = listCoupons['coupons']['data'][j][9];
        bool inFuture =
            DateFormat('yyyy-mm-dd').parse(couponDate).millisecondsSinceEpoch >
                DateTime.now().millisecondsSinceEpoch;
        if (inFuture == true) {
          couponDates.add(couponDate);
          if (valueCurrent == null) {
            valueNull += 1;
          }
        }
      }
      if (valueNull > 0) {
        print(
            "MOEXsearchMonthsOfPayments. Для ${id} есть ${valueNull} дат(ы) будущих платежей с неизвестным значением выплат.");
      }

      if (couponDates.isEmpty) {
        print("couponDates пустой");
      } else {
        print("couponDates не пустой");
        print(
            'MOEXsearchMonthsOfPayments. Купоны для $id выплачиваются в $couponDates месяцы.');
      }
      return {'formattedDates': couponDates, 'valueNull': valueNull};
    } catch (e) {
      print("Ошибка поиска идентификатора поиска по тикеру - $e");
    }
  }
}
