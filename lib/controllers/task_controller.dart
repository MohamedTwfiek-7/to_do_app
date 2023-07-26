import 'package:get/get.dart';
import 'package:to_do_app/db/db_helper.dart';

import '../models/task.dart';

class TaskController extends GetxController {
  final taskList = <Task>[].obs;//obs so i can listen and react to events

  Future<int> addTask({required Task task}){
    return DBHelper.insertTask(task);
  }
  Future<void> getTask() async {
    final tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }
  void deleteTask(Task task) async {
    await DBHelper.deleteTask(task);
    getTask();
  }
  void deleteAll() async {
    await DBHelper.deleteAll();
    getTask();
  }
  void markAsCompleted(int id) async {
    await DBHelper.updateTask(id);
    getTask();
  }
}
