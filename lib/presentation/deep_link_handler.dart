// import 'dart:async';
//
// import 'package:uni_links5/uni_links.dart';
//
// import '../common/bloc/reset_password_cubit.dart';
//
// class DeepLinkHandler {
//   final ResetPasswordCubit resetPasswordCubit;
//   StreamSubscription? linkStreamSubscription;
//
//   DeepLinkHandler({required this.resetPasswordCubit});
//
//   // Initialize the deep link listener
//   void initDeepLinkListener() async {
//     try {
//       // Handle the initial deep link when the app is launched from a link
//       final initialLink = await getInitialLink();
//       if (initialLink != null) {
//         handleResetPasswordLink(initialLink);
//       }
//
//       // Listen for future deep links while the app is running
//       linkStreamSubscription = linkStream.listen((String? link) {
//         if (link != null) {
//           handleResetPasswordLink(link);
//         }
//       });
//     } catch (e) {
//       print('Error handling deep link: $e');
//     }
//   }
//
//   // Handle the deep link and trigger relevant actions in the Cubit
//   void handleResetPasswordLink(String link) {
//     final uri = Uri.parse(link);
//     final code = uri.queryParameters['oobCode'];
//     if (code != null) {
//       resetPasswordCubit.confirmPasswordReset(
//           code, 'newPassword'); // Example, handle newPassword accordingly
//     }
//   }
//
//   // Dispose of the listener to prevent memory leaks
//   void dispose() {
//     linkStreamSubscription?.cancel();
//   }
// }
