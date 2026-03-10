// import 'package:flutter/material.dart';
// import '../extensions/extension_util/int_extensions.dart';
// import '../extensions/extension_util/string_extensions.dart';
// import '../extensions/extension_util/widget_extensions.dart';
// import '../extensions/text_styles.dart';
// import '../utils/colors.dart';
// import '../models/dashBoard_response.dart';
//
// class FilterDropDownComponents extends StatefulWidget {
//   FilterDropDownComponents({super.key, required this.itemList, required this.title, required this.onPressed, this.propertyType});
//
//   List<String> itemList = [];
//   final String title;
//   final ValueChanged<Object> onPressed;
//   List<PropertyType>? propertyType = [];
//
//   @override
//   State<FilterDropDownComponents> createState() => _FilterDropDownComponentsState();
// }
//
// class _FilterDropDownComponentsState extends State<FilterDropDownComponents> {
//   var dropDownValue;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.start,
//       mainAxisSize: MainAxisSize.max,
//       children: [
//         Text(
//           widget.title,
//           style: boldTextStyle(color: primaryColor),
//         ),
//         10.height,
//         TextField(
//           decoration: InputDecoration(
//             border: OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
//             focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
//             suffixIcon: DropdownButtonFormField(
//               decoration: InputDecoration(enabledBorder: InputBorder.none, focusedBorder: InputBorder.none),
//               value: dropDownValue,
//               onChanged: (value) {
//                 widget.onPressed(value!);
//               },
//               items: widget.itemList.isEmpty
//                   ? widget.propertyType!.map<DropdownMenuItem>((PropertyType value) {
//                       return DropdownMenuItem<int>(
//                         value: value.id!,
//                         child: Text(value.name.validate()).paddingSymmetric(horizontal: 10),
//                       );
//                     }).toList()
//                   : widget.itemList.map<DropdownMenuItem<String>>((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value).paddingSymmetric(horizontal: 10),
//                       );
//                     }).toList(),
//             ),
//           ),
//         ),
//       ],
//     ).paddingSymmetric(horizontal: 16);
//   }
// }
