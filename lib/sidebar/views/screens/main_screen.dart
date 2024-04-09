import 'package:admin_app/sidebar/views/screens/side_bar_screens/admin_screen.dart';
import 'package:admin_app/sidebar/views/screens/side_bar_screens/buyers_screen.dart';
import 'package:admin_app/sidebar/views/screens/side_bar_screens/categories_screen.dart';
import 'package:admin_app/sidebar/views/screens/side_bar_screens/dashboard_screen.dart';
import 'package:admin_app/sidebar/views/screens/side_bar_screens/delivery_rider_screen.dart';
import 'package:admin_app/sidebar/views/screens/side_bar_screens/orders_screen.dart';
import 'package:admin_app/sidebar/views/screens/side_bar_screens/products_screen.dart';
import 'package:admin_app/sidebar/views/screens/side_bar_screens/upload_banners_screen.dart';
import 'package:admin_app/sidebar/views/screens/side_bar_screens/vendors_screen.dart';
import 'package:admin_app/sidebar/views/screens/side_bar_screens/widgets/logout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class MainScreen extends StatefulWidget {
  final String userRole;

  const MainScreen({Key? key, required this.userRole});

  static const String id = 'main-screen';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Widget _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = DashboardScreen();
  }

  List<AdminMenuItem> filterMenuItems(List<AdminMenuItem> items) {
    if (widget.userRole == 'superAdmin') {
      return items;
    } else {
      return items
          .where((item) => item.route != AdminScreen.routeName)
          .toList();
    }
  }

  void screenSelector(AdminMenuItem item) {
    setState(() {
      switch (item.route) {
        case DashboardScreen.routeName:
          _selectedItem = DashboardScreen();
          break;
        case AdminScreen.routeName:
          _selectedItem = AdminScreen();
          break;
        case VendorScreen.routeName:
          _selectedItem = const VendorScreen();
          break;
        case DeliveryRiderScreen.routeName:
          _selectedItem = DeliveryRiderScreen();
          break;
        case BuyerScreen.routeName:
          _selectedItem = const BuyerScreen();
          break;
        case CategoriesScreen.routeName:
          _selectedItem = CategoriesScreen();
          break;

        case OrderScreen.routeName:
          _selectedItem = OrderScreen();
          break;
        case ProductScreen.routeName:
          _selectedItem = ProductScreen();
          break;
        case UploadBannerScreen.routeName:
          _selectedItem = UploadBannerScreen();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
        title: const Text(
          'E - Tabo Management',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      sideBar: SideBar(
        iconColor: Colors.green,
        backgroundColor: const Color.fromARGB(26, 240, 229, 229),
        borderColor: Colors.transparent,
        textStyle: const TextStyle(
          fontSize: 16.0,
        ),
        header: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xff444444),
          child: const Center(
            child: Text(
              'Admin Panel',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          ),
        ),
        items: filterMenuItems([
          const AdminMenuItem(
            title: 'Dashboard',
            icon: Icons.dashboard,
            route: DashboardScreen.routeName,
          ),
          const AdminMenuItem(
            title: 'Admins',
            icon: Icons.admin_panel_settings,
            route: AdminScreen.routeName,
          ),
          const AdminMenuItem(
            title: 'Vendors',
            route: VendorScreen.routeName,
            icon: Icons.store,
          ),
          const AdminMenuItem(
            title: 'Riders',
            icon: Icons.delivery_dining,
            route: DeliveryRiderScreen.routeName,
          ),
          const AdminMenuItem(
            title: 'Buyers',
            icon: Icons.person_3_rounded,
            route: BuyerScreen.routeName,
          ),
          const AdminMenuItem(
            title: 'Orders',
            icon: Icons.shopping_basket_rounded,
            route: OrderScreen.routeName,
          ),
          const AdminMenuItem(
            title: 'Categories',
            icon: Icons.category,
            route: CategoriesScreen.routeName,
          ),
          const AdminMenuItem(
            title: 'Products',
            icon: Icons.shop_rounded,
            route: ProductScreen.routeName,
          ),
          const AdminMenuItem(
            title: 'Banners',
            icon: Icons.upload_rounded,
            route: UploadBannerScreen.routeName,
          ),
          const AdminMenuItem(
            title: 'Logout',
            icon: Icons.logout,
            route: '',
          ),
        ]),
        selectedRoute: '',
        onSelected: (item) {
          if (item.route!.isEmpty) {
            confirmLogout(context);
          } else {
            screenSelector(item);
          }
        },
      ),
      body: _selectedItem,
    );
  }
}
