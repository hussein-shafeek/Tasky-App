// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:provider/provider.dart';

// // ignore: must_be_immutable
// class DefaultTextFormField extends StatefulWidget {
//   String hintText;
//   TextEditingController? controller;
//   void Function(String)? onChanged;
//   String? prefixIconImageName;
//   String? Function(String?)? validator;
//   bool isPassword;

//   DefaultTextFormField({
//     super.key,
//     required this.hintText,
//     this.controller,
//     this.onChanged,
//     this.prefixIconImageName,
//     this.validator,
//     this.isPassword = false,
//   });

//   @override
//   State<DefaultTextFormField> createState() => _DefaultTextFormFieldState();
// }

// class _DefaultTextFormFieldState extends State<DefaultTextFormField> {
//   late bool isObscure = widget.isPassword;
//   @override
//   Widget build(BuildContext context) {
//    return TextFormField(
//       controller: widget.controller,
//       onChanged: widget.onChanged,
//       style: Theme.of(context).textTheme.titleMedium,
//       decoration: InputDecoration(
//         hintText: widget.hintText,
//         prefixIcon:
//             widget.prefixIconImageName == null
//                 ? null
//                 : SvgPicture.asset(
//                   'assets/icons/${widget.prefixIconImageName}.svg',
//                   colorFilter: ColorFilter.mode(
//                     settingProvider.isDark ? AppColors.white : AppColors.gray,
//                     BlendMode.srcIn,
//                   ),

//                   height: 24,
//                   width: 24,
//                   fit: BoxFit.scaleDown,
//                 ),
//         suffixIcon:
//             widget.isPassword
//                 ? IconButton(
//                   onPressed: () {
//                     isObscure = !isObscure;
//                     setState(() {});
//                   },
//                   icon: Icon(
//                     isObscure
//                         ? Icons.visibility_off_outlined
//                         : Icons.visibility_outlined,
//                     color:
//                         settingProvider.isDark
//                             ? AppColors.white
//                             : AppColors.gray,
//                   ),
//                 )
//                 : null,
//       ),
//       validator: widget.validator,
//       obscureText: isObscure,
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
//     );
//   }
// }
