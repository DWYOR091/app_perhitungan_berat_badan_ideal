// // import 'package:belajar_flutter/data/notifiers.dart';
// // import 'package:belajar_flutter/views/pages/home_page.dart';
// // import 'package:belajar_flutter/views/pages/login_page.dart';
// // import 'package:belajar_flutter/views/pages/profile_page.dart';
// // import 'package:belajar_flutter/views/pages/setting_page.dart';
// // import 'package:belajar_flutter/views/widgets/navbar_widget.dart';
// import 'package:aplikasi_perhitungan_berat_badan_ideal/data/notifiers.dart';
// import 'package:aplikasi_perhitungan_berat_badan_ideal/views/pages/login_page.dart';
// import 'package:flutter/material.dart';

// // List<Widget> pages = [HomePage(), ProfilePage()];

// class WidgetTree extends StatelessWidget {
//   const WidgetTree({super.key});
// //final List<Widget> pages = const [HomePage(),ProfilePage()]; //jika ingin const

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Center(
//           child: Text(
//             "Belajar Flutter",
//           ),
//         ),
//         backgroundColor: Colors.blue,
//         leading: IconButton(
//             onPressed: () {
//               showDialog(
//                   context: context,
//                   builder: (context) {
//                     return AlertDialog(
//                       title: const Row(
//                         children: [
//                           Icon(Icons.warning),
//                           SizedBox(width: 10),
//                           Text("Logout")
//                         ],
//                       ),
//                       content: const Text("Apakah anda yakin ingin logout?"),
//                       actions: [
//                         TextButton(
//                             style: ButtonStyle(
//                               backgroundColor:
//                                   WidgetStateProperty.resolveWith<Color>(
//                                       (states) {
//                                 if (states.contains(WidgetState.pressed)) {
//                                   return Colors.orange; // Saat ditekan
//                                 }
//                                 if (states.contains(WidgetState.hovered)) {
//                                   return Colors.blue.shade700; // Saat hover
//                                 }
//                                 return Colors.blue[300]!; // Normal
//                               }),
//                             ),
//                             onPressed: () {
//                               Navigator.of(context).pop();
//                             },
//                             child: const Text(
//                               "Tidak",
//                               style: TextStyle(color: Colors.white),
//                             )),
//                         TextButton(
//                             style: ButtonStyle(backgroundColor:
//                                 WidgetStateProperty.resolveWith((states) {
//                               if (states.contains(WidgetState.hovered)) {
//                                 return Colors.green.shade700;
//                               }
//                               return Colors.green[300]!;
//                             })),
//                             onPressed: () {
//                               Navigator.pushReplacement(context,
//                                   MaterialPageRoute(
//                                 builder: (context) {
//                                   return const LoginPage();
//                                 },
//                               ));
//                             },
//                             child: const Text(
//                               "Ya",
//                               style: TextStyle(color: Colors.white),
//                             ))
//                       ],
//                       shape: const RoundedRectangleBorder(
//                           borderRadius:
//                               BorderRadius.all(Radius.circular(20.0))),
//                     );
//                   });
//             },
//             icon: const Icon(Icons.logout)),
//         actions: [
//           SizedBox(
//               child: Switch(
//             value: isDarkModeNotifier.value,
//             //thumbIcon: isDarkModeNotifier.value
//             //     ? WidgetStateProperty.all(Icon(Icons.light_mode))
//             //     : WidgetStateProperty.all(Icon(Icons.dark_mode)),
//             thumbIcon: WidgetStateProperty.resolveWith(
//               (states) {
//                 if (states.contains(WidgetState.selected)) {
//                   return Icon(Icons.light_mode);
//                 } else {
//                   return Icon(Icons.dark_mode);
//                 }
//               },
//             ),
//             onChanged: (value) {
//               isDarkModeNotifier.value = value;
//               print(value);
//             },
//           )),
//           // IconButton(
//           //     onPressed: () {
//           //       Navigator.push(context, MaterialPageRoute(
//           //         builder: (context) {
//           //           return SettingPage(
//           //             title: "Settings",
//           //           );
//           //         },
//           //       ));
//           //     },
//           //     icon: const Icon(Icons.settings))
//         ],
//       ),
//       body: ValueListenableBuilder(
//         valueListenable: selectedPageNotifier,
//         builder: (BuildContext context, dynamic value, Widget? child) {
//           // return pages[value];
//           // return  pages.elementAt(value); //cara 2
//         },
//       ),
//       // bottomNavigationBar: NavbarWidget(),
//     );
//   }
// }
