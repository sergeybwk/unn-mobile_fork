import 'package:unn_mobile/ui/widgets/placeholder.dart' as placeholder;
import 'package:flutter/material.dart';
import 'package:unn_mobile/core/viewmodels/main_page_view_model.dart';
import 'package:unn_mobile/ui/views/base_view.dart';
import 'package:unn_mobile/ui/views/main_page/about/about.dart';
import 'package:unn_mobile/ui/views/main_page/main_page_drawer.dart';
import 'package:unn_mobile/ui/views/main_page/main_page_navigation_bar.dart';
import 'package:unn_mobile/ui/views/main_page/schedule/schedule.dart';

class MainPage extends StatefulWidget {
  final String subroute;

  const MainPage({super.key, required this.subroute});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> drawerRoutes = [
    'placeholder',
    'placeholder',
    'placeholder',
    'placeholder',
    'placeholder',
    'placeholder',
    'placeholder',
    'about',
  ];
  final List<String> navbarRoutes = [
    'placeholder',
    'schedule',
    'placeholder',
    'placeholder',
  ];

  @override
  Widget build(BuildContext context) {
    return BaseView<MainPageViewModel>(
      builder: (context, model, child) {
        return Scaffold(
          key: scaffoldKey,
          appBar: getCurrentAppBar(model, context),
          drawerEdgeDragWidth: MediaQuery.of(context).size.width,
          extendBody: false,
          body: Navigator(
            key: _navigatorKey,
            initialRoute: widget.subroute,
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case 'about':
                  return MaterialPageRoute(
                      builder: (_) => AboutScreenView(), settings: settings);
                case '':
                case 'schedule':
                  return MaterialPageRoute(
                      builder: (_) => const ScheduleScreenView(), settings: settings);
                case 'placeholder':
                  return MaterialPageRoute(
                      builder: (_) => const placeholder.Placeholder(), settings: settings);
                default:
                  return MaterialPageRoute(
                      builder: (_) => const Text('Unknown page'), settings: settings);
              }
            },
          ),
          drawer: MainPageDrawer(onDestinationSelected: (value) {
            model.selectedDrawerItem = value;
            model.isDrawerItemSelected = true;
            scaffoldKey.currentState!.closeDrawer();
            _navigatorKey.currentState!.popAndPushNamed(
              drawerRoutes[value],
            );
          }),
          bottomNavigationBar: MainPageNavigationBar(
            onDestinationSelected: (value) {
              model.selectedBarItem = value;
              model.isDrawerItemSelected = false;
              _navigatorKey.currentState!.popAndPushNamed(navbarRoutes[value]);
            },
          ),
        );
      },
      onModelReady: (model) => model.init(),
    );
  }

  AppBar getCurrentAppBar(MainPageViewModel model, BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      title: Text(model.selectedScreenName),
      backgroundColor: theme.appBarTheme.backgroundColor,
      /*actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
      ],*/
    );
  }
}
