import 'package:flutter/material.dart';

class OtpTextField extends StatefulWidget {
  @override
  _OtpTextFieldState createState() => _OtpTextFieldState();
}

class _OtpTextFieldState extends State<OtpTextField> {
  List<TextEditingController> _otpControllers = List.generate(4, (index) => TextEditingController());
  List<FocusNode> _otpFocusNodes = List.generate(4, (index) => FocusNode());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          4,
              (index) => buildOtpDigit(index + 1, _otpControllers[index], _otpFocusNodes[index]),
        ),
      ),
    );
  }

  Widget buildOtpDigit(int digitIndex, TextEditingController controller, FocusNode focusNode) {
    return Container(
      width: 50.0,
      height: 50.0,
      margin: EdgeInsets.symmetric(horizontal: 3.0), // Add horizontal margin
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20.0),
          maxLength: 1,
          onChanged: (value) {
            // Move focus to the next input field when a digit is entered
            if (value.isNotEmpty) {
              focusNode.nextFocus();
            } else {
              // Handle backspace logic when the value is empty
              focusNode.previousFocus();
            }
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            counterText: "", // Hide the character count
          ),
        ),
      ),
    );
  }
}
