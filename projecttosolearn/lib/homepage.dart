import 'package:flutter/material.dart';
import 'package:projecttosolearn/dbhelper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> listofmap = [];

  bool _isLoading = true;

  //Controllers
  TextEditingController titleController = TextEditingController();
  TextEditingController descritptionController = TextEditingController();

//Getting database items in our local list
  void refreshListOfMap() async {
    final data = await SQLHelper.getItems();

    setState(() {
      listofmap = data;
      _isLoading = false;
    });
  }

  //Function to add items
  Future<void> _addItem() async {
    await SQLHelper.createItem(
        titleController.text, descritptionController.text);
    refreshListOfMap();
    print("...number of items ${listofmap.length}");
  }

  Future<void> _updateItem(id) async {
    await SQLHelper.updateItem(
        id, titleController.text, descritptionController.text);
    refreshListOfMap();
  }

  void deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully deleted a journal')));
    refreshListOfMap();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshListOfMap();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("NoteNotes")),
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
                    child: Row(children: [
                      IconButton(
                          onPressed: () => _showForm(listofmap[index]['id']),
                          icon: const Icon(Icons.edit)),
                      IconButton(
                          onPressed: () => deleteItem(listofmap[index]['id']),
                          icon: Icon(Icons.delete))
                    ]),
                  ),
                ),
              )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showForm(int? id) async {
    if (id != null) {
      final existingOfMap =
          listofmap.firstWhere((element) => element['id'] == id);
      titleController.text = existingOfMap['title'];
      descritptionController.text = existingOfMap['description'];
    }
    showModalBottomSheet(
        context: context,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                bottom: MediaQuery.of(context).viewInsets.bottom + 200,
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
                        controller: descritptionController,
                        decoration:
                            const InputDecoration(hintText: 'description'),
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

                            //clear the text fields
                            titleController.text = '';
                            descritptionController.text = '';

                            //close the bottom sheet

                            Navigator.of(context).pop();
                          },
                          child: Text(id == null ? 'create New ' : 'Update'))
                    ]),
              ),
            ));
  }
}
