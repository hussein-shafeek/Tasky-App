import 'dart:async';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tasky_app/core/utils/image_utils.dart';
import 'package:tasky_app/features/home/data/models/task_model.dart';
import 'package:tasky_app/features/home/presentation/cubit/tasks_cubit.dart';
import 'package:tasky_app/features/home/presentation/cubit/tasks_state.dart';
import 'package:tasky_app/features/home/domain/enums/priority.dart'
    as task_priority;
import 'package:tasky_app/features/home/domain/value_objects/status.dart';
import 'package:tasky_app/core/resources/assets_manager.dart';
import 'package:tasky_app/core/resources/color_manager.dart';
import 'package:tasky_app/core/widgets/CustomDropdownFlexible.dart';
import 'package:tasky_app/core/widgets/default_elevated_button.dart';
import 'package:tasky_app/core/widgets/default_text_form_field.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  File? selectedImage;
  final picker = ImagePicker();
  bool isPicking = false;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String priority = "Medium";
  bool isPriorityFavourite = false;

  bool isValidImage(String path) {
    path = path.toLowerCase();
    return path.endsWith(".jpg") ||
        path.endsWith(".jpeg") ||
        path.endsWith(".png");
  }

  Future pickImage() async {
    if (isPicking) return;
    isPicking = true;

    try {
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );
      if (picked != null) {
        if (!isValidImage(picked.path)) {
          print(" Only JPG/PNG images allowed");
          return;
        }

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
    final text = Theme.of(context).textTheme;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            IconsAssets.arrowLeft,
            width: width * 0.064,
            height: height * 0.02955,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Add New Task",
          style: text.titleMedium!.copyWith(color: AppColors.black),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ▪▪ Add Image Button ▪▪
              if (selectedImage == null)
                FormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a image';
                    }
                    return null;
                  },
                  initialValue: "",
                  builder: (FormFieldState<String> state) {
                    return GestureDetector(
                      onTap: pickImage,
                      behavior: HitTestBehavior.opaque,
                      child: DottedBorder(
                        options: RoundedRectDottedBorderOptions(
                          dashPattern: [2, 2],
                          strokeWidth: 2,
                          radius: Radius.circular(12),
                          color: AppColors.primary,
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                IconsAssets.add_img,
                                height: height * 0.02955,
                                width: width * 0.064,
                              ),
                              SizedBox(width: width * 0.03733),
                              Text(
                                "Add Img",
                                style: text.titleMedium!.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              SizedBox(height: height * 0.0197),

              if (selectedImage != null)
                if (selectedImage != null)
                  FutureBuilder<Size>(
                    future: ImageUtils.getLocalImageSize(selectedImage!),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox(
                          height: 100,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      // final imageSize = snapshot.data!;
                      // final containerHeight =
                      //     (imageSize.height / imageSize.width) *
                      //     MediaQuery.of(context).size.width;

                      return Container(
                        width: double.infinity,
                        height: height * 0.277,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: FileImage(selectedImage!),

                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),

              SizedBox(height: height * 0.0197),
              Text(
                'Task title',
                style: text.labelSmall!.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: height * 0.009852),
              DefaultTextFormField(
                hintText: "Enter title here...",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Title is required";
                  }
                  return null;
                },
                controller: titleController,
              ),

              SizedBox(height: height * 0.022167),
              Text(
                'Task Description',
                style: text.labelSmall!.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: height * 0.009852),
              DefaultTextFormField(
                hintText: "Enter description here...",
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "description is required";
                  }
                  return null;
                },
                controller: descriptionController,
                minLines: 6,
                maxLines: 15,
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
                value: priority,
                items: const ["Low", "Medium", "High"],
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

              SizedBox(height: height * 0.0197),
              Text(
                'Due date',
                style: text.labelSmall!.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: height * 0.009852),
              DefaultTextFormField(
                hintText: "choose due date...",
                controller: dateController,
                readOnly: true,
                suffixIcon: SvgPicture.asset(
                  "assets/icons/calendar.svg",
                  width: width * 0.064,
                  height: height * 0.02955,
                  fit: BoxFit.scaleDown,
                ),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2050),
                  );
                  if (picked != null) {
                    dateController.text =
                        "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                  }
                },
              ),

              SizedBox(height: height * 0.0431),

              BlocConsumer<TasksCubit, TaskState>(
                listener: (context, state) {
                  if (state is AddTaskSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Task added successfully"),
                        backgroundColor: AppColors.green,
                      ),
                    );

                    Navigator.pop(context);
                  }

                  if (state is AddTaskError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: AppColors.coral,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return DefaultElevatedButton(
                    label: "Add Task",
                    textStyle: text.bodyLarge!.copyWith(color: AppColors.white),
                    isLoading: state is AddTaskLoading,
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) return;
                      if (selectedImage == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please select an image"),
                            backgroundColor: AppColors.coral,
                          ),
                        );
                        return;
                      }

                      final task = TaskModel(
                        id: "", // ID will be generated by backend
                        title: titleController.text.trim(),
                        desc: descriptionController.text.trim(),
                        priority: task_priority.Priority.fromName(
                          priority.toLowerCase(),
                        ),
                        status: const Waiting(),
                        user:
                            "", // User ID will be handled by backend or updated there
                        createdAt: dateController.text.isNotEmpty
                            ? DateTime.parse(dateController.text)
                            : DateTime.now(),
                        updatedAt: DateTime.now(),
                      );

                      context.read<TasksCubit>().addTask(
                        task,
                        image: selectedImage!,
                      );
                    },
                  );
                },
              ),
              SizedBox(height: height * 0.02463),
            ],
          ),
        ),
      ),
    );
  }
}
