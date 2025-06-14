import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:teste/form_modal.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    _fillTable();
    super.initState();
  }

  Future<void> _fillTable() async {
    http.Response response = await http.get(
      Uri.parse('http://192.168.0.121:3000/api'),
    );
    final List<dynamic> decodeJson = jsonDecode(response.body);
    List<Map<String, dynamic>> tempData = (decodeJson)
        .map((item) => item as Map<String, dynamic>)
        .toList();

    tempData.forEach((element) {
      element['edit_btn'] = ElevatedButton(
        onPressed: () => {},
        child: Icon(Icons.edit),
      );

      element['delete_btn'] = ElevatedButton(
        onPressed: () => {deleteItem(element['id'])},
        child: Icon(Icons.delete),
      );
    });

    setState(() {
      data = tempData;
    });
  }

  void createItem(data) async {
    http.Response response = await http.post(
      Uri.parse('http://192.168.0.121:3000/api'),
      body: data,
    );

    if (response.statusCode == 200) {
    }
  }

  void editItem(id) {}

  void deleteItem(id) async {
    AlertDialog(title: Text('data'),);

    http.Response response = await http.delete(
      Uri.parse('http://192.168.0.121:3000/api?id=' + id.toString()),
    );

    if (response.statusCode == 200) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hotel Pet - PluriTech')),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          border: TableBorder.all(),
          columns: const [
            DataColumn(label: Text('')),
            DataColumn(label: Text('')),
            DataColumn(label: Text('Responsável')),
            DataColumn(label: Text('Espécie')),
            DataColumn(label: Text('Raça')),
            DataColumn(label: Text('Data início')),
            DataColumn(label: Text('Data Saída')),
          ],
          rows: data.map((item) {
            return DataRow(
              cells: [
                DataCell(item['delete_btn']),
                DataCell(item['edit_btn']),
                DataCell(Text('${item['tutor']}')),
                DataCell(Text('${item['species']}')),
                DataCell(Text('${item['race']}')),
                DataCell(Text('${item['entry_date']}')),
                DataCell(Text('${item['exit_date']}')),
              ],
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) =>
                FormModal(titleText: 'Adcionar Cliente', func: createItem),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), //
    );
  }
}
