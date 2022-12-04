import 'package:product_buy_sell/util/theme/app_colors.dart';
import 'package:product_buy_sell/util/theme/text.styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType? inputType;
  final TextInputAction? inputAction;
  final Color? fillColor;
  final Color? textColor;
  final String? Function(String?)? validation;
  final String? Function(String?)? onChanged;
  final String? Function(String?)? onSubmited;
  final int? maxLines;
  final bool? isPassword;
  final bool? isCountryPicker;
  final bool? isShowBorder;
  final bool? isIcon;
  final bool? isShowSuffixIcon;
  final bool? isShowSuffixWidget;
  final Widget? suffixWidget;
  final bool? isShowPrefixIcon;
  final VoidCallback? onTap;
  final VoidCallback? onSuffixTap;
  final String? suffixIconUrl;
  final IconData? prefixIconUrl;
  final bool? isSearch;
  final VoidCallback? onSubmit;
  final bool? isEnabled;
  final double? hintFontSize;
  final TextCapitalization? capitalization;
  final double? horizontalSize;
  final double? verticalSize;
  final double? borderRadius;
  final bool? autoFocus;
  final bool? isSaveAutoFillData;
  final bool? isCancelShadow;
  final String? autoFillHints;
  final String? autoFillHints2;

  const CustomTextField(
      {this.hintText = 'Write something...',
      this.controller,
      this.focusNode,
      this.nextFocus,
      this.isEnabled = true,
      this.inputType = TextInputType.text,
      this.inputAction = TextInputAction.next,
      this.maxLines = 1,
      this.hintFontSize = 15,
      this.onSuffixTap,
      this.fillColor,
      this.textColor,
      this.onSubmit,
      this.onChanged,
      this.capitalization = TextCapitalization.none,
      this.isCountryPicker = false,
      this.isShowBorder = false,
      this.isCancelShadow = false,
      this.isShowSuffixIcon = false,
      this.isShowPrefixIcon = false,
      this.onTap,
      this.isIcon = false,
      this.isPassword = false,
      this.suffixIconUrl,
      this.isShowSuffixWidget = false,
      this.suffixWidget,
      this.prefixIconUrl,
      this.autoFillHints = '',
      this.autoFillHints2 = '',
      this.isSearch = false,
      this.autoFocus = false,
      this.isSaveAutoFillData = false,
      this.horizontalSize = 22,
      this.verticalSize = 10,
      this.borderRadius = 9,
      this.onSubmited,
      this.validation,
      Key? key})
      : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.fillColor ?? AppColors.whiteColorLight,
        boxShadow: [
          BoxShadow(
              color: !widget.isCancelShadow! ? colorShadow : Colors.transparent,
              offset: const Offset(0, 0),
              blurRadius: 9,
              spreadRadius: 3)
        ],
        borderRadius: BorderRadius.circular(widget.borderRadius!),
      ),
      child: TextField(
        maxLines: widget.maxLines,
        controller: widget.controller,
        focusNode: widget.focusNode,
        onEditingComplete: () {
          if (widget.isSaveAutoFillData!) TextInput.finishAutofillContext();
        },
        autofillHints: [(widget.autoFillHints!), (widget.autoFillHints2!)],
        style: sfProStyle500Medium.copyWith(fontSize: 16, color: widget.textColor ?? AppColors.primaryColorLight),
        textInputAction: widget.inputAction,
        keyboardType: widget.inputType,
        cursorColor: AppColors.primaryColorLight,
        textCapitalization: widget.capitalization!,
        enabled: widget.isEnabled,
        autofocus: widget.autoFocus!,
        //onChanged: widget.isSearch ? widget.languageProvider.searchLanguage : null,
        obscureText: widget.isPassword! ? _obscureText : false,
        inputFormatters:
            widget.inputType == TextInputType.phone ? <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp('[0-9+]'))] : null,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: widget.verticalSize!, horizontal: widget.horizontalSize!),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius!),
              borderSide: BorderSide(
                  color: widget.isShowBorder! ? CupertinoColors.systemGrey : Colors.transparent, width: widget.isShowBorder! ? 1 : 0)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius!),
              borderSide: BorderSide(
                  color: widget.isShowBorder! ? CupertinoColors.systemGrey : Colors.transparent, width: widget.isShowBorder! ? 1 : 0)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius!),
              borderSide: BorderSide(
                  color: widget.isShowBorder! ? CupertinoColors.systemGrey : Colors.transparent, width: widget.isShowBorder! ? 1 : 0)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius!),
              borderSide: BorderSide(
                  color: widget.isShowBorder! ? CupertinoColors.systemGrey : Colors.transparent, width: widget.isShowBorder! ? 1 : 1)),
          isDense: true,
          hintText: widget.hintText,
          fillColor: widget.fillColor ?? AppColors.whiteColorLight,
          hintStyle: sfProStyle300Light.copyWith(fontSize: widget.hintFontSize, color: widget.textColor ?? AppColors.hintTextColorLight),
          filled: true,
          prefixIcon: widget.isShowPrefixIcon!
              ? Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Icon(widget.prefixIconUrl!, size: 22, color: colorIcons.withOpacity(.88)))
              : null,
          prefixIconConstraints: const BoxConstraints(minWidth: 23, maxHeight: 20),
          suffixIcon: widget.isShowSuffixIcon! && !widget.isShowSuffixWidget!
              ? widget.isPassword!
                  ? InkWell(
                      onTap: _toggle,
                      child: Icon(!_obscureText ? Icons.visibility_off : Icons.visibility, color: colorPrimary, size: 23))
                  : widget.isIcon!
                      ? IconButton(
                          onPressed: widget.onSuffixTap,
                          icon: Image.asset(widget.suffixIconUrl!,
                              width: 15, height: 15, color: Theme.of(context).textTheme.bodyText1!.color),
                        )
                      : null
              : widget.isShowSuffixWidget!
                  ? widget.suffixWidget
                  : null,
        ),
        onSubmitted: (String? text) =>
            widget.nextFocus != null ? FocusScope.of(context).requestFocus(widget.nextFocus) : FocusScope.of(context).unfocus(),
        onChanged: (String? value) {
          if (widget.isSearch!) widget.onChanged!(value);
        },
      ),
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
