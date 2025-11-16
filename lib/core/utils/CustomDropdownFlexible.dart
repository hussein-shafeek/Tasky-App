import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tasky_app/core/theme/app_colors.dart';

class CustomDropdownFlexible extends StatelessWidget {
  final String value;
  final List<String> items;
  final Color textColor;
  final Function(String?) onChanged;

  final String? labelInside;
  final String? svgTrailingAsset;
  final Widget? trailingWidget;
  final VoidCallback? onTrailingTap;
  final Widget? prefixWidget;
  final String? suffixText; // هنا كلمة Priority

  const CustomDropdownFlexible({
    super.key,
    required this.value,
    required this.items,
    required this.textColor,
    required this.onChanged,
    this.labelInside,
    this.svgTrailingAsset,
    this.trailingWidget,
    this.onTrailingTap,
    this.prefixWidget,
    this.suffixText,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    Widget buildSelectedChild(String text) {
      return Row(
        children: [
          if (prefixWidget != null) ...[
            prefixWidget!,
            const SizedBox(width: 14),
          ],

          // القيمة (Low, Medium, High)
          Expanded(
            child: Text(
              "$text ${suffixText ?? ""}", // ← هنا ركبنا priority بعد القيمة
              style: textTheme.titleMedium!.copyWith(color: textColor),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.lightLavender,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (labelInside != null) ...[
            Row(
              children: [
                SizedBox(width: 24),
                Text(
                  labelInside!,

                  style: textTheme.labelSmall!.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],

          Row(
            children: [
              SizedBox(width: 24),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: value,
                    isExpanded: true,
                    icon: const SizedBox.shrink(),
                    onChanged: onChanged,
                    borderRadius: BorderRadius.circular(12),
                    items: items
                        .map(
                          (item) => DropdownMenuItem(
                            value: item,
                            child: buildSelectedChild(item),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              if (svgTrailingAsset != null)
                Padding(
                  padding: const EdgeInsets.only(right: 13),
                  child: SvgPicture.asset(
                    svgTrailingAsset!,
                    width: 24,
                    height: 24,
                  ),
                )
              else if (trailingWidget != null)
                Padding(
                  padding: const EdgeInsets.only(right: 13),
                  child: GestureDetector(
                    onTap: onTrailingTap,
                    child: trailingWidget,
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(right: 13),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.primary,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
