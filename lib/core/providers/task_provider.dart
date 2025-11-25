import 'package:flutter/material.dart';
import 'package:tasky_app/core/models/add_task_model.dart';
import 'package:tasky_app/core/models/task_model.dart';
import 'package:tasky_app/core/models/update_model.dart';
import 'package:tasky_app/core/services/todo_service.dart';

class TaskProvider extends ChangeNotifier {
  final TodoService todoService;

  TaskProvider({required this.todoService});

  List<TaskModel> _tasks = [];
  List<TaskModel> get tasks => _tasks;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  int _page = 1;
  bool _hasMore = true;

  Future<void> fetchTasks({bool refresh = false}) async {
    if (_isLoading) return;

    if (refresh) {
      _page = 1;
      _hasMore = true;
      _tasks.clear();
    }

    if (!_hasMore) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fetchedTasks = await todoService.getTodos(page: _page);

      if (fetchedTasks.isEmpty) {
        _hasMore = false;
      } else {
        _tasks.addAll(fetchedTasks);
        _page++;
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshTasks() async => fetchTasks(refresh: true);

  Future<void> addTask(CreateTodoModel model) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newTask = await todoService.createTodo(model);
      _tasks.insert(0, newTask);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateTask(String id, UpdateTodoModel model) async {
    _isLoading = true;
    notifyListeners();

    try {
      final success = await todoService.updateTodo(id: id, model: model);

      if (success) {
        // Re-fetch updated task from API
        final updated = await todoService.getTodoById(id);

        final index = _tasks.indexWhere((t) => t.id == id);
        if (index != -1) {
          _tasks[index] = updated;
        }
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteTask(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await todoService.deleteTodo(id);
      if (success) {
        _tasks.removeWhere((t) => t.id == id);
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  TaskModel? getTaskById(String id) {
    try {
      return _tasks.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }
}
