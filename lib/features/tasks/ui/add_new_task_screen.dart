// Import existing packages
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tasky_app/core/models/add_task_model.dart';
import 'package:tasky_app/core/providers/task_provider.dart';
import 'package:tasky_app/core/services/upload_service.dart';
import 'package:tasky_app/core/theme/app_colors.dart';
import 'package:tasky_app/core/utils/CustomDropdownFlexible.dart';
import 'package:tasky_app/core/utils/default_elevated_button.dart';
import 'package:tasky_app/core/utils/default_text_form_field.dart';

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
      final picked = await picker.pickImage(source: ImageSource.gallery);
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
            'assets/icons/ArrowLeft.svg',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ▪▪ Add Image Button ▪▪
            GestureDetector(
              onTap: pickImage,
              child: DottedBorder(
                options: RoundedRectDottedBorderOptions(
                  dashPattern: [2, 2],
                  strokeWidth: 2,
                  radius: Radius.circular(12),
                  color: AppColors.primary,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/add_img.svg",
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
            ),
            SizedBox(height: height * 0.0197),

            if (selectedImage != null)
              Container(
                height: 225,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: FileImage(selectedImage!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            SizedBox(height: height * 0.0197),
            Text(
              'Task title',
              style: text.labelSmall!.copyWith(color: AppColors.textSecondary),
            ),
            SizedBox(height: height * 0.009852),
            DefaultTextFormField(
              hintText: "Enter title here...",
              controller: titleController,
            ),

            SizedBox(height: height * 0.022167),
            Text(
              'Task Description',
              style: text.labelSmall!.copyWith(color: AppColors.textSecondary),
            ),
            SizedBox(height: height * 0.009852),
            DefaultTextFormField(
              hintText: "Enter description here...",
              controller: descriptionController,
              minLines: 6,
              maxLines: 15,
            ),

            SizedBox(height: height * 0.0197),
            Text(
              'Priority',
              style: text.labelSmall!.copyWith(color: AppColors.textSecondary),
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
              style: text.labelSmall!.copyWith(color: AppColors.textSecondary),
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
                      "${picked.year}-${picked.month}-${picked.day}";
                }
              },
            ),

            SizedBox(height: height * 0.0431),
            DefaultElevatedButton(
              label: "Add Task",
              textStyle: text.bodyLarge,
              onPressed: () async {
                // 1) Validate Image
                if (selectedImage == null) {
                  print("No image selected");
                  return;
                }

                if (!isValidImage(selectedImage!.path)) {
                  print("Only JPG/PNG images allowed");
                  return;
                }

                //  Upload Image
                final uploadService = UploadService();

                final uploadedImageFilename = await uploadService.uploadImage(
                  selectedImage!,
                );

                if (uploadedImageFilename == null) {
                  print("Upload failed");
                  return;
                }

                //Build CreateTodoModel
                final createModel = CreateTodoModel(
                  image: uploadedImageFilename,
                  title: titleController.text.trim(),
                  desc: descriptionController.text.trim(),
                  priority: priority.toLowerCase(),
                  dueDate: dateController.text.trim(),
                );

                final taskProvider = Provider.of<TaskProvider>(
                  context,
                  listen: false,
                );
                print("CREATE MODEL: ${createModel.toJson()}");

                try {
                  await taskProvider.addTask(createModel);

                  final addedTask = taskProvider.tasks.isNotEmpty
                      ? taskProvider.tasks.last
                      : null;

                  Navigator.pop(context, addedTask);
                } catch (e) {
                  print("Failed to add task: $e");
                }
              },
            ),
            SizedBox(height: height * 0.02463),
          ],
        ),
      ),
    );
  }
}
