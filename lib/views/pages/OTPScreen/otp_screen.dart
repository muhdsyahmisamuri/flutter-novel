import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kacs/models/view_model_user.dart';
import 'package:kacs/utils/utils.dart';
import 'package:kacs/views/pages/SignInScreen/controller/sign_in_controller.dart';

import 'package:pinput/pinput.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  @override
  Widget build(BuildContext context) {
    // final otp = Get.arguments['otp'];
    final UserLoginData userDetails = Get.arguments['userDetails'];

    return Scaffold(
      body: SafeArea(
        child: FractionallySizedBox(
          widthFactor: 1,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 64, 24, 24),
            child: Column(
              children: [
                OtpHeader(
                  userDetails: userDetails,
                ),
                OTPPin(
                  otp: userDetails.otp,
                  user: userDetails.user,
                ),
                const SizedBox(height: 44),
                Text(
                  'Didn’t receive code?',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: const Color.fromRGBO(62, 116, 165, 1),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    await Utils.showToast(userDetails.otp, sec: 7);
                    // final signInController = Get.put(SignInController());
                    // signInController.emailController.value.text = userDetails.user.email;
                    // await signInController.loginApi();
                  },
                  child: Text(
                    'Resend',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                      color: const Color.fromRGBO(62, 116, 165, 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OtpHeader extends StatelessWidget {
  const OtpHeader({super.key, required this.userDetails});

  final UserLoginData userDetails;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Verification',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: const Color.fromRGBO(30, 60, 87, 1),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Enter the code sent to the number',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: const Color.fromRGBO(133, 153, 170, 1),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          userDetails.user.phoneNumber,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: const Color.fromRGBO(30, 60, 87, 1),
          ),
        ),
        const SizedBox(height: 64),
      ],
    );
  }
}

class OTPPin extends StatefulWidget {
  const OTPPin({super.key, required this.otp, required this.user});

  final String otp;
  final ViewModelUser user;

  @override
  State<OTPPin> createState() => _OTPPinState();
}

class _OTPPinState extends State<OTPPin> {
  late final TextEditingController pinController;

  late final FocusNode focusNode;

  late final GlobalKey<FormState> formKey;

  final getBox = GetStorage();

  @override
  void initState() {
    super.initState();

    formKey = GlobalKey<FormState>();
    pinController = TextEditingController();
    focusNode = FocusNode();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (mounted) {
    //     Utils.showToast(widget.otp, sec: 5);
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    int length = widget.otp.length;

    const borderColor = Color.fromRGBO(114, 178, 238, 1);
    const errorColor = Color.fromRGBO(255, 234, 238, 1);
    const fillColor = Color.fromRGBO(222, 231, 240, .57);
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: GoogleFonts.poppins(
        fontSize: 22,
        color: const Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );

    return SizedBox(
      child: Pinput(
        length: length,
        controller: pinController,
        focusNode: focusNode,
        defaultPinTheme: defaultPinTheme,
        hapticFeedbackType: HapticFeedbackType.lightImpact,
        validator: (value) {
          return value == widget.otp ? 'Pin is correct' : 'Pin is incorrect';
        },
        onCompleted: (pin) async {
          debugPrint('onCompleted: $pin');
          if (pin == widget.otp) {
            getBox.write('userData', widget.user.toJson());
            // FocusManager.instance.primaryFocus?.unfocus();
            // await Future.delayed(const Duration(seconds: 1));
            Get.offAllNamed('/home');
            await Utils.showToast('Login successful');
          }
        },
        onChanged: (value) {
          debugPrint('onChanged: $value');
        },
        focusedPinTheme: defaultPinTheme.copyWith(
          height: 68,
          width: 64,
          decoration: defaultPinTheme.decoration!.copyWith(
            border: Border.all(color: borderColor),
          ),
        ),
        errorPinTheme: defaultPinTheme.copyWith(
          decoration: BoxDecoration(
            color: errorColor,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
