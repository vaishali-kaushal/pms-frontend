import 'package:performance_management_system/pms.dart';

void toastMsg(String msg, {gravity = ToastGravity.CENTER}) {
  Fluttertoast.showToast(msg: msg, gravity: gravity, timeInSecForIosWeb: 4);
}

void showSubmissionDialog({
  required BuildContext context,
  required String message,
  required VoidCallback onPressed,
  String buttonText = "OK",
  Color buttonColor = Colors.green,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(buttonText, style: const TextStyle(color: Colors.white)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}


void showErrorDialog({
  required BuildContext context,
  required String message,
  String buttonText = "OK",
  Color buttonColor = Colors.red,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.alertCircle, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(buttonText, style: const TextStyle(color: Colors.white)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}


OutlineInputBorder outlineInputBorder(Color borderColor) => OutlineInputBorder(
  borderRadius: const BorderRadius.all(Radius.circular(10)),
  // borderSide: BorderSide(color: Color(0XFF898989)),
  borderSide: BorderSide(color: borderColor),
);

typedef DropdownCallback = void Function(String? value, String? text);

class ErrorText extends StatelessWidget {
  final String? errorText;

  const ErrorText({super.key, this.errorText});

  @override
  Widget build(BuildContext context) {
    if ((errorText ?? '').isEmpty) {
      return const SizedBox();
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 3.0),
        child: Text(
          errorText ?? "",
          style: styleW500S14.copyWith(color: ColorRes.appRedColor),
        ),
      );
    }
  }
}

class CommonTextField extends StatelessWidget {
  final String? heading;
  final TextEditingController? controller;
  final TextEditingController? contryCodeController;
  final String? hintText;
  final Widget? suffixIcon;
  final VoidCallback? onSuffixTap;
  final VoidCallback? onTap;
  bool secureText;
  bool isNumberOnly;
  TextInputType? textInputType;
  bool isMobileNumber;
  bool isOtp;
  String errorText;
  final int maxLines;
  final bool isEnabled;
  final bool isReadOnly;
  final Function(String)? onChanged;
  final bool showCountry;
  bool isPersonName;
  bool isOnlyNumber;

  CommonTextField({
    Key? key,
    this.isEnabled = true,
    this.isReadOnly = false,
    this.secureText = false,
    this.maxLines = 1,
    this.textInputType,
    this.isMobileNumber = false,
    this.isOtp = false,
    this.heading,
    this.isNumberOnly = false,
    this.controller,
    this.contryCodeController,
    this.hintText,
    this.suffixIcon,
    this.errorText = "",
    this.onSuffixTap,
    this.onTap,
    this.onChanged,
    this.showCountry = false,
    this.isPersonName = false,
    this.isOnlyNumber = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (heading != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              heading ?? "",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
        InkWell(
          onTap: onTap,
          child: Container(
            // Removed fixed height to allow dynamic height
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: ColorRes.greyColor),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: maxLines > 1 ? 12.0 : 0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: textInputType,
                    inputFormatters: [
                      if (isNumberOnly) FilteringTextInputFormatter.digitsOnly,
                      if (isMobileNumber) LengthLimitingTextInputFormatter(10),
                      if (isOtp) LengthLimitingTextInputFormatter(6),
                      if (isPersonName) LengthLimitingTextInputFormatter(15),
                      if (isOnlyNumber) FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                    ],
                    obscureText: secureText,
                    obscuringCharacter: '*',
                    controller: controller,
                    onChanged: onChanged,
                    enabled: isEnabled,
                    readOnly: isReadOnly,
                    textAlignVertical: TextAlignVertical.top, // Aligns text to top
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    cursorColor: Colors.black,
                    maxLines: maxLines,
                    minLines: maxLines, // Ensures height for multi-line
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hintText,
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: ColorRes.greyColor,
                      ),
                      suffixIcon: suffixIcon != null
                          ? InkWell(
                        onTap: onSuffixTap,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: suffixIcon,
                        ),
                      )
                          : null,
                      suffixIconConstraints: const BoxConstraints(
                        maxWidth: 35,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (errorText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              errorText,
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}

class CommonDropDownContainer extends StatelessWidget {
  final Function(String?) onChanged;
  final List<String> dropDownList;
  final String? dropDownValue;
  final String hintText;

  const CommonDropDownContainer({
    Key? key,
    required this.onChanged,
    required this.dropDownList,
    required this.dropDownValue,
    this.hintText = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: Get.width,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ColorRes.greyColor),
      ),
      child: DropdownButtonHideUnderline(
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,  // Remove splash effect
            highlightColor: Colors.transparent,  // Remove highlight effect
          ),
          child: DropdownButton<String>(
            value: dropDownValue,
            hint: Text(
              hintText,
              style: styleW400S14.copyWith(color: ColorRes.greyColor),
            ),
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: ColorRes.black,
            ),
            items: dropDownList.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Text(
                  items,
                  style: styleW400S14.copyWith(color: ColorRes.black),
                ),
              );
            }).toList(),
            dropdownColor: ColorRes.white,
            borderRadius: BorderRadius.circular(10),
            isExpanded: true,
            isDense: true,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}

InputDecoration buildInputDecoration({
  required String labelText,
  String? errorText,
  Widget? suffixIcon,
}) {
  return InputDecoration(
    labelText: labelText,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    errorText: errorText,
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 2),
      borderRadius: BorderRadius.circular(8),
    ),
    suffixIcon: suffixIcon,
    alignLabelWithHint: true,
  );
}

class CommonTextFormField extends StatelessWidget {
  final String label;
  final String? value;
  final String? errorText;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String> onChanged;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final int minLines;

  const CommonTextFormField({
    super.key,
    required this.label,
    required this.onChanged,
    this.value,
    this.errorText,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.sentences,
    this.inputFormatters,
    this.maxLines = 1,
    this.minLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      textAlignVertical: TextAlignVertical.top,
      decoration: buildInputDecoration(
        labelText: label,
        errorText: errorText,
      ),
      style: styleW400S14,
      onChanged: onChanged,
      validator: validator,
      maxLines: maxLines,
      minLines: maxLines,
    );
  }
}

class ReadOnlyTextDisplay extends StatelessWidget {
  final String title;
  final String value;

  const ReadOnlyTextDisplay({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: styleW600S14),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              value.isNotEmpty ? value : '-',
              style: styleW400S14,
            ),
          ),
        ],
      ),
    );
  }
}
