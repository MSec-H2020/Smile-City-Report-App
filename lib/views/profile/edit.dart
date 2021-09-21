// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';


// class ProfileEditController extends StatefulWidget
// {
//   @override
//   State<StatefulWidget> createState() => ProfileEditControllerState();
// }

// class ProfileEditControllerState extends State<ProfileEditController>
// {
//   // Property
//   String _name = '栄元優作';
//   String _birthday = '1995/10/18';
//   String _gender = 'male';

//   List<String> _genders = <String>['male', 'female', 'other'];

//   @override
//   Widget build(BuildContext context)
//   {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('detail'),
//       ),
//         body: ListView(
//           children: <Widget>[
//             // Name
//             ListTile(
//               leading: Icon(Icons.account_circle),
//               title: Text('Name'),
//               trailing: Text(_name ?? ''),
//               onTap: () async {
//                 final result = await _showDialog();
//                 if (result == null) return;
//                 setState(() {
//                   _name = result;
//                 });
//               },
//             ),
//             // Gender
//             ListTile(
//               leading: Icon(Icons.wc),
//               title: Text('Gender'),
//               trailing: Text(_gender ?? ''),
//               onTap: () async {
//                 final result = await _showCheckboxDialog();
//                 if (result == null) return;
//                 // Validate

//                 setState(() {
//                   _gender = result;
//                 });
//               },
//             ),
//             // Birthday
//             ListTile(
//               leading: Icon(Icons.cake),
//               trailing: Text(_birthday ?? ''),
//               title: Text('Birthday'),
//               onTap: () async {
//                 final result = await _showDatePicker();
//                 if (result == null) return;
//                 var formatter = DateFormat('yyyy/MM/dd');
//                 setState(() {
//                   _birthday = formatter.format(result);
//                 });
//               },
//             ),
//           ],
//         )
//     );
//   }

//   Future _showDialog() async
//   {
//     String text = '';
//     return await showDialog(context: context, builder: (context) {
//       return AlertDialog(
//         title: Text('New Name'),
//         content: TextField(
//           autofocus: true,
//           maxLines: null,
//           onChanged: (t) {
//             text = t;
//           },
//         ),
//         actions: <Widget>[
//           FlatButton(
//             child: Text('Update'),
//             onPressed: () => Navigator.of(context).pop(text),
//           ),
//           FlatButton(
//             child: Text('Cancel'),
//             onPressed: () => Navigator.of(context).pop(),
//           )
//         ],
//       );
//     });
//   }

//   Future _showCheckboxDialog() async
//   {
//     List<Widget> children = _genders.map((gender){
//       return SimpleDialogOption(
//         onPressed: () => Navigator.pop(context, gender),
//         child: CheckboxListTile(
//           value: _gender == gender,
//           onChanged: null,
//           title: Text(gender),
//         ),
//       );
//     }).toList();

//     return await showDialog(context: context, builder: (context) {
//       return SimpleDialog(
//         title: Text('Choose gender'),
//         children: children,
//       );
//     });
//   }

//   Future _showDatePicker() async
//   {
//     return await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(1990),
//       lastDate: DateTime.now(),
//     );
//   }
// }