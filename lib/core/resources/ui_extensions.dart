import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// ================= Padding =================
extension PaddingExtension on num {
  EdgeInsets get pLeft => EdgeInsets.only(left: w);
  EdgeInsets get pRight => EdgeInsets.only(right: w);
  EdgeInsets get pTop => EdgeInsets.only(top: h);
  EdgeInsets get pBottom => EdgeInsets.only(bottom: h);

  EdgeInsets get pAll => EdgeInsets.all(w);
  EdgeInsets get pHorizontal => EdgeInsets.symmetric(horizontal: w);
  EdgeInsets get pVertical => EdgeInsets.symmetric(vertical: h);
}

/// ================= Margin =================

extension MarginExtension on num {
  EdgeInsets get mLeft => EdgeInsets.only(left: w);
  EdgeInsets get mRight => EdgeInsets.only(right: w);
  EdgeInsets get mTop => EdgeInsets.only(top: h);
  EdgeInsets get mBottom => EdgeInsets.only(bottom: h);

  EdgeInsets get mAll => EdgeInsets.all(w);
  EdgeInsets get mHorizontal => EdgeInsets.symmetric(horizontal: w);
  EdgeInsets get mVertical => EdgeInsets.symmetric(vertical: h);
}

// extension InsetsVH on num {
//   /// Padding: vertical = this , horizontal = hValue
//   EdgeInsets pVH(num hValue) =>
//       EdgeInsets.symmetric(vertical: h, horizontal: hValue.w);

//   /// Margin: vertical = this , horizontal = hValue
//   EdgeInsets mVH(num hValue) =>
//       EdgeInsets.symmetric(vertical: h, horizontal: hValue.w);
// }
extension InsetsVH on num {
  /// Padding: vertical = this , horizontal = hValue
  EdgeInsets pVH(num horizontal) =>
      EdgeInsets.symmetric(vertical: h, horizontal: horizontal.w);

  /// Margin: vertical = this , horizontal = hValue
  EdgeInsets mVH(num horizontal) =>
      EdgeInsets.symmetric(vertical: h, horizontal: horizontal.w);
}

// ================= border radius =================

extension BorderRadiusExtension on num {
  BorderRadius get brAll => BorderRadius.circular(this.r);

  BorderRadius get brTop => BorderRadius.only(
    topLeft: Radius.circular(this.r),
    topRight: Radius.circular(this.r),
  );

  BorderRadius get brBottom => BorderRadius.only(
    bottomLeft: Radius.circular(this.r),
    bottomRight: Radius.circular(this.r),
  );

  BorderRadius brOnly({
    double topLeft = 0,
    double topRight = 0,
    double bottomLeft = 0,
    double bottomRight = 0,
  }) {
    return BorderRadius.only(
      topLeft: Radius.circular(topLeft.r),
      topRight: Radius.circular(topRight.r),
      bottomLeft: Radius.circular(bottomLeft.r),
      bottomRight: Radius.circular(bottomRight.r),
    );
  }
}
