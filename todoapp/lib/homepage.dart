import 'package:flutter/material.dart';
import 'package:todoapp/dbhelper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> listofmap = [];

  TextEditingController descriptionController = TextEditingController();

  void refreahListofmap() async {
    final data = await SQLHelper.getItems();
    setState(() {
      listofmap = data;
    });
    print("function refreashListofmap $listofmap.length");
  }


  //adding items in SQL database
  Future<void> _addItem(int  isdone) async {
    await SQLHelper.createItem(isdone, descriptionController.text);
    refreahListofmap();
    descriptionController.text = '';
  }

  Future<void> UpdateItem(int id, int isdone, String destext) async {
    await SQLHelper.updateItem(id, isdone, destext);
    refreahListofmap();
  }

  void deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully delete the journal')));
    refreahListofmap();
  }

  void initState() {
    super.initState();
    refreahListofmap();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo"),
      ),
      body: Stack(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: listofmap.length,
                    itemBuilder: (context, index) => Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: ListTile(
                        onTap: () {
                          print(listofmap[index]['isdone']);

                          // UpdateItem(listofmap[index]['isdone'], 1);
                          listofmap[index]['isdone'] == 0
                              ? UpdateItem(listofmap[index]['id'], 1,
                                  listofmap[index]['description'])
                              : UpdateItem(listofmap[index]['id'], 0,
                                  listofmap[index]['description']);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        tileColor: Colors.white,
                        leading: Icon(
                          (listofmap[index]['isdone']==1 ?true : false)
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: Colors.blue,
                        ),
                        title: Text(
                          listofmap[index]['description'],
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              decoration: (listofmap[index]['isdone']==1 ?true : false)
                                  ? TextDecoration.lineThrough
                                  : null),
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.all(0),
                          margin: const EdgeInsets.symmetric(vertical: 12),
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10)),
                          child: IconButton(
                            color: Colors.white,
                            iconSize: 18,
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              deleteItem(listofmap[index]['id']);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        bottom: 20,
                        right: 20,
                        left: 20,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 0.0),
                            blurRadius: 10.0,
                            spreadRadius: 0.0,
                          )
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                          hintText: 'Add a new todo item',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 20,
                      right: 20,
                    ),
                    child: ElevatedButton(
                      child: Text(
                        '+',
                        style: TextStyle(fontSize: 40),
                      ),
                      onPressed: () {
                        _addItem(0);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.purple,
                        minimumSize: Size(60, 60),
                      ),
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }
}
