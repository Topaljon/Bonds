import '../responseUrl/response_url.dart';

Future searchBoardTicker(id) async {
  //идентификатор купона по тикеру
  String boardUrl =
      'https://iss.moex.com/iss/securities/${id}.json?iss.meta=off&iss.only=boards&boards.columns=secid,boardid,is_primary';
  try {
    Map<String, dynamic> list = await responseUrlBonds(boardUrl);
    String boardId =
        list['boards']['data'].firstWhere((element) => element[2] == 1)[1];
    return boardId;
  } catch (e) {
    print("Ошибка поиска идентификатора по тикеру - $e");
  }
}
