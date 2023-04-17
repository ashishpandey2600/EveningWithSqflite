import 'package:flutter/material.dart';

import 'dbhelper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//List of maps
  List<Map<String, dynamic>> listofmap = [];

  bool _isLoading = true;

  //controllers
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  void refreshListOfMap() async {
    final data = await SQLHelper.getItems();
    setState(() {
      //jitne bhi items hai list me unhe emy list of map me dalna hai
      // or data jo ki SQL se a rha hai uska bhi return type same hai listofmao ke
      listofmap = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshListOfMap();
    print("..number of items ${listofmap.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("something instresting")),
      body: ListView.builder(
        itemCount: listofmap.length,
        itemBuilder: (context, index) => Card(
          color: Colors.orange[200],
          margin: const EdgeInsets.all(15),
          child: ListTile(
            title: Text(listofmap[index]['title']),
            subtitle: Text(listofmap[index]['description']),
            trailing: SizedBox(
              width: 100,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () => _showForm(listofmap[index]['id']),
                      icon: const Icon(Icons.edit)),
                  IconButton(
                      onPressed: () => _deleteItem(listofmap[index]['id']), icon: const Icon(Icons.delete))
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        child: const Icon(Icons.add),
      ),
    );
  }

  //_addItems method
  Future<void> _addItem() async {
    await SQLHelper.createItem(
        titleController.text, descriptionController.text);
    refreshListOfMap();
    print("..number of items ${listofmap.length}");
  }

  Future<void> _UpdateItem(int id) async {
    await SQLHelper.updateItem(
        id, titleController.text, descriptionController.text);
  }

  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a journal!'),
    ));
    refreshListOfMap();
  }

  void _showForm(int? id) async {
    if (id != null) {
      final existingListOfMap =
          listofmap.firstWhere((element) => element['id'] == id);
      titleController.text = existingListOfMap['title'];
      descriptionController.text = existingListOfMap['description'];
    }
    showModalBottomSheet(
        context: context,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                bottom: MediaQuery.of(context).viewInsets.bottom + 220,
              ),
              child: SingleChildScrollView(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(hintText: 'Title'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: descriptionController,
                        decoration:
                            const InputDecoration(hintText: 'Description'),
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
                              await _UpdateItem(id);
                            }
                            //clear the text fields
                            titleController.text = '';
                            descriptionController.text = '';
                            //close the bottom sheet

                            Navigator.of(context).pop();
                          },
                          child: Text(id == null ? 'create New ' : 'Update'))
                    ]),
              ),
            ));
  }
}
