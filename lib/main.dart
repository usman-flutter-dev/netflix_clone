import 'package:flutter/services.dart';
import 'package:movie_hive/core/utills/app_imports.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await dotenv.load(fileName: ".env");

      FlutterError.onError = (error) {
        log("framework level error", error: error.toString());
      };

      await Hive.initFlutter();
      Hive.registerAdapter(MovieModelAdapter());
      await Hive.openBox<MovieModel>('movie_box');
      await Hive.openBox<MovieModel>("top_rated_movies");

      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      );

      runApp(const MyApp());
    },
    (error, stack) {
      log("critical error caught in zone: $error");
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Movie Hive',
          getPages: AppPages.pages,
          initialRoute: AppRoutes.home,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
        );
      },
    );
  }
}



/* 
lib/
├── core/                         # Jo puri app mein common rahega
│   ├── theme/
│   │   └── appColors.dart
│   ├── routes/
│   │   └── appRoutes.dart
│   │   └── appPages.dart
│   ├── errors/
│   │   └── failure.dart          # Error handling class
│   ├── network/
│   │   ├── api_constants.dart    # URL aur Keys yahan rahengi
│   │   ├── dio_client.dart       # Dio Setup (Interceptor wala)
│   │   └── api_interceptors.dart # Token inject karne k liye
│   ├── services/
│   │   └── storage_service.dart  # Hive Setup
│   └── utils/
│       └── ui_helpers.dart       # Snackbar helpers
│
├── features/                     # App k main features
│   └── movies/
│       ├── data/                 # Data Layer (Dirty Work)
│       │   ├── datasources/      # API calls (Remote) & Hive calls (Local)
│       │   ├── models/           # JSON/Hive Models (e.g. MovieModel)
│       │   └── repositories/     # Repo Implementation (Either logic yahan hogi)
│       │
│       ├── domain/               # Domain Layer (Pure Logic - No Flutter code)
│       │   ├── entities/         # Simple Dart Class (e.g. Movie)
│       │   └── repositories/     # Abstract Class (Contract/Interface)
│       │
│       └── presentation/         # UI Layer (Visible Work)
│           ├── controllers/      # GetX Controllers
│           ├── pages/            # Screens (Home, Detail, Search)
│           └── widgets/          # Small parts (MovieCard, RatingBadge)
│
└── main.dart                     # Entry Point


 
*/