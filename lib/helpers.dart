import 'package:africhange_test/sizeConfig.dart';
import 'package:flutter/material.dart';

// fixer access key
const ACCES_KEY = "9273072046f8da773a553197037be51a";

// primary and secondary colors
const greencol = Color(0xff84eccb);
const bluecol = Color(0xff0374fb);

double calculateSize(double size) {
  var val = size / 8.53;
  return val * SizeConfig.heightMultiplier!;
}

// margin for each screen/page
final pageMargin = EdgeInsets.only(
  left: calculateSize(28),
  right: calculateSize(28),
  top: calculateSize(20),
  //bottom: calculatefontSize(20),
);

// custom text
Widget appText(String tx, double size,
    {FontWeight weight = FontWeight.w500,
    topmargin = 0.0,
    bottommargin = 0.0,
    leftmargin = 0.0,
    rightmargin = 0.0,
    TextAlign align = TextAlign.center,
    Color color = bluecol,
    double? space,
    bool softwrap = true,
    TextOverflow? overflow,
    FontStyle fontStyle = FontStyle.normal}) {
  return Container(
    margin: EdgeInsets.only(
        top: calculateSize(topmargin),
        bottom: calculateSize(bottommargin),
        left: calculateSize(leftmargin),
        right: calculateSize(rightmargin)),
    child: Text(
      tx == null ? "" : tx,
      softWrap: softwrap,
      overflow: overflow,
      textAlign: align,
      style: TextStyle(
        fontSize: calculateSize(size),
        fontWeight: weight,
        fontStyle: fontStyle,
        color: color,
        letterSpacing: space,
      ),
    ),
  );
}

//custom textfield
class AppTextFieldWidget extends StatelessWidget {
  final bool obscureText;
  final obscureTextcharacter;
  final textInputType;
  final labelText;
  final Function(String?)? fxsavedValue;
  final String? Function(String?)? fx;
  final String? initval;
  final String? sufixT;
  final enabled;
  final trailingButton;
  final prefixText;
  final controller;
  final focusNode;
  final maxLines;

  AppTextFieldWidget({
    this.labelText = "",
    this.enabled = true,
    this.obscureText = false,
    this.initval,
    this.textInputType = TextInputType.text,
    this.fxsavedValue,
    this.fx,
    this.sufixT,
    this.maxLines = 1,
    this.obscureTextcharacter = "*",
    this.trailingButton,
    this.prefixText,
    this.controller,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        appText(labelText, 16, topmargin: 20.0),
        Container(
          color: Color(0xfffafafa).withOpacity(0.5),
          //margin: EdgeInsets.symmetric(horizontal: calculatefontSize(5)),
          child: TextFormField(
              enabled: enabled,
              initialValue: initval,
              controller: controller,
              focusNode: focusNode,
              obscureText: obscureText,
              obscuringCharacter: "*",
              maxLines: maxLines,
              keyboardType: textInputType,
              textInputAction: TextInputAction.next,
              style: TextStyle(
                  //fontWeight: FontWeight.bold,
                  fontSize: calculateSize(17),
                  color: Colors.grey),
              decoration: InputDecoration(
                suffixIcon: trailingButton,
                suffixText: sufixT,
                prefixText: prefixText,
                errorMaxLines: 3,
                isDense: true,
                //labelText: labelText,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffC4C4C4)),
                    borderRadius: BorderRadius.circular(5)),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffC4C4C4)),
                    borderRadius: BorderRadius.circular(5)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffC4C4C4)),
                    borderRadius: BorderRadius.circular(5)),
              ),
              onSaved: fxsavedValue,
              validator: fx),
        )
      ],
    );
  }
}
