import 'package:flutter/material.dart';
import 'todo_list_view_model.dart';
import 'todo.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _viewModel = TodoListViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CRUD with REST API (MVVM)'),
      ),
      body: StreamBuilder<List<Todo>>(
        stream: _viewModel.todoListStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          List<Todo> todoList = snapshot.data!;
          return ListView.builder(
            itemCount: todoList.length,
            itemBuilder: (context, index) {
              Todo todo = todoList[index];
              return ListTile(
                title: Text(todo.title),
                subtitle: Text(todo.completed ? 'Completed' : 'Not completed'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _viewModel.deleteData(todo);
                  },
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      String title = todo.title;
                      bool completed = todo.completed;

                      return AlertDialog(
                        title: Text('Update item'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              onChanged: (value) {
                                title = value;
                              },
                              decoration: InputDecoration(
                                labelText: 'Title',
                              ),
                              controller:
                                  TextEditingController(text: todo.title),
                            ),
                            CheckboxListTile(
                              value: completed,
                              onChanged: (value) {
                                completed = value!;
                              },
                              title: Text('Completed'),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: Text('Save'),
                            onPressed: () {
                              _viewModel.updateData(todo, title, completed);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              String title = '';
              bool completed = false;

              return AlertDialog(
                title: Text('Add item'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      onChanged: (value) {
                        title = value;
                      },
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                    ),
                    CheckboxListTile(
                      value: completed,
                      onChanged: (value) {
                        completed = value!;
                      },
                      title: Text('Completed'),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    child: Text('Add'),
                    onPressed: () {
                      _viewModel.addData(title, completed);
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}