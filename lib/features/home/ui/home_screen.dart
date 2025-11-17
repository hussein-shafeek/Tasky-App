import 'package:flutter/material.dart';
import 'package:tasky_app/core/routes/routes.dart';
import 'package:tasky_app/core/theme/app_colors.dart';
import 'package:tasky_app/features/home/ui/home_header.dart';
import 'package:tasky_app/features/tasks/data/models/task_model.dart';
import 'package:tasky_app/features/tasks/ui/task_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // مؤقتًا دي بيانات ثابتة لحد ما نربطها بقاعدة بيانات أو API
  List<TaskModel> tasks = [
    TaskModel(
      id: "1",
      title: "Grocery Shopping App",
      description:
          "This application is designed for super shops. By using this application they can enlist all their products in one place and can deliver. Customers will get a one-stop solution for their daily shopping.",
      endDate: "30/12/2022",
      status: "Waiting",
      priority: "Low",
      progress: 0.2,
      qrImage: "assets/images/qrcode.png",
    ),
    TaskModel(
      id: "2",
      title: "Grocery Shopping App",
      description:
          "This application is designed for super shops. Customers will get a one-stop solution for daily shopping.",
      endDate: "30/12/2022",
      status: "Inprogress",
      priority: "High",
      progress: 0.6,
      qrImage: "assets/images/qrcode.png",
    ),
    TaskModel(
      id: "3",
      title: "Grocery Shopping App",
      description:
          "This application is designed for super shops. By using it they can deliver efficiently.",
      endDate: "30/12/2022",
      status: "Finished",
      priority: "Medium",
      progress: 1.0,
      qrImage: "assets/images/qrcode.png",
    ),
  ];
  String selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    TextTheme text = Theme.of(context).textTheme;

    // فلترة التاسكات حسب التبويب
    List<TaskModel> filteredTasks = selectedCategory == 'All'
        ? tasks
        : tasks.where((t) => t.status == selectedCategory).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      floatingActionButton: SizedBox(
        width: 70,
        height: 140, // مساحة كافية للفاب الأساسي والزِرار العلوي
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            // زرار QR Code فوق الفاب الأساسي
            Positioned(
              bottom: 80,
              right: 7,
              child: RawMaterialButton(
                onPressed: () {
                  print("زرار QR Code اتضغط");
                },
                fillColor: AppColors.lightPurple, // لون الخلفية
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                constraints: const BoxConstraints(
                  minWidth: 50,
                  minHeight: 50,
                  maxWidth: 50,
                  maxHeight: 50,
                ),
                padding: const EdgeInsets.all(13), // padding داخلي حول الأيقونة
                child: Icon(Icons.qr_code, size: 24, color: AppColors.primary),
              ),
            ),
            // الفاب الأساسي +
            RawMaterialButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.addTask),
              fillColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              constraints: const BoxConstraints(
                minWidth: 64,
                minHeight: 64,
                maxWidth: 64,
                maxHeight: 64,
              ),
              padding: const EdgeInsets.all(16), // padding داخلي حول الأيقونة
              child: const Icon(Icons.add, size: 32, color: AppColors.white),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          HomeHeader(
            onCategoryChanged: (selected) {
              setState(() {
                selectedCategory = selected == 'Inpogress'
                    ? 'Inprogress'
                    : selected;
              });
            },
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      AppRoutes.taskDetailsScreen,
                      arguments: task.id, // تمرير الـ taskId فقط
                    );
                  },

                  child: Container(
                    decoration: BoxDecoration(color: AppColors.backgroundWhite),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Image.asset(
                        'assets/images/grocery.png',
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  task.title,
                                  style: text.titleMedium!.copyWith(
                                    color: AppColors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(task.status),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  task.status,
                                  style: text.labelSmall!.copyWith(
                                    color: _getStatusTextColor(task.status),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            task.description,
                            style: text.bodySmall!.copyWith(
                              color: AppColors.black.withValues(alpha: 0.6),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.flag_outlined,
                                size: 16,
                                color: getPriorityColor(task.priority),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                task.priority,
                                style: text.bodySmall!.copyWith(
                                  color: getPriorityColor(task.priority),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                task.endDate,
                                style: text.bodySmall!.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Inprogress':
        return AppColors.lightLavender;
      case 'Waiting':
        return AppColors.pinkLace;
      case 'Finished':
        return AppColors.lightBlueCustom;
      default:
        return AppColors.primary;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case 'Inprogress':
        return AppColors.primary; // لأن الخلفية زرقاء
      case 'Waiting':
        return AppColors.coral; // لأن الخلفية فاتحة
      case 'Finished':
        return AppColors.azureBlue; // أخضر غامق، النص أبيض
      default:
        return Colors.white;
    }
  }

  Color getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return AppColors.coral;
      case 'Medium':
        return AppColors.primary;
      case 'Low':
        return AppColors.azureBlue;
      default:
        return Colors.blue; // لأي قيمة غير متوقعة
    }
  }
}
