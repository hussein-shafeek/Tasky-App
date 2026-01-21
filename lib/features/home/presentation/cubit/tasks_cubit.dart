import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasky_app/core/error/failures.dart';
import 'package:tasky_app/features/home/data/models/task_model.dart';
import 'package:tasky_app/features/home/domain/use_cases/delete_task_usecase.dart';
import 'package:tasky_app/features/home/domain/use_cases/get_task_by_id_usecase.dart';
import 'package:tasky_app/features/home/domain/use_cases/get_tasks_usecase.dart';
import 'package:tasky_app/features/home/domain/use_cases/update_task_usecase.dart';
import 'package:tasky_app/features/home/presentation/cubit/tasks_state.dart';

class TasksCubit extends Cubit<TaskState> {
  final GetTasksUseCase getTasksUseCase;
  final GetTaskByIdUseCase getTaskByIdUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  
  TasksCubit({required this.getTasksUseCase, required this.getTaskByIdUseCase , required this.deleteTaskUseCase, required this.updateTaskUseCase}) : super(const TaskInitial());
  int _page = 1;
  static const int pageSize = 10;

  //fetch tasks
  Future<void> fetchTasks({bool refresh = false}) async {
    if (state is TaskLoading) return;
    if (!(state.hasMore??true) && !refresh) return;

    if (refresh) {
      _page = 1;
      emit(const TaskLoading(tasks: [], hasMore: true));
    } else {
      emit(TaskLoading(tasks: state.tasks, hasMore: state.hasMore));
    }
  final result = await getTasksUseCase(page: _page);
    result.fold(
      (failure) {
        emit(
          TaskError(
            message: failure.errMessage,
            tasks: state.tasks,
            hasMore: state.hasMore,
          ),
        );
      },
      (tasks) {
        final allTasks =
            refresh ? tasks : [...state.tasks, ...tasks];

        final hasMore = tasks.length == pageSize;

        emit(TaskSuccess(tasks: allTasks, hasMore: hasMore));

        if (hasMore) _page++;
      },
    );
  }

  //fetch task by id
  Future<void> fetchTaskById(String id) async {
    emit(TaskLoading(tasks: state.tasks, hasMore: state.hasMore));
    final result = await getTaskByIdUseCase(id);
    result.fold(
      (Failure failure) {
        emit(
          TaskError(
            message: failure.errMessage,
            tasks: state.tasks,
            hasMore: state.hasMore,
          ),
        );
      },
      (task) {
        emit(TaskSuccess(tasks: [task], hasMore: false));
      },
    );
  }



//delete task

Future<void> deleteTask(String id) async {
  emit(
    DeleteTaskLoading(
      tasks: state.tasks,
      hasMore: state.hasMore,
    ),
  );

  final result = await deleteTaskUseCase(id);

  result.fold(
    (failure) {
      emit(
        DeleteTaskError(
          message: failure.errMessage,
          tasks: state.tasks,
          hasMore: state.hasMore,
        ),
      );
    },
    (_) {
      final updatedTasks = state.tasks.where((t) => t.id != id).toList();
      emit(
        DeleteTaskSuccess(
          tasks: updatedTasks,
          hasMore: state.hasMore,
        ),
      );
    },
  );
}

//update task
Future<void> updateTask(String id, TaskModel task) async {
  emit(
    UpdateTaskLoading(
      tasks: state.tasks,
      
    ),
  );

  final result = await updateTaskUseCase(id, task);

  result.fold(
    (failure) {
      emit(
        UpdateTaskError(
          message: failure.errMessage,
          tasks: state.tasks,
          
        ),
      );
    },
    (_) {
      final updatedTasks = state.tasks.map((t) => t.id == id ? task : t).toList();
      emit(
        UpdateTaskSuccess(
          tasks: updatedTasks,
        ),
      );
    },
  );
}






}
