import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tasky_app/core/resources/ui_extensions.dart';
import 'package:tasky_app/core/resources/values_manager.dart';
import 'package:tasky_app/core/routes/routes_name.dart';
import 'package:tasky_app/core/utils/ui_utils.dart';
import 'package:tasky_app/core/utils/validator.dart';
import 'package:tasky_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:tasky_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:tasky_app/features/auth/presentation/widgets/register_widgets/register_header.dart';
import 'package:tasky_app/features/auth/presentation/widgets/register_widgets/register_fields.dart';
import 'package:tasky_app/features/auth/presentation/widgets/register_widgets/register_button.dart';
import 'package:tasky_app/features/auth/presentation/widgets/register_widgets/register_footer.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();
  final _experienceYearsController = TextEditingController();
  final _experienceLevelController = TextEditingController();
  final _phoneFocusNode = FocusNode();
  String fullPhone = '';
  String? phoneError;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          context.go(Routes.homeScreen);
        } else if (state is RegisterError) {
          UIUtils.showMessage(state.message);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: 24.5.pHorizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RegisterHeader(),
                  SizedBox(height: Insets.s20.h),
                  RegisterFields(
                    nameController: _nameController,
                    phoneController: _phoneController,
                    phoneFocusNode: _phoneFocusNode,
                    passwordController: _passwordController,
                    addressController: _addressController,
                    experienceYearsController: _experienceYearsController,
                    experienceLevelController: _experienceLevelController,
                    fullPhoneSetter: (phone) =>
                        setState(() => fullPhone = phone),
                    phoneError: phoneError,
                    setPhoneError: (e) => setState(() => phoneError = e),
                  ),
                  SizedBox(height: Insets.s20.h),
                  RegisterButton(
                    formKey: _formKey,
                    nameController: _nameController,
                    phoneController: _phoneController,
                    passwordController: _passwordController,
                    addressController: _addressController,
                    experienceYearsController: _experienceYearsController,
                    experienceLevelController: _experienceLevelController,
                    fullPhone: fullPhone,
                    onValidatePhone: _validatePhone,
                  ),
                  SizedBox(height: Insets.s20.h),
                  const RegisterFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _validatePhone() {
    final result = Validator.validatePhoneNumberField(_phoneController.text);
    setState(() => phoneError = result);
    return result == null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    _experienceYearsController.dispose();
    _experienceLevelController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }
}
