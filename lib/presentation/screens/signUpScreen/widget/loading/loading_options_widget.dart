// import 'package:flutter/material.dart';



// class LoadingOptions {
//   static void showErroDialog({String title = 'Error', String? description = 'Something went wrong'}) {
//     Get.dialog(
//       Dialog(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 title,
//                 style: Get.textTheme.headline4,
//               ),
//               Text(
//                 description ?? '',
//                 style: Get.textTheme.headline6,
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   if (Get.isDialogOpen!) Get.back();
//                 },
//                 child: const Text('Okay'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   //show loading
//   static void showLoading([String? message]) {
//     Get.dialog(
//       Dialog(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const CircularProgressIndicator(),
//               const SizedBox(height: 8),
//               Text(message ?? 'Loading...'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   //hide loading
//   static void hideLoading() {
//     if (Get.isDialogOpen!) Get.back();
//   }
// }
// class _GetImpl extends GetInterface {}

// final Get = _GetImpl();