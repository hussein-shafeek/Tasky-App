import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tasky_app/core/models/update_model.dart';
import 'package:tasky_app/core/providers/task_provider.dart';
import 'package:tasky_app/core/services/upload_service.dart';
import 'package:tasky_app/core/theme/app_colors.dart';
import 'package:tasky_app/core/utils/CustomDropdownFlexible.dart';
import 'package:tasky_app/core/utils/default_text_form_field.dart';
import 'package:tasky_app/core/utils/default_elevated_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasky_app/features/tasks/logic/image_utils.dart';

class EditTaskScreen extends StatefulWidget {
  final String taskId;
  const EditTaskScreen({super.key, required this.taskId});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  String status = "waiting";
  String priority = "medium";
  File? selectedImage;
  bool isPicking = false;
  bool isPriorityFavourite = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final task = context.read<TaskProvider>().getTaskById(widget.taskId);

      if (task != null) {
        titleController.text = task.title;
        descController.text = task.desc;

        status = task.status;
        priority = task.priority;
      } else {
        context.read<TaskProvider>().fetchTasks();
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
      print("Error picking image: $e");
    } finally {
      isPicking = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();

    if (taskProvider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (taskProvider.tasks.isEmpty) {
      Future.microtask(() {
        context.read<TaskProvider>().fetchTasks();
      });

      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final task = taskProvider.getTaskById(widget.taskId);

    if (task == null) {
      return const Scaffold(body: Center(child: Text("Task not found")));
    }

    final text = Theme.of(context).textTheme;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/ArrowLeft.svg',
            width: 24,
            height: 24,
          ),
          onPressed: () => Navigator.pop(context),
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
                          "assets/icons/add_img.svg",
                          width: 50,
                          height: 50,
                        ),
                      ),
                    );
                  }

                  final imgSize = snapshot.data!;
                  final double containerHeight =
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

            // Title
            Text(
              'Task Title',
              style: text.labelSmall!.copyWith(color: AppColors.textSecondary),
            ),
            SizedBox(height: height * 0.009852),
            DefaultTextFormField(
              controller: titleController!,
              hintText: "Enter title...",
            ),
            SizedBox(height: height * 0.0197),

            // Description
            Text(
              'Task Description',
              style: text.labelSmall!.copyWith(color: AppColors.textSecondary),
            ),
            SizedBox(height: height * 0.009852),
            DefaultTextFormField(
              controller: descController!,
              hintText: "Enter description...",
              minLines: 5,
              maxLines: 15,
            ),
            SizedBox(height: height * 0.0197),

            // Status Dropdown
            Text(
              'Status',
              style: text.labelSmall!.copyWith(color: AppColors.textSecondary),
            ),
            SizedBox(height: height * 0.009852),
            CustomDropdownFlexible(
              value: status,
              items: const ["waiting", "inprogress", "finished"],
              textColor: AppColors.primary,
              onChanged: (val) => setState(() => status = val!),
            ),
            SizedBox(height: height * 0.0197),

            Text(
              'Priority',
              style: text.labelSmall!.copyWith(color: AppColors.textSecondary),
            ),
            SizedBox(height: height * 0.009852),
            CustomDropdownFlexible(
              value: priority,
              items: const ["low", "medium", "high"],
              textColor: AppColors.primary,

              prefixWidget: const Icon(
                Icons.flag_outlined,
                color: AppColors.primary,
                size: 22,
              ),

              suffixText: "Priority",

              trailingWidget: Icon(
                isPriorityFavourite ? Icons.favorite : Icons.favorite_border,
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
                String? imageUrl = task.image;
                if (selectedImage != null) {
                  final uploaded = await UploadService().uploadImage(
                    selectedImage!,
                  );
                  if (uploaded != null) imageUrl = uploaded;
                }

                final updateModel = UpdateTodoModel(
                  image: imageUrl!,
                  title: titleController!.text.trim(),
                  desc: descController!.text.trim(),
                  status: status,
                  priority: priority,
                  user: task.user,
                );

                try {
                  print("Updating task...");
                  await taskProvider.updateTask(task.id, updateModel);
                  print("Task updated successfully!");
                  await taskProvider.refreshTasks();
                  Navigator.pop(context);
                } catch (e) {
                  print("Error updating task: $e");
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
  }
}
