import 'package:flutterproject/services/http_request.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'data.dart';
import 'dash_board_page.dart';

class FuelHistory extends StatefulWidget {
  const FuelHistory({super.key});

  @override
  FuelQuoteHistory createState() {
    return FuelQuoteHistory();
  }
}

class FuelQuoteHistory extends State<FuelHistory> {
  List<Map<String, dynamic>> quotes = [];
  final List<Quote> data = [];

  @override
  void initState(){
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    quotes = await HttpRequest.handleQuoteGet(1);
    setState(() {
      for (var i = 0; i < quotes.length; i++) {
        DateTime date = DateFormat('EEE, dd MMM yyyy HH:mm:ss').parse(quotes[i]['date']);
        String formattedDate = DateFormat('yyyy-MM-dd').format(date);
        final quote = Quote(
          id: quotes[i]['id'],
          gallons: quotes[i]['gallons'],
          address: quotes[i]['address'],
          date: formattedDate,
          suggested: quotes[i]['suggested'],
          total: quotes[i]['total'],
        );
        data.add(quote);
      }
    });
  }

  int sortColumn = 0;
  bool isAscending = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Fuel Quote History", style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          )),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Dashboard())
                  );
                },
                tooltip: 'Go Back',
              );
            },
          ),
        ),
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: constraints.maxWidth,
                  child: DataTable(
                    sortColumnIndex: sortColumn,
                    sortAscending: isAscending,
                    headingRowColor: MaterialStateProperty.all(const Color(0xFFE0E0E0)),
                    columns: [
                      DataColumn(
                          label: const Text(
                            'ID',
                            style: TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                          onSort: (columnIndex, _) {
                            setState(() {
                              sortColumn = columnIndex;
                              if (isAscending == true) {
                                isAscending = false;
                                data.sort((quoteA, quoteB) => quoteB.id.compareTo(quoteA.id));
                              } else {
                                isAscending = true;
                                data.sort((quoteA, quoteB) => quoteA.id.compareTo(quoteB.id));
                              }
                            });
                          }),
                      DataColumn(
                          label: const Text(
                            'Gallons',
                            style: TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                          onSort: (columnIndex, _) {
                            setState(() {
                              sortColumn = columnIndex;
                              if (isAscending == true) {
                                isAscending = false;
                                data.sort((quoteA, quoteB) => quoteB.gallons.compareTo(quoteA.gallons));
                              } else {
                                isAscending = true;
                                data.sort((quoteA, quoteB) => quoteA.gallons.compareTo(quoteB.gallons));
                              }
                            });
                          }),
                      const DataColumn(label: Text('Address')),
                      DataColumn(
                          label: const Text(
                            'Date',
                            style: TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                          onSort: (columnIndex, _) {
                            setState(() {
                              sortColumn = columnIndex;
                              if (isAscending == true) {
                                isAscending = false;
                                data.sort((quoteA, quoteB) => quoteB.date.compareTo(quoteA.date));
                              } else {
                                isAscending = true;
                                data.sort((quoteA, quoteB) => quoteA.date.compareTo(quoteB.date));
                              }
                            });
                          }),
                      const DataColumn(label: Text('Suggested')),
                      DataColumn(
                          label: const Text(
                            'Total',
                            style: TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                          onSort: (columnIndex, _) {
                            setState(() {
                              sortColumn = columnIndex;
                              if (isAscending == true) {
                                isAscending = false;
                                data.sort((quoteA, quoteB) => quoteB.total.compareTo(quoteA.total));
                              } else {
                                isAscending = true;
                                data.sort((quoteA, quoteB) => quoteA.total.compareTo(quoteB.total));
                              }
                            });
                          }),
                    ],
                    rows: data.map((item) {
                      return DataRow(cells: [
                        DataCell(Text(item.id.toString())),
                        DataCell(Text(item.gallons.toString())),
                        DataCell(Text(item.address)),
                        DataCell(Text(item.date)),
                        DataCell(Text('\$${item.suggested}/gal')),
                        DataCell(Text('\$${item.total}')),
                      ]);
                    }).toList(),
                  ),
                ),
              );
            }
        )
    );
  }
}