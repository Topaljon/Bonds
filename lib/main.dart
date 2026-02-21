import 'package:bonds/view/bond_details_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'bonds_lib/search_bonds.dart';
import 'bonds_lib/volatility_selection/responseUrl/response_url.dart';

void main() => runApp(MaterialApp(home: Home()));

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        home: const MyHomePage(title: 'liquid bonds MOEX'),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  SearchBonds fert = SearchBonds();
  void _incrementCounter() {
    setState(() {
      _counter++;
      fert.searchBonds();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder(
          future: bondLoadingFunction(),
          builder: (context, snapshot) {
            if (snapshot.data != null && snapshot.data != null) {
              return GridView.builder(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  itemCount: snapshot.data['securities']['data'].length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 4,
                    mainAxisExtent: context.height / 8,
                    crossAxisSpacing: 4,
                  ),
                  itemBuilder: (context, index) =>
                      getCardItem(snapshot, index));
            } else if (snapshot.hasError) {
              return Text("Error");
            }
            return CircularProgressIndicator();
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget getCardItem(AsyncSnapshot<dynamic> snapshot, int index) => Align(
        alignment: Alignment.topLeft,
        child: Container(
          //height: context.height/6,
          width: (context.width / 2) - 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: GestureDetector(
            onTap: () {
              Get.to(BondDetailsPage(bond: ,));
            },
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      child: Icon(Icons.supervisor_account,
                          size: 24, color: Colors.blueAccent),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Text(
                            "${snapshot.data['securities']['data'][index][1]}",
                            style: TextStyle(
                              color: Colors.blueAccent,
                            ),
                          ),
                          Text(
                            "${snapshot.data['securities']['data'][index][0]}",
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}

Future bondLoadingFunction() async {
  const List bondsBoardGroups = [58, 193, 105, 77, 207, 167, 245];
  Map<String, dynamic> listBonds = {};
  for (var i in bondsBoardGroups) {
    String urlBonds =
        'https://iss.moex.com/iss/engines/stock/markets/bonds/boardgroups/$i/securities.json?iss.dp=comma&iss.meta=off&iss.only=securities,marketdata&securities.columns=SECID,SECNAME,PREVLEGALCLOSEPRICE&marketdata.columns=SECID,YIELD,DURATION';
    try {
      Map<String, dynamic> list = await responseUrlBonds(urlBonds);
      // final bondsCount = list['securities']['data'];
      // final bondsMarket = list['marketdata']['data'];
      // for (var bond = 0; bond < bondsCount.length; bond++){
      //   final String? idBond = bondsCount[bond][0];
      //   final String? nameBond = bondsCount[bond][1];
      //   final double? amountBond = bondsCount[bond][2];
      //   final double? yieldBond = bondsMarket[bond][1];
      //   final double? price = bondsMarket[bond][2];
      // }
      listBonds = list;
    } catch (e) {
      print("что-то пошло не так");
    }
  }
  return listBonds;
}
