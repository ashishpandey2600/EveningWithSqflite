import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fluttersqflite/sqlhelper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _journals = [];

  bool _isLoading = true;

  void _refreshJournals() async {
    final data = await SQLHelper.getItems(); //returns data in map form
    setState(() {
      _journals = data; //putting data in empty list
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshJournals();
    print("..number of items ${_journals.length}");
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descritptionController = TextEditingController();
  

  _updateItem(int id) async {
    await SQLHelper.updateItem(id, _titleController.text, _descritptionController.text);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SQL")),
      body: ListView.builder(
        itemCount: _journals.length,
        itemBuilder: (context, index) => Card(
          color: Colors.orange[200],
          margin: const EdgeInsets.all(15),
          child: ListTile(
            title: Text(_journals[index]['title']),
            subtitle: Text(_journals[index]['description']),
            trailing: SizedBox(
              width: 100,
              child: Row(children: [
                IconButton(
                  onPressed: () => _showForm(_journals[index]['id']),
                  icon: Icon(Icons.edit),
                ),
                IconButton(onPressed: () => null, icon: Icon(Icons.delete))
              ]),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        child: const Icon(Icons.download),
      ),
    );
  }

  void _showForm(int? id) async {
    if (id != null) {
      final existingJournal =
          _journals.firstWhere((element) => element['id'] == id);
      _titleController.text = existingJournal['title'];
      _descritptionController.text = existingJournal['description'];
    }
    showModalBottomSheet(
        context: context,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                //this will prevent the soft keyboard from covering the tect fields
                bottom: MediaQuery.of(context).viewInsets.bottom + 150,
              ),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(hintText: 'Title'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _descritptionController,
                      decoration: const InputDecoration(hintText: "Decoration"),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (id == null) {
                          await _addItem();
                        }
                        if (id != null) {
                          await _updateItem(id);
                        }
                        _titleController.text = '';
                        _descritptionController.text = '';
                        //close the bottom sheet
                        Navigator.of(context).pop();
                      },
                      child: Text(id == null ? 'Create New' : 'Update'),
                    )
                  ]),
            ));
  }

  _addItem() async {
    await SQLHelper.createItem(
        _titleController.text, _descritptionController.text);
    _refreshJournals();
    print("...number of items ${_journals.length}");
  }

}
