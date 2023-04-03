import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:sqfliteagain/dbhelper.dart';
import 'package:sqfliteagain/notemodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DbHelper? dbHelper;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DbHelper();
  }

  void insertData(String title, int age, String description, String email) {
    NotesModel notesModel = NotesModel(
        id: 12, title: title, age: age, description: description, email: email);
    dbHelper!.insert(notesModel);
    Navigator.pop(context);
    titleController.text = '';
    descriptionController.text = '';
    emailController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hola")),
      body: Column(children: [
        TextField(
          controller: titleController,
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          controller: ageController,
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          controller: descriptionController,
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          controller: emailController,
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          insertData(titleController.text, ageController.toString().length,
              descriptionController.text, emailController.text);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class Shownotes extends StatefulWidget {
  const Shownotes({super.key});

  @override
  State<Shownotes> createState() => _ShownotesState();
}

class _ShownotesState extends State<Shownotes> {
  NotesModel? notesModel;
  late Future<List<NotesModel>> notesList;
  DbHelper? dbHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DbHelper();
    loadData();
  }

  loadData() async {
    notesList = dbHelper!.getNotesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Notes"),
        ),
        body: Column(
          children: [
            FutureBuilder(
                future: notesList,
                builder: (context, AsyncSnapshot<List<NotesModel>> snapshot) {
                  return ListView.builder(itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                    return Card(
                        child: ListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: Text(
                        snapshot.data![index].title.toString(),
                      ),
                    ));
                  });
                })
          ],
        ));
  }
}
