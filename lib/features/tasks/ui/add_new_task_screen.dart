import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
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

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  String priority = "Medium";
  bool isPriorityFavourite = false;

  Future pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
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
        titleSpacing: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add Img Button (+ SVG)
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
                height: 180,
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

            // Task Title
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

            // Task Description
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

            // Priority Dropdown
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
                color: isPriorityFavourite
                    ? AppColors.primary
                    : AppColors.primary,
                size: 22,
              ),
              onTrailingTap: () {
                setState(() {
                  isPriorityFavourite = !isPriorityFavourite;
                });
              },
              onChanged: (value) {
                setState(() {
                  priority = value!;
                });
              },
            ),

            SizedBox(height: height * 0.0197),
            // Due Date
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

            // Add Task Button
            DefaultElevatedButton(
              label: "Add Task",
              textStyle: text.bodyLarge,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

            SizedBox(height: height * 0.02463),
          ],
        ),
      ),
    );
  }
}
