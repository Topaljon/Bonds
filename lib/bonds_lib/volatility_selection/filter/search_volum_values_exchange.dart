import 'package:bonds/bonds_lib/volatility_selection/filter/search_board_ticker.dart';
import 'package:intl/intl.dart';
import '../responseUrl/response_url.dart';

Future<Map<String, dynamic>> searchingVolumeValuesExchange(
    id, thresholdValue, daysVolume) async {
  //обьем сделок в день (определенное значение)

  // Объем сделок в каждый из n дней больше определенного порога
  final today = DateTime.now();
  final requestedPeriod = DateFormat('yyyy-MM-dd').format(
      today.subtract(Duration(days: daysVolume))); // этот день 15 дней назад
  final idBoard = await searchBoardTicker(id);

  final urlBond =
      'https://iss.moex.com/iss/history/engines/stock/markets/bonds/boards/$idBoard/securities/$id.json?iss.meta=off&iss.only=history&history.columns=SECID,TRADEDATE,VOLUME,NUMTRADES&limit=20&from=$requestedPeriod';
  print('Ссылка для $id: $urlBond');

  try {
    Map<String, dynamic> listHistoryBond = await responseUrlBonds(urlBond);
    final listBond = listHistoryBond['history']['data'];

    int count = listBond.length;
    int volumeSum = 0;
    int lowLiquid = 0;

    for (int i = 0; i < count; i++) {
      int volume = listBond[i][2];
      volumeSum += volume;

      if (thresholdValue > volume) {
        lowLiquid = 1;
        print(
            'MOEXsearchVolume. На ${i + 1}-й день из $count оборот по бумаге $id меньше чем $thresholdValue: $volume шт.');
      }

      if (count < 6) {
        // если всего дней в апи на этом периоде очень мало
        lowLiquid = 1;
        print(
            'MOEXsearchVolume. Всего в АПИ Мосбиржи доступно $count дней, а надо хотя бы больше 6 торговых дней с $requestedPeriod!');
      }
    }

    if (lowLiquid != 1) {
      print(
          'MOEXsearchVolume. Во всех $count днях оборот по бумаге $id был больше, чем $thresholdValue шт каждый день.');
    }

    print(
        'MOEXsearchVolume. Итоговый оборот в бумагах (объем сделок, шт) за $count дней: $volumeSum шт нарастающим итогом.');

    return {'lowLiquid': lowLiquid, 'value': volumeSum};
  } catch (e) {
    print('Ошибка в MOEXsearchVolume: $e');
    return {'lowLiquid': null, 'value': null};
  }
}
