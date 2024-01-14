import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scarvs/app/constants/app.theme.dart';
import 'package:scarvs/app/providers/app.provider.dart';
import 'package:scarvs/app/routes/app.routes.dart';
import 'package:scarvs/core/models/favorite_product.dart';
import 'package:scarvs/core/notifiers/theme.notifier.dart';
import 'core/models/orders.dart';
// import 'web_url/configure_nonweb.dart'
//     if (dart.library.html) 'web_url/configure_web.dart';

Future<void> main() async {
  // configureApp();
  WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
  Hive.registerAdapter(OrderDataAdapter());
  Hive.registerAdapter(FavoriteProductAdapter());
  await Hive.openBox<OrderData>('orders');
  await Hive.openBox<FavoriteProduct>('favorite_products');
  runApp(const Lava());
}

class Lava extends StatelessWidget {
  const Lava({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProvider.providers,
      child: const Core(),
    );
  }
}

class Core extends StatelessWidget {
  const Core({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, notifier, _) {
        return MaterialApp(
          title: 'Scarvs',
          // supportedLocales: AppLocalization.all,
          theme: notifier.darkTheme ? darkTheme : lightTheme,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: AppRouter.generateRoute,
          initialRoute: AppRouter.splashRoute,
        );
      },
    );
  }
}
