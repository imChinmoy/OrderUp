// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:client/core/colors.dart';
// import '../../../auth/data/datasource/hive_session_storage.dart';
// import '../../../auth/data/models/session_model.dart';
// import '../providers/order_providers.dart';
// import '../widgets/order_tile.dart';
// import '../../../auth/presentation/screens/login_screen.dart';

// class AdminScreen extends ConsumerStatefulWidget {
//   const AdminScreen({Key? key}) : super(key: key);

//   @override
//   ConsumerState<AdminScreen> createState() => _AdminScreenState();
// }

// class _AdminScreenState extends ConsumerState<AdminScreen> {
//   int _tabIndex = 0;
//   String _adminName = '';
//   String _adminEmail = '';
//   bool _loadingDetails = true;

//   final HiveSessionStorage _sessionStorage = HiveSessionStorage();

//   @override
//   void initState() {
//     super.initState();
//     _loadAdminDetails();
//   }

//   Future<void> _loadAdminDetails() async {
//     setState(() {
//       _loadingDetails = true;
//     });
//     final SessionModel? session = await _sessionStorage.getSession();
//     if (session != null && session.user.isNotEmpty) {
//       try {
//         final user = jsonDecode(session.user);
//         setState(() {
//           _adminName = user['name'] ?? 'Admin';
//           _adminEmail = user['email'] ?? '';
//           _loadingDetails = false;
//         });
//       } catch (_) {
//         setState(() => _loadingDetails = false);
//       }
//     } else {
//       setState(() => _loadingDetails = false);
//     }
//   }

//   Future<void> _logout() async {
//     await _sessionStorage.clearSession();
//     if (!mounted) return;
//     Navigator.of(context).pushAndRemoveUntil(
//       MaterialPageRoute(builder: (context) => const LoginScreen()),
//       (route) => false,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.primaryDark,
//       body: SafeArea(
//         child: Column(
//           children: [
//             _buildHeader(),
//             if (_tabIndex == 0) _buildOrdersTab(),
//             if (_tabIndex == 1) _buildMenuTab(),
//             if (_tabIndex == 2) _buildSellsTab(),
//           ],
//         ),
//       ),
//       bottomNavigationBar: _buildBottomBar(),
//     );
//   }

//   Widget _buildHeader() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
//       color: AppColors.secondaryDark,
//       child: Row(
//         children: [
//           CircleAvatar(
//             backgroundColor: AppColors.mainOrange,
//             radius: 30,
//             child: Text(
//               _loadingDetails
//                 ? ''
//                 : (_adminName.isNotEmpty ? _adminName[0].toUpperCase() : ''),
//               style: const TextStyle(fontSize: 30, color: AppColors.white, fontWeight: FontWeight.w700),
//             ),
//           ),
//           const SizedBox(width: 20),
//           Expanded(
//             child: _loadingDetails
//                 ? Shimmer.fromColors(
//                     baseColor: AppColors.cardBackground,
//                     highlightColor: AppColors.grey.withOpacity(0.3),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           height: 15,
//                           width: 80,
//                           color: AppColors.cardBackground,
//                         ),
//                         const SizedBox(height: 8),
//                         Container(
//                           height: 12,
//                           width: 100,
//                           color: AppColors.cardBackground,
//                         ),
//                       ],
//                     ),
//                   )
//                 : Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         _adminName,
//                         style: const TextStyle(
//                           color: AppColors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 2),
//                       Text(
//                         _adminEmail,
//                         style: const TextStyle(
//                           color: AppColors.grey,
//                           fontSize: 13,
//                         ),
//                       ),
//                     ],
//                   ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.logout, color: AppColors.grey, size: 28),
//             onPressed: _logout,
//             tooltip: 'Logout'
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOrdersTab() {
//     final ordersAsync = ref.watch(ordersStreamProvider);

//     return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.only(left: 0, right: 0, top: 16),
//         child: ordersAsync.when(
//           data: (orders) {
//             if (orders.isEmpty) {
//               return const Center(
//                 child: Text(
//                   "No orders yet",
//                   style: TextStyle(color: AppColors.grey, fontSize: 18),
//                 ),
//               );
//             }
//             return ListView.separated(
//               physics: const BouncingScrollPhysics(),
//               itemCount: orders.length,
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               separatorBuilder: (_, __) => const SizedBox(height: 14),
//               itemBuilder: (context, idx) =>
//                   OrderTile(order: orders[idx]), // Use your custom tile
//             );
//           },
//           loading: () => ListView.separated(
//             itemCount: 6,
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//             separatorBuilder: (_, __) => const SizedBox(height: 14),
//             itemBuilder: (_, __) => Shimmer.fromColors(
//               baseColor: AppColors.cardBackground,
//               highlightColor: AppColors.grey.withOpacity(0.22),
//               child: Container(
//                 height: 70,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(22),
//                   color: AppColors.cardBackground,
//                 ),
//               ),
//             ),
//           ),
//           error: (e, _) => Center(child: Text('Error loading orders:\n$e', style: const TextStyle(color: Colors.redAccent, fontSize: 14))),
//         ),
//       ),
//     );
//   }

//   Widget _buildMenuTab() => const Expanded(
//         child: Center(
//           child: Text(
//             "Menu Management UI Coming Soon",
//             style: TextStyle(
//               color: AppColors.grey,
//               fontSize: 19,
//               fontWeight: FontWeight.w500),
//           ),
//         ),
//       );

//   Widget _buildSellsTab() => const Expanded(
//         child: Center(
//           child: Text(
//             "Sales Analytics Coming Soon",
//             style: TextStyle(
//               color: AppColors.grey,
//               fontSize: 19,
//               fontWeight: FontWeight.w500),
//           ),
//         ),
//       );

//   Widget _buildBottomBar() {
//     return Container(
//       decoration: BoxDecoration(
//         color: AppColors.secondaryDark,
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(26),
//           topRight: Radius.circular(26),
//         ),
//         boxShadow: [
//           BoxShadow(
//               color: Colors.black.withOpacity(0.18),
//               blurRadius: 14,
//               offset: const Offset(0, -7))
//         ],
//       ),
//       child: SafeArea(
//         top: false,
//         child: BottomNavigationBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           type: BottomNavigationBarType.fixed,
//           items: const [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.list_alt_rounded),
//               label: "Orders",
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.menu_book_rounded),
//               label: "Menu",
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.bar_chart_rounded),
//               label: "Sells",
//             ),
//           ],
//           currentIndex: _tabIndex,
//           selectedItemColor: AppColors.mainOrange,
//           unselectedItemColor: AppColors.grey.withOpacity(0.7),
//           selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
//           showSelectedLabels: true,
//           showUnselectedLabels: true,
//           onTap: (i) => setState(() => _tabIndex = i),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
class AdminScreen extends StatelessWidget {
const AdminScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Placeholder();
  }
}