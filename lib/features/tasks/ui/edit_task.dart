import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tasky_app/core/models/update_model.dart';
import 'package:tasky_app/core/resources/assets_manager.dart';
import 'package:tasky_app/core/services/upload_service.dart';
import 'package:tasky_app/features/home/presentation/cubit/task_cubit_old.dart';
import 'package:tasky_app/features/home/presentation/cubit/task_state_old.dart';
import 'package:tasky_app/core/resources/color_manager.dart';
import 'package:tasky_app/core/widgets/CustomDropdownFlexible.dart';
import 'package:tasky_app/core/widgets/default_text_form_field.dart';
import 'package:tasky_app/core/widgets/default_elevated_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasky_app/features/tasks/logic/image_utils.dart';

class EditTaskScreen extends StatefulWidget {
  final String taskId;
  const EditTaskScreen({super.key, required this.taskId});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  String status = "waiting";
  String priority = "medium";
  File? selectedImage;
  bool isPicking = false;
  bool isPriorityFavourite = false;

  bool _initialized = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final cubit = context.read<TaskCubitOld>();
      if (cubit.state.tasks.isEmpty) {
        cubit.fetchTasks();
      }
    });
  }

  Future pickImage() async {
    if (isPicking) return;
    isPicking = true;

    final picker = ImagePicker();
    try {
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() {
          selectedImage = File(picked.path);
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    } finally {
      isPicking = false;
    }
  }

  void _initFromTaskOnce(dynamic task) {
    if (_initialized) return;
    _initialized = true;

    titleController.text = task.title;
    descController.text = task.desc;
    status = task.status.label;
    priority = task.priority.label;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskCubitOld, TaskStateOld>(
      listenWhen: (prev, next) => !_initialized && next.tasks.isNotEmpty,
      listener: (context, state) {
        final task = state.tasks.where((t) => t.id == widget.taskId).isNotEmpty
            ? state.tasks.firstWhere((t) => t.id == widget.taskId)
            : null;

        if (task != null) {
          setState(() {
            _initFromTaskOnce(task);
          });
        }
      },
      builder: (context, state) {
        if (state is TaskLoading && state.tasks.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final task = state.tasks.where((t) => t.id == widget.taskId).isNotEmpty
            ? state.tasks.firstWhere((t) => t.id == widget.taskId)
            : null;

        if (task == null) {
          if (state is! TaskLoading) {
            Future.microtask(() => context.read<TaskCubitOld>().fetchTasks());
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!_initialized) {
          _initFromTaskOnce(task);
        }

        final text = Theme.of(context).textTheme;
        final height = MediaQuery.of(context).size.height;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.backgroundWhite,
            elevation: 0,
            leading: IconButton(
              icon: SvgPicture.asset(
                IconsAssets.arrowLeft,
                width: 24,
                height: 24,
              ),
              onPressed: () => context.pop(),
            ),
            title: Text(
              'Edit Task',
              style: text.titleMedium!.copyWith(color: AppColors.black),
            ),
            centerTitle: false,
            titleSpacing: 0,
          ),
          backgroundColor: AppColors.backgroundWhite,
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Picker
                GestureDetector(
                  onTap: pickImage,
                  child: FutureBuilder<Size>(
                    future: selectedImage != null
                        ? ImageUtils.getLocalImageSize(selectedImage!)
                        : (task.image != null
                              ? ImageUtils.getNetworkImageSize(
                                  task.image!.startsWith("http")
                                      ? task.image!
                                      : "https://todo.iraqsapp.com/images/${task.image!}",
                                )
                              : null),
                    builder: (context, snapshot) {
                      final screenWidth = MediaQuery.of(context).size.width;

                      if (!snapshot.hasData) {
                        return Container(
                          height: 225,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.lightLavender,
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              IconsAssets.add_img,
                              width: 50,
                              height: 50,
                            ),
                          ),
                        );
                      }

                      final imgSize = snapshot.data!;
                      final containerHeight =
                          (imgSize.height / imgSize.width) * screenWidth;

                      final imageProvider = selectedImage != null
                          ? FileImage(selectedImage!)
                          : NetworkImage(
                                  task.image!.startsWith("http")
                                      ? task.image!
                                      : "https://todo.iraqsapp.com/images/${task.image!}",
                                )
                                as ImageProvider;

                      return Container(
                        height: containerHeight,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.lightLavender,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: height * 0.0197),

                Text(
                  'Task Title',
                  style: text.labelSmall!.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: height * 0.009852),
                DefaultTextFormField(
                  controller: titleController,
                  hintText: "Enter title...",
                ),
                SizedBox(height: height * 0.0197),

                Text(
                  'Task Description',
                  style: text.labelSmall!.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: height * 0.009852),
                DefaultTextFormField(
                  controller: descController,
                  hintText: "Enter description...",
                  minLines: 5,
                  maxLines: 15,
                ),
                SizedBox(height: height * 0.0197),

                Text(
                  'Status',
                  style: text.labelSmall!.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: height * 0.009852),
                CustomDropdownFlexible(
                  value: status.toLowerCase(),
                  items: const ["waiting", "in progress", "finished"],
                  textColor: AppColors.primary,
                  onChanged: (val) => setState(() => status = val!),
                ),
                SizedBox(height: height * 0.0197),

                Text(
                  'Priority',
                  style: text.labelSmall!.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: height * 0.009852),
                CustomDropdownFlexible(
                  value: priority.toLowerCase(),
                  items: const ["low", "medium", "high"],
                  textColor: AppColors.primary,
                  prefixWidget: const Icon(
                    Icons.flag_outlined,
                    color: AppColors.primary,
                    size: 22,
                  ),
                  suffixText: "Priority",
                  trailingWidget: Icon(
                    isPriorityFavourite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: AppColors.primary,
                  ),
                  onTrailingTap: () {
                    setState(() => isPriorityFavourite = !isPriorityFavourite);
                  },
                  onChanged: (value) {
                    setState(() => priority = value!);
                  },
                ),
                SizedBox(height: height * 0.0431),

                DefaultElevatedButton(
                  label: "Update Task",
                  textStyle: text.bodyLarge!.copyWith(color: AppColors.white),
                  onPressed: () async {
                    final cubit = context.read<TaskCubitOld>();

                    String? imageUrl = task.image;
                    if (selectedImage != null) {
                      final uploaded = await UploadService().uploadImage(
                        selectedImage!,
                      );
                      if (uploaded != null) imageUrl = uploaded;
                    }

                    final updateModel = UpdateTodoModel(
                      image: imageUrl!,
                      title: titleController.text.trim(),
                      desc: descController.text.trim(),
                      status: status,
                      priority: priority,
                      user: task.user,
                    );

                    try {
                      await cubit.updateTask(task.id, updateModel);
                      await cubit.refreshTasks();
                      if (mounted) context.pop();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Failed to update task")),
                      );
                    }
                  },
                ),
                SizedBox(height: height * 0.0197),
              ],
            ),
          ),
        );
      },
    );
  }
}
