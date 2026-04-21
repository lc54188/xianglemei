import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';

// ==================== 搴旂敤鍏ュ彛 ====================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 鍒濆鍖栧瓨鍌ㄦ湇鍔?  await StorageService.init();
  runApp(const XiangLeMeiApp());
}

// ==================== 瀛樺偍鏈嶅姟 ====================
class StorageService {
  static late SharedPreferences _prefs;
  
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  // 閿悕甯搁噺
  static const String keyDarkMode = 'dark_mode';
  static const String keyUsername = 'username';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyMeiSeeds = 'mei_seeds';
  static const String keyHealingDay = 'healing_day';
  static const String keyCurrentMood = 'current_mood';
  
  // 娣辫壊妯″紡
  static bool getDarkMode() => _prefs.getBool(keyDarkMode) ?? false;
  static Future<void> setDarkMode(bool value) => _prefs.setBool(keyDarkMode, value);
  
  // 鐢ㄦ埛鍚?  static String getUsername() => _prefs.getString(keyUsername) ?? '';
  static Future<void> setUsername(String value) => _prefs.setString(keyUsername, value);
  
  // 鐧诲綍鐘舵€?  static bool getIsLoggedIn() => _prefs.getBool(keyIsLoggedIn) ?? false;
  static Future<void> setIsLoggedIn(bool value) => _prefs.setBool(keyIsLoggedIn, value);
  
  // 鑾撶苯鏁?  static int getMeiSeeds() => _prefs.getInt(keyMeiSeeds) ?? 0;
  static Future<void> setMeiSeeds(int value) => _prefs.setInt(keyMeiSeeds, value);
  
  // 娌绘剤澶╂暟
  static int getHealingDay() => _prefs.getInt(keyHealingDay) ?? 0;
  static Future<void> setHealingDay(int value) => _prefs.setInt(keyHealingDay, value);
  
  // 褰撳墠蹇冩儏
  static String getCurrentMood() => _prefs.getString(keyCurrentMood) ?? '馃崜';
  static Future<void> setCurrentMood(String value) => _prefs.setString(keyCurrentMood, value);
  
  // 娓呴櫎鎵€鏈夋暟鎹?  static Future<void> clear() => _prefs.clear();
}

// ==================== 鎬ц兘浼樺寲甯搁噺 ====================
const bool kDebugOptimize = false; // 鐢熶骇鐜鍏抽棴璋冭瘯

// ==================== 涓婚閰嶇疆 ====================
class AppTheme {
  // 鍝佺墝鑹茬郴
  static const Color primary = Color(0xFFFF6B8A);
  static const Color primaryLight = Color(0xFFFF8FAB);
  static const Color primaryDark = Color(0xFFE55A7A);
  static const Color secondary = Color(0xFFFFB3C6);
  static const Color accent = Color(0xFFFF4D6D);
  static const Color background = Color(0xFFFFF0F3);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF3D0000);
  static const Color textSecondary = Color(0xFF9B6B7A);
  static const Color creamWhite = Color(0xFFFFF8F9);
  static const Color greenAccent = Color(0xFF52C41A);
  static const Color goldAccent = Color(0xFFFFAA00);

  // 娣辫壊妯″紡鑹茬郴
  static const Color darkBackground = Color(0xFF1A1A2E);
  static const Color darkSurface = Color(0xFF252538);
  static const Color darkCardBg = Color(0xFF2D2D44);
  static const Color darkTextPrimary = Color(0xFFF5F5F5);
  static const Color darkTextSecondary = Color(0xFFB0B0C0);
  static const Color darkSecondary = Color(0xFF4A4A6A);
  
  // 瀹夊崜鐘舵€佹爮閫傞厤
  static SystemUiOverlayStyle get systemOverlayStyle => const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: surface,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  static SystemUiOverlayStyle get darkSystemOverlayStyle => const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: darkSurface,
    systemNavigationBarIconBrightness: Brightness.light,
  );

  // 鍦嗚甯搁噺
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 24.0;
  static const double radiusXLarge = 32.0;

  // 闃村奖鏍峰紡
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: primary.withOpacity(0.12),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  // 浜壊涓婚
  static ThemeData get theme => _buildTheme(Brightness.light);

  // 鏆楄壊涓婚
  static ThemeData get darkTheme => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final bg = isDark ? darkBackground : background;
    final surfaceColor = isDark ? darkSurface : surface;
    final card = isDark ? darkCardBg : cardBg;
    final textP = isDark ? darkTextPrimary : textPrimary;
    final textS = isDark ? darkTextSecondary : textSecondary;

    return ThemeData(
      useMaterial3: true,
      primaryColor: primary,
      scaffoldBackgroundColor: bg,
      fontFamily: 'Roboto',
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: brightness,
        surface: surfaceColor,
        primary: primary,
        secondary: secondary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? darkSurface : primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: isDark ? darkSystemOverlayStyle : SystemUiOverlayStyle.light,
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: primary.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusLarge),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusLarge),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      cardTheme: CardTheme(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? darkCardBg : background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        hintStyle: TextStyle(color: textS.withOpacity(0.7)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: primary,
        unselectedItemColor: textS,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: primary,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusSmall)),
        behavior: SnackBarBehavior.floating,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radiusLarge)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surfaceColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(radiusLarge)),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: isDark ? darkSecondary.withOpacity(0.3) : secondary.withOpacity(0.3),
        thickness: 1,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primary,
        linearTrackColor: secondary,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: textP),
        bodyMedium: TextStyle(color: textP),
        bodySmall: TextStyle(color: textS),
        titleLarge: TextStyle(color: textP, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: textP, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(color: textP),
        labelLarge: TextStyle(color: textP),
        labelMedium: TextStyle(color: textS),
        labelSmall: TextStyle(color: textS),
      ),
      iconTheme: IconThemeData(color: textS),
      listTileTheme: ListTileThemeData(
        textColor: textP,
        iconColor: textS,
      ),
    );
  }
}

// ==================== 鏁版嵁妯″瀷 ====================
class AppState extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _username = '';
  int _meiSeeds = 0;
  String _currentMood = '馃崜';
  List<DiaryEntry> _diaries = [];
  List<String> _joinedGroups = [];
  int _healingDay = 0;
  List<String> _achievements = [];
  bool _isDarkMode = false; // 娣辫壊妯″紡鐘舵€?  Map<String, bool> _farmItems = {
    '鑽夎帗鑻?: true,
    '灏忚崏鑾?: false,
    '澶ц崏鑾?: false,
    '鑽夎帗鐜?: false,
  };

  // 鏋勯€犲嚱鏁帮細浠庡瓨鍌ㄥ姞杞芥暟鎹?  AppState() {
    _loadFromStorage();
  }

  // 浠庡瓨鍌ㄥ姞杞芥暟鎹?  void _loadFromStorage() {
    _isDarkMode = StorageService.getDarkMode();
    _isLoggedIn = StorageService.getIsLoggedIn();
    _username = StorageService.getUsername();
    _meiSeeds = StorageService.getMeiSeeds();
    _healingDay = StorageService.getHealingDay();
    _currentMood = StorageService.getCurrentMood();
  }

  // 鎬ц兘浼樺寲锛歡etter鐩存帴杩斿洖锛屽噺灏戝嚱鏁拌皟鐢ㄥ紑閿€
  bool get isLoggedIn => _isLoggedIn;
  String get username => _username;
  int get meiSeeds => _meiSeeds;
  String get currentMood => _currentMood;
  List<DiaryEntry> get diaries => _diaries;
  List<String> get joinedGroups => _joinedGroups;
  int get healingDay => _healingDay;
  List<String> get achievements => _achievements;
  bool get isDarkMode => _isDarkMode;
  Map<String, bool> get farmItems => _farmItems;

  void setDarkMode(bool value) {
    if (_isDarkMode != value) {
      _isDarkMode = value;
      StorageService.setDarkMode(value);
      notifyListeners();
    }
  }

  void login(String name) {
    _isLoggedIn = true;
    _username = name.isEmpty ? '鑾撹帗鐢ㄦ埛' : name;
    StorageService.setIsLoggedIn(true);
    StorageService.setUsername(_username);
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _username = '';
    StorageService.setIsLoggedIn(false);
    StorageService.setUsername('');
    notifyListeners();
  }

  void addMeiSeeds(int count) {
    _meiSeeds += count;
    StorageService.setMeiSeeds(_meiSeeds);
    _checkAchievements();
    notifyListeners();
  }

  void setMood(String mood) {
    _currentMood = mood;
    StorageService.setCurrentMood(mood);
    notifyListeners();
  }

  void addDiary(DiaryEntry entry) {
    _diaries.insert(0, entry);
    addMeiSeeds(5);
    notifyListeners();
  }

  void joinGroup(String group) {
    if (!_joinedGroups.contains(group)) {
      _joinedGroups.add(group);
      addMeiSeeds(10);
      notifyListeners();
    }
  }

  void completePunch() {
    _healingDay++;
    StorageService.setHealingDay(_healingDay);
    addMeiSeeds(15);
    _checkFarmGrowth();
    notifyListeners();
  }

  void _checkAchievements() {
    if (_meiSeeds >= 50 && !_achievements.contains('鑾撶苯鏀堕泦鑰?)) {
      _achievements.add('鑾撶苯鏀堕泦鑰?);
    }
    if (_meiSeeds >= 100 && !_achievements.contains('鑾撶苯澶у笀')) {
      _achievements.add('鑾撶苯澶у笀');
    }
    if (_diaries.length >= 3 && !_achievements.contains('鏃ヨ杈句汉')) {
      _achievements.add('鏃ヨ杈句汉');
    }
  }

  void _checkFarmGrowth() {
    if (_healingDay >= 3 && !_farmItems['灏忚崏鑾?]!) {
      _farmItems['灏忚崏鑾?] = true;
    }
    if (_healingDay >= 7 && !_farmItems['澶ц崏鑾?]!) {
      _farmItems['澶ц崏鑾?] = true;
    }
    if (_healingDay >= 21 && !_farmItems['鑽夎帗鐜?]!) {
      _farmItems['鑽夎帗鐜?] = true;
    }
  }
}

class DiaryEntry {
  final String mood;
  final String content;
  final DateTime time;
  final String aiAdvice;

  const DiaryEntry({
    required this.mood,
    required this.content,
    required this.time,
    required this.aiAdvice,
  });
}

// ==================== 鍏ㄥ眬鐘舵€佸崟渚?====================
final AppState _globalState = AppState();

// ==================== 椤甸潰杩囨浮鍔ㄧ敾 ====================
class FadePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  FadePageRoute({required this.page})
      : super(
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.02, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                )),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 250),
          reverseTransitionDuration: const Duration(milliseconds: 200),
        );
}

// ==================== 涓诲簲鐢?====================
class XiangLeMeiApp extends StatelessWidget {
  const XiangLeMeiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _globalState,
      builder: (context, _) {
        final isDark = _globalState.isDarkMode;
        return MaterialApp(
          title: '鎯充簡鑾?,
          theme: AppTheme.theme,
          darkTheme: AppTheme.darkTheme,
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          debugShowCheckedModeBanner: false,
          // 鍏ㄥ眬椤甸潰杩囨浮鍔ㄧ敾
          builder: (context, child) {
            // 妯珫灞忛€傞厤锛氬搷搴斿紡甯冨眬
            return OrientationBuilder(
              builder: (context, orientation) {
                // 鏍规嵁灞忓箷鏂瑰悜璋冩暣UI
                final isLandscape = orientation == Orientation.landscape;
                final screenSize = MediaQuery.of(context).size;
                final isTablet = screenSize.shortestSide >= 600;
                
                // 璁剧疆绯荤粺UI鏍峰紡
                SystemChrome.setSystemUIOverlayStyle(
                  isDark ? AppTheme.darkSystemOverlayStyle : AppTheme.systemOverlayStyle,
                );
                
                // 鍏佽妯珫灞忓垏鎹?                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.portraitDown,
                  DeviceOrientation.landscapeLeft,
                  DeviceOrientation.landscapeRight,
                ]);
                
                return child ?? const SizedBox();
              },
            );
          },
          home: const _AuthRouter(),
        );
      },
    );
  }
}

// 鎬ц兘浼樺寲锛氱嫭绔嬬殑璁よ瘉璺敱缁勪欢
class _AuthRouter extends StatelessWidget {
  const _AuthRouter();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _globalState,
      builder: (context, _) {
        return _globalState.isLoggedIn
            ? const MainScreen()
            : const OnboardingScreen();
      },
    );
  }
}

// ==================== 寮曞椤?====================
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _animationController;
  int _currentPage = 0;

  final List<_OnboardingPageData> _pages = const [
    _OnboardingPageData(
      icon: '馃崜',
      title: '娆㈣繋鏉ュ埌鎯充簡鑾?,
      subtitle: '涓€涓睘浜庝綘鐨勬儏鎰熸不鎰堝皬瀹囧畽',
      gradient: [Color(0xFFFF6B8A), Color(0xFFFF8FAB)],
    ),
    _OnboardingPageData(
      icon: '馃挐',
      title: '鎭嬬埍鎶€宸у叏鏀荤暐',
      subtitle: 'AI鍔╂墜甯綘鎼炲畾姣忎竴娆″績鍔ㄦ椂鍒?,
      gradient: [Color(0xFFFF4D6D), Color(0xFFFF6B8A)],
    ),
    _OnboardingPageData(
      icon: '馃尡',
      title: '澶辨亱涔熻兘閲嶆柊寮€濮?,
      subtitle: '21澶╂不鎰堣鍒掞紝闄綘鎱㈡參璧板嚭鏉?,
      gradient: [Color(0xFFFF8FAB), Color(0xFFFFB3C6)],
    ),
    _OnboardingPageData(
      icon: '馃洝锔?,
      title: '瀹堟姢浣犵殑鍋ュ悍涓庤竟鐣?,
      subtitle: '鑾撶浘瀹堟姢锛岃鐖辨洿瀹夊叏',
      gradient: [Color(0xFFC9184A), Color(0xFFE55A7A)],
    ),
    _OnboardingPageData(
      icon: '馃専',
      title: '鎵惧埌浣犵殑鑾撳弸鏄熺悆',
      subtitle: '蹇楀悓閬撳悎鐨勬湅鍙嬪氨鍦ㄨ繖閲岀瓑浣?,
      gradient: [Color(0xFFFF6B8A), Color(0xFFFF4D6D)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    } else {
      _showLoginSheet(context);
    }
  }

  void _showLoginSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const LoginBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 椤甸潰鍐呭
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _pages.length,
            itemBuilder: (context, index) => _OnboardingPage(data: _pages[index]),
          ),
          // 搴曢儴鎺у埗鍖?          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 椤甸潰鎸囩ず鍣?                  _PageIndicator(
                    count: _pages.length,
                    currentIndex: _currentPage,
                  ),
                  const SizedBox(height: 24),
                  // 鎸夐挳
                  _GradientButton(
                    onPressed: _nextPage,
                    child: Text(
                      _currentPage < _pages.length - 1 ? '涓嬩竴姝? : '寮€濮嬩綋楠?馃崜',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                  // 璺宠繃鎸夐挳
                  if (_currentPage < _pages.length - 1) ...[
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => _showLoginSheet(context),
                      child: const Text(
                        '璺宠繃',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 寮曞椤垫暟鎹ā鍨?class _OnboardingPageData {
  final String icon;
  final String title;
  final String subtitle;
  final List<Color> gradient;

  const _OnboardingPageData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
  });
}

// 寮曞椤靛崟涓〉闈?class _OnboardingPage extends StatelessWidget {
  final _OnboardingPageData data;

  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: data.gradient,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 鍥炬爣锛堝甫鍔ㄧ敾鏁堟灉锛?              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.8, end: 1.0),
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut,
                builder: (context, value, child) => Transform.scale(
                  scale: value,
                  child: Text(data.icon, style: const TextStyle(fontSize: 100)),
                ),
              ),
              const SizedBox(height: 40),
              // 鏍囬
              Text(
                data.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // 鍓爣棰?              Text(
                data.subtitle,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 椤甸潰鎸囩ず鍣?class _PageIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const _PageIndicator({
    required this.count,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

// 娓愬彉鎸夐挳缁勪欢
class _GradientButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const _GradientButton({required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

// ==================== 鐧诲綍寮圭獥 ====================
class LoginBottomSheet extends StatefulWidget {
  const LoginBottomSheet({super.key});

  @override
  State<LoginBottomSheet> createState() => _LoginBottomSheetState();
}

class _LoginBottomSheetState extends State<LoginBottomSheet> {
  bool _isRegister = false;
  bool _obscureText = true;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _focusNode1 = FocusNode();
  final _focusNode2 = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _focusNode1.dispose();
    _focusNode2.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final name = _nameController.text.trim();
    _globalState.login(name.isNotEmpty ? name : '鑾撹帗鐢ㄦ埛');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.72,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLarge)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 鎷栧姩鏉?            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Logo鍜屾爣棰?            Center(
              child: Column(
                children: [
                  const Text('馃崜', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 8),
                  Text(
                    '鎯充簡鑾?,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isRegister ? '鍒涘缓浣犵殑鑾撹帗璐﹀彿' : '娆㈣繋鍥炴潵锛岃帗鑾撲汉锛?,
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            // 鏄电О杈撳叆锛堟敞鍐屾ā寮忥級
            if (_isRegister) ...[
              _buildTextField(
                controller: _nameController,
                focusNode: _focusNode1,
                label: '鏄电О',
                hint: '缁欒嚜宸辫捣涓彲鐖辩殑鍚嶅瓧 馃崜',
                prefixIcon: Icons.person_outline,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
            ],
            // 鎵嬫満鍙?閭杈撳叆
            _buildTextField(
              controller: _phoneController,
              focusNode: _focusNode2,
              label: '鎵嬫満鍙?/ 閭',
              hint: '璇疯緭鍏ヨ处鍙?,
              prefixIcon: Icons.phone_android_outlined,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _handleLogin(),
            ),
            const SizedBox(height: 24),
            // 鐧诲綍/娉ㄥ唽鎸夐挳
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _handleLogin,
                child: Text(
                  _isRegister ? '娉ㄥ唽骞跺紑濮?馃崜' : '鐧诲綍',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // 鍒囨崲娉ㄥ唽/鐧诲綍
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isRegister ? '宸叉湁璐﹀彿锛? : '杩樻病鏈夎处鍙凤紵',
                  style: const TextStyle(color: AppTheme.textSecondary),
                ),
                TextButton(
                  onPressed: () => setState(() => _isRegister = !_isRegister),
                  child: Text(
                    _isRegister ? '鐩存帴鐧诲綍' : '绔嬪嵆娉ㄥ唽',
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // 寰俊蹇嵎鐧诲綍
            Center(
              child: OutlinedButton.icon(
                onPressed: () {
                  _globalState.login('寰俊鐢ㄦ埛');
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.chat_bubble_outline, color: Color(0xFF07C160)),
                label: const Text(
                  '寰俊蹇嵎鐧诲綍',
                  style: TextStyle(color: Color(0xFF07C160)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required IconData prefixIcon,
    TextInputAction textInputAction = TextInputAction.next,
    ValueChanged<String>? onSubmitted,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(prefixIcon, color: AppTheme.primary),
      ),
    );
  }
}

// ==================== 涓荤晫闈紙搴曢儴瀵艰埅锛?====================
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int _tabIndex = 0;
  late final List<AnimationController> _iconAnimations;
  final PageController _pageController = PageController();

  final List<Widget> _pages = const [
    HomeTab(),
    MeiHaoGongLueTab(),
    MeiWanDaiXuTab(),
    MeiYouXingQiuTab(),
    MyTab(),
  ];

  @override
  void initState() {
    super.initState();
    _iconAnimations = List.generate(
      5,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
      ),
    );
  }

  @override
  void dispose() {
    for (final controller in _iconAnimations) {
      controller.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  void _selectTab(int index) {
    if (_tabIndex == index) return;
    setState(() => _tabIndex = index);
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        onPageChanged: (index) => setState(() => _tabIndex = index),
        children: _pages,
      ),
      bottomNavigationBar: _AndroidBottomNav(
        currentIndex: _tabIndex,
        onTap: _selectTab,
      ),
    );
  }
}

// 瀹夊崜浼樺寲鐨勫簳閮ㄥ鑸爮
class _AndroidBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _AndroidBottomNav({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: '棣栭〉',
                isSelected: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                icon: Icons.favorite_border,
                activeIcon: Icons.favorite,
                label: '鑾撳ソ鏀荤暐',
                isSelected: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _NavItem(
                icon: Icons.eco_outlined,
                activeIcon: Icons.eco,
                label: '鑾撳畬寰呯画',
                isSelected: currentIndex == 2,
                onTap: () => onTap(2),
              ),
              _NavItem(
                icon: Icons.public_outlined,
                activeIcon: Icons.public,
                label: '鑾撳弸鏄熺悆',
                isSelected: currentIndex == 3,
                onTap: () => onTap(3),
              ),
              _NavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: '鎴戠殑',
                isSelected: currentIndex == 4,
                onTap: () => onTap(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== 棣栭〉 Tab ====================
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: RefreshIndicator(
        color: AppTheme.primary,
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            // 椤堕儴搴旂敤鏍?            SliverAppBar(
              pinned: true,
              expandedHeight: 130,
              backgroundColor: AppTheme.primary,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.primary, AppTheme.accent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ListenableBuilder(
                            listenable: _globalState,
                            builder: (_, __) => Text(
                              '浣犲ソ锛?{_globalState.username} ${_globalState.currentMood}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '浠婂ぉ涔熻鍏冩皵婊℃弧鍝︼綖',
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              title: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('馃崜', style: TextStyle(fontSize: 24)),
                  SizedBox(width: 8),
                  Text('鎯充簡鑾?),
                ],
              ),
            ),
            // 鍐呭鍖哄煙
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // 鑾撶苯鍗＄墖
                  ListenableBuilder(
                    listenable: _globalState,
                    builder: (_, __) => const _SeedsCard(),
                  ),
                  const SizedBox(height: 16),
                  // 浠婃棩蹇冩儏
                  const _MoodSelector(),
                  const SizedBox(height: 20),
                  // 鏍稿績鍔熻兘鏍囬
                  const _SectionTitle(title: '鏍稿績鍔熻兘', icon: Icons.grid_view_rounded),
                  const SizedBox(height: 12),
                  // 鍔熻兘缃戞牸
                  _FunctionGrid(),
                  const SizedBox(height: 20),
                  // 鑾撶浘瀹堟姢
                  _ShieldCard(),
                  const SizedBox(height: 100),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 鍖哄潡鏍囬缁勪欢
class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primary, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}

// 鑾撶苯鍗＄墖
class _SeedsCard extends StatelessWidget {
  const _SeedsCard();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppTheme.primary, AppTheme.primaryLight],
          ),
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Row(
          children: [
            const Text('馃崜', style: TextStyle(fontSize: 48)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '鎴戠殑鑾撶苯',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  Text(
                    '${_globalState.meiSeeds} 绮?,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '娌绘剤绗?${_globalState.healingDay} 澶?,
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 蹇冩儏閫夋嫨鍣?class _MoodSelector extends StatelessWidget {
  const _MoodSelector();

  static const _moods = ['馃崜', '馃槉', '馃槩', '馃槨', '馃尭', '馃挭', '馃グ', '馃槾'];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  '浠婃棩蹇冩儏',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const Spacer(),
                Text(
                  _globalState.currentMood,
                  style: const TextStyle(fontSize: 24),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _moods.map((m) {
                final selected = _globalState.currentMood == m;
                return GestureDetector(
                  onTap: () => _globalState.setMood(m),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppTheme.primary.withOpacity(0.15)
                          : AppTheme.background,
                      borderRadius: BorderRadius.circular(12),
                      border: selected
                          ? Border.all(color: AppTheme.primary, width: 2)
                          : Border.all(color: Colors.transparent),
                    ),
                    child: Text(m, style: const TextStyle(fontSize: 28)),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// 鍔熻兘缃戞牸
class _FunctionGrid extends StatelessWidget {
  _FunctionGrid();

  final List<_FunctionItem> _items = const [
    _FunctionItem(icon: Icons.favorite, label: '鑾撳ソ鏀荤暐', color: Color(0xFFFFE0E6), tab: 1),
    _FunctionItem(icon: Icons.eco, label: '鑾撳畬寰呯画', color: Color(0xFFE8F5E9), tab: 2),
    _FunctionItem(icon: Icons.public, label: '鑾撳弸鏄熺悆', color: Color(0xFFE3F2FD), tab: 3),
    _FunctionItem(icon: Icons.person, label: '鎴戠殑', color: Color(0xFFFCE4EC), tab: 4),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: _items.length,
      itemBuilder: (context, index) => _items[index],
    );
  }
}

class _FunctionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final int tab;

  const _FunctionItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.tab,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          final state = context.findAncestorStateOfType<_MainScreenState>();
          state?._selectTab(tab);
        },
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            boxShadow: AppTheme.softShadow,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: AppTheme.primary),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 鑾撶浘瀹堟姢鍗＄墖
class _ShieldCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MeiDunScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF8E24AA), Color(0xFFAD1457)],
          ),
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8E24AA).withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Text('馃洝锔?, style: TextStyle(fontSize: 40)),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '鑾撶浘瀹堟姢',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '浜嗚В浜插瘑杈圭晫涓庡仴搴风煡璇?鈫?,
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_forward, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== 鑾撳ソ鏀荤暐 Tab ====================
class MeiHaoGongLueTab extends StatelessWidget {
  const MeiHaoGongLueTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('馃挐 鑾撳ソ鏀荤暐'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ListenableBuilder(
              listenable: _globalState,
              builder: (_, __) => Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '馃崜 ${_globalState.meiSeeds}',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: const [
          // AI 瀵硅瘽缁冧範 - 涓绘帹
          _AICard(),
          SizedBox(height: 20),
          // 鍦烘櫙鏀荤暐
          _SectionTitle(title: '鍦烘櫙鍖栨妧宸?, icon: Icons.grid_view_rounded),
          SizedBox(height: 12),
          _ScenarioGrid(),
          SizedBox(height: 20),
          // 鎭嬬埍娴嬭瘯
          _TestCard(),
          SizedBox(height: 12),
          // 妗堜緥搴?          _CaseLibraryLinkCard(),
          SizedBox(height: 100),
        ],
      ),
    );
  }
}

// AI鍗＄墖
class _AICard extends StatelessWidget {
  const _AICard();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AIChatScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppTheme.primary, AppTheme.accent],
          ),
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Text('馃', style: TextStyle(fontSize: 36)),
                SizedBox(width: 12),
                Text(
                  'AI 瀵硅瘽缁冧範',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              '"瀵规柟璇村湪骞插槢锛屾垜璇ユ€庝箞鍥烇紵" 鍛婅瘔AI浣犵殑鍥版儜锛岃幏寰楅珮鎯呭晢寤鸿',
              style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '寮€濮嬬粌涔?鈫?,
                    style: TextStyle(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 鍦烘櫙缃戞牸
class _ScenarioGrid extends StatelessWidget {
  const _ScenarioGrid();

  final List<_Scenario> _scenarios = const [
    _Scenario(icon: '鈽?, title: '鍒濇绾︿細', desc: '濡備綍璁㏕a璁颁綇浣?),
    _Scenario(icon: '馃挰', title: '鏆ф槯鍗囨俯', desc: '鎶婃毀鏄у彉鎴愮‘璁?),
    _Scenario(icon: '馃拰', title: '琛ㄧ櫧鎶€宸?, desc: '鎴愬姛鐜囨渶楂樼殑鏂瑰紡'),
    _Scenario(icon: '馃寵', title: '鎸藉洖鏂规硶', desc: '鐞嗘€у湴閲嶆柊寮€濮?),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
      ),
      itemCount: _scenarios.length,
      itemBuilder: (context, i) => _ScenarioCard(scenario: _scenarios[i]),
    );
  }
}

class _Scenario {
  final String icon;
  final String title;
  final String desc;

  const _Scenario({required this.icon, required this.title, required this.desc});
}

class _ScenarioCard extends StatelessWidget {
  final _Scenario scenario;

  const _ScenarioCard({required this.scenario});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ScenarioDetailScreen(
              title: scenario.title,
              icon: scenario.icon,
            ),
          ),
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            boxShadow: AppTheme.softShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(scenario.icon, style: const TextStyle(fontSize: 32)),
              const Spacer(),
              Text(
                scenario.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                scenario.desc,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 娴嬭瘯鍗＄墖
class _TestCard extends StatelessWidget {
  const _TestCard();

  @override
  Widget build(BuildContext context) {
    return _ListCard(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoveTestScreen()),
      ),
      icon: '馃',
      title: '鎭嬬埍鎬ф牸娴嬭瘯',
      subtitle: '浜嗚В浣犵殑鎭嬬埍椋庢牸锛岃幏鍙栦釜鎬у寲寤鸿',
    );
  }
}

// 妗堜緥搴撳叆鍙ｅ崱鐗?class _CaseLibraryLinkCard extends StatelessWidget {
  const _CaseLibraryLinkCard();

  @override
  Widget build(BuildContext context) {
    return _ListCard(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CaseLibraryScreen()),
      ),
      icon: '馃摎',
      title: '鐪熷疄妗堜緥搴?,
      subtitle: '鍖垮悕鏁呬簨 + 涓撳瑙ｆ瀽锛屼粠鍒汉鐨勭粡鍘嗕腑瀛︿範',
    );
  }
}

// 鍒楄〃鍗＄墖閫氱敤缁勪欢
class _ListCard extends StatelessWidget {
  final VoidCallback onTap;
  final String icon;
  final String title;
  final String subtitle;

  const _ListCard({
    required this.onTap,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 40)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: AppTheme.primary, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== AI 瀵硅瘽缁冧範鐣岄潰 ====================
class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];
  bool _isThinking = false;

  final List<String> _quickQuestions = [
    '瀵规柟璇?鍦ㄥ共鍢?锛屾垜鎬庝箞鍥烇紵',
    '鍠滄鐨勪汉涓嶄富鍔紝鎬庝箞鍔烇紵',
    '绾︿細缁撴潫鍚庡浣曞彂娑堟伅锛?,
    '濡備綍鑷劧鍦板憡鐧斤紵',
  ];

  final List<String> _aiResponses = const [
    '鏍规嵁瀵规柟璇?鍦ㄥ共鍢?鐨勫満鏅紝寤鸿浣犺繖鏍峰洖澶嶏細\n\n馃挕 鏂规A锛堟椿娉煎瀷锛夛細\n"鍒氬垰鍦ㄦ兂浣犲憖锝炰綘鍛紵"\n\n馃挕 鏂规B锛堢绉樺瀷锛夛細\n"鍦ㄥ仛涓€浠跺緢閲嶈鐨勪簨锛岀寽鐚滄槸浠€涔堬紵"\n\n馃挕 鏂规C锛堣嚜鐒跺瀷锛夛細\n"鍒峰埌涓€涓緢濂界帺鐨勮棰戯紒鍒嗕韩缁欎綘锝?\n\n鈿狅笍 娓╅Θ鎻愮ず锛氫互涓婂缓璁粎渚涘弬鑰冿紝璇风粨鍚堝鏂规€ф牸鍜屼綘浠殑鍏崇郴瀹為檯鍒ゆ柇銆?,
    '闈㈠鍠滄鐨勪汉涓嶄富鍔ㄧ殑鎯呭喌锛歕n\n馃尭 鍏堣瀵烼a鏄惁瀵规墍鏈変汉閮戒笉涓诲姩锛堟€ф牸鍘熷洜 vs 瀵逛綘涓嶆劅鍏磋叮锛塡n\n鉁?寤鸿锛氶€傚綋涓诲姩閲婃斁淇″彿锛屾瘮濡傛壘鍏卞悓璇濋銆佸伓灏斾富鍔ㄧ害濂藉弸涓€璧峰嚭琛屻€俓n\n馃挐 璁颁綇锛氫富鍔ㄤ笉浠ｈ〃鎺変环锛岀湡璇氱殑琛ㄨ揪鏈€鏈夐瓍鍔涳紒\n\n鈿狅笍 娓╅Θ鎻愮ず锛氭劅鎯呴渶瑕佸弻鍚戝璧达紝璇蜂繚鎶ゅソ鑷繁鐨勬儏缁€?,
    '绾︿細缁撴潫鍚庣殑鏈€浣冲彂娑堟伅鏃舵満锛歕n\n鈴?鍒板鍚?30 鍒嗛挓鍐咃細鍙戜竴鏉¤交鏉剧殑娑堟伅\n"鍒板浜嗭紒浠婂ぉ寰堝紑蹇冿紝涓嬫杩樻兂涓€璧凤綖"\n\n馃毇 閬垮厤锛氱珛鍒荤柉鐙傚彂娑堟伅銆佹繁澶滆桨鐐竆n鉁?鎺ㄨ崘锛氱畝鐭湡璇氾紝缁欏鏂圭暀鏈夌┖闂碶n\n鈿狅笍 娓╅Θ鎻愮ず锛氭瘡娈靛叧绯荤殑鑺傚閮戒笉鍚岋紝浠ヤ笂浠呬緵鍙傝€冦€?,
    '鑷劧鍛婄櫧鐨勫嚑绉嶆柟寮忥細\n\n馃拰 鏂瑰紡涓€锛堝垱鎰忓瀷锛夛細\n鍊熷姪涓€涓皬绀肩墿鎴栫壒鍒殑鍦烘櫙鑷劧寮曞嚭\n\n馃棧锔?鏂瑰紡浜岋紙鐩存帴鍨嬶級锛歕n"鎴戝枩娆綘锛屾兂鍜屼綘鍦ㄤ竴璧?\n鈥斺€旂畝鍗曠洿鎺ワ紝鎴愬姛鐜囨渶楂榎n\n馃幁 鏂瑰紡涓夛紙璇曟帰鍨嬶級锛歕n"濡傛灉鏈変汉鍠滄浣狅紝浣犱細鎬庝箞鏍凤紵"\n\n鈿狅笍 娓╅Θ鎻愮ず锛氭棤璁虹粨鏋滃浣曪紝鍕囨暍琛ㄨ揪閮芥槸鍊煎緱鑲畾鐨勶紒',
  ];

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add({'role': 'user', 'content': text});
      _isThinking = true;
    });
    _scrollToBottom();
    _getAIResponse(text);
  }

  void _getAIResponse(String question) {
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      int index = _quickQuestions.indexOf(question);
      if (index < 0) index = 0;
      setState(() {
        _messages.add({'role': 'ai', 'content': _aiResponses[index]});
        _isThinking = false;
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('馃 AI 鎭嬬埍鍔╂墜'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showDisclaimer(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // 鍏嶈矗澹版槑
          Container(
            width: double.infinity,
            color: const Color(0xFFFFF3CD),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: const Text(
              '鈿狅笍 AI寤鸿浠呬緵鍙傝€冿紝璇风粨鍚堝疄闄呮儏鍐靛垽鏂?,
              style: TextStyle(fontSize: 12, color: Color(0xFF856404)),
              textAlign: TextAlign.center,
            ),
          ),
          // 鑱婂ぉ鍐呭
          Expanded(
            child: _messages.isEmpty
                ? _buildQuickQuestions()
                : _buildChatList(),
          ),
          // 杈撳叆妗?          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildQuickQuestions() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '甯歌闂蹇嵎鎻愰棶锛?,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(_quickQuestions.length, (i) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _QuickQuestionCard(
                question: _quickQuestions[i],
                onTap: () => _sendMessage(_quickQuestions[i]),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length + (_isThinking ? 1 : 0),
      itemBuilder: (context, i) {
        if (i == _messages.length) {
          return const _ThinkingBubble();
        }
        final msg = _messages[i];
        final isUser = msg['role'] == 'user';
        return _ChatBubble(
          content: msg['content']!,
          isUser: isUser,
        );
      },
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _inputController,
              decoration: InputDecoration(
                hintText: '杈撳叆浣犵殑鎯呮劅鍥版儜...',
                filled: true,
                fillColor: AppTheme.background,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (v) => _sendMessage(v),
            ),
          ),
          const SizedBox(width: 12),
          Material(
            color: AppTheme.primary,
            borderRadius: BorderRadius.circular(24),
            child: InkWell(
              onTap: () => _sendMessage(_inputController.text),
              borderRadius: BorderRadius.circular(24),
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Icon(Icons.send, color: Colors.white, size: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDisclaimer(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('鈿狅笍 鍏嶈矗澹版槑'),
        content: const Text(
          '1. AI鍔╂墜鎻愪緵鐨勫缓璁粎渚涘弬鑰僜n'
          '2. 涓嶈兘鏇夸唬涓撲笟鐨勫績鐞嗗挩璇n'
          '3. 璇风粨鍚堝疄闄呮儏鍐靛拰鐩磋鍒ゆ柇\n'
          '4. 淇濇姢濂借嚜宸辩殑闅愮鍜屽畨鍏╘n\n'
          '濡傛湁涓ラ噸蹇冪悊鍥版壈锛岃瀵绘眰涓撲笟甯姪銆?,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('鎴戠煡閬撲簡'),
          ),
        ],
      ),
    );
  }
}

class _QuickQuestionCard extends StatelessWidget {
  final String question;
  final VoidCallback onTap;

  const _QuickQuestionCard({required this.question, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            border: Border.all(color: AppTheme.secondary.withOpacity(0.5)),
            boxShadow: AppTheme.softShadow,
          ),
          child: Row(
            children: [
              const Icon(Icons.chat_bubble_outline, color: AppTheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  question,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: AppTheme.textSecondary, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String content;
  final bool isUser;

  const _ChatBubble({required this.content, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser ? AppTheme.primary : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 20 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 20),
          ),
          boxShadow: AppTheme.softShadow,
        ),
        child: Text(
          content,
          style: TextStyle(
            fontSize: 15,
            color: isUser ? Colors.white : AppTheme.textPrimary,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}

class _ThinkingBubble extends StatelessWidget {
  const _ThinkingBubble();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(20),
          ),
          boxShadow: AppTheme.softShadow,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'AI鎬濊€冧腑...',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== 鍦烘櫙璇︽儏鐣岄潰 ====================
class ScenarioDetailScreen extends StatelessWidget {
  final String title;
  final String icon;

  const ScenarioDetailScreen({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$icon $title')),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primary.withOpacity(0.1), AppTheme.secondary.withOpacity(0.1)],
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            ),
            child: Column(
              children: [
                Text(icon, style: const TextStyle(fontSize: 64)),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            '馃挕 鏍稿績鎶€宸?,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildTipCard('1', '淇濇寔鐪熻瘹锛屼笉瑕佸埢鎰忚〃婕?),
          _buildTipCard('2', '鍏虫敞瀵规柟鐨勫弽搴旓紝闅忔満搴斿彉'),
          _buildTipCard('3', '涓嶈鎬ヤ簬姹傛垚锛岀粰褰兼鏃堕棿'),
          const SizedBox(height: 24),
          const Text(
            '馃摑 瀹炴垬璇濇湳',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('馃挰 鎺ㄨ崘寮€鍦虹櫧锛?, style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(
                    '"浠婂ぉ鍙戠幇涓€瀹跺緢妫掔殑鍜栧暋搴楋紝鎯充笉鎯充竴璧峰幓璇曡瘯锛?',
                    style: TextStyle(fontSize: 15, height: 1.6),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildTipCard(String num, String text) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  num,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== 鎭嬬埍娴嬭瘯鐣岄潰 ====================
class LoveTestScreen extends StatefulWidget {
  const LoveTestScreen({super.key});

  @override
  State<LoveTestScreen> createState() => _LoveTestScreenState();
}

class _LoveTestScreenState extends State<LoveTestScreen> {
  int _currentQ = 0;
  final List<int> _answers = [];
  bool _showResult = false;
  String _resultType = '';

  final List<Map<String, dynamic>> _questions = const [
    {
      'q': '鎭嬬埍涓綘鏇村€惧悜浜庯紵',
      'options': ['涓诲姩琛ㄨ揪鎰熸儏', '绛夊鏂瑰厛寮€鍙?, '闅忕紭锛岄『鍏惰嚜鐒?, '鐢ㄨ鍔ㄤ唬鏇胯█璇?],
    },
    {
      'q': '绾︿細鏃朵綘浼氭彁鍓嶅涔呭仛鍑嗗锛?,
      'options': ['鎻愬墠鍑犲ぉ绮惧績鍑嗗', '褰撳ぉ涓存椂鍐冲畾', '鎻愬墠涓€澶╂兂鎯冲氨濂?, '鍑犱箮涓嶅噯澶囷紝闅忔剰鏈€濂?],
    },
    {
      'q': '褰撳拰瀵规柟浜х敓鐭涚浘鏃讹紝浣犱細锛?,
      'options': ['绔嬪埢娌熼€氳В鍐?, '鍏堝喎闈欎竴娈垫椂闂?, '绛夊鏂瑰厛閬撴瓑', '鍋囪娌′簨锛屽拷鐣ラ棶棰?],
    },
    {
      'q': '浣犺涓虹悊鎯崇殑鎭嬬埍鑺傚鏄紵',
      'options': ['蹇€熺‘璁ゅ叧绯?, '鎱㈡參浜嗚В锛岃嚜鐒跺彂灞?, '鍏堟垚涓哄ソ鏈嬪弸鍐嶈', '鎰熻瀵逛簡灏遍┈涓婅鍔?],
    },
  ];

  final Map<String, Map<String, String>> _results = {
    '涓诲姩鐑儏鍨?: {
      'icon': '馃敟',
      'desc': '浣犵儹鎯呭鏀撅紝鏁簬琛ㄨ揪锛屾槸鎭嬬埍涓殑涓诲姩鏂广€備綘鐨勪紭鍔挎槸璁╁鏂规劅鍒拌閲嶈锛屼絾瑕佹敞鎰忎笉瑕佺粰瀵规柟澶ぇ鍘嬪姏銆?,
      'tip': '寤鸿锛氶€傚綋缁欏鏂圭暀涓€浜涚┖闂村拰绁炵鎰燂紝浼氳鍏崇郴鏇存寔涔呫€?,
    },
    '鐞嗘€хǔ閲嶅瀷': {
      'icon': '馃',
      'desc': '浣犵悊鎬ц€岀ǔ閲嶏紝鍦ㄦ劅鎯呬腑姣旇緝璋ㄦ厧銆備綘浼氳鐪熷垎鏋愬叧绯伙紝涓嶈交鏄撳啿鍔ㄣ€?,
      'tip': '寤鸿锛氶€傚綋鏀惧紑蹇冩墘锛屽媷浜庤〃杈炬儏鎰燂紝璁╁鏂规劅鍙楀埌浣犵殑娓╁害銆?,
    },
    '娴极鎰熸€у瀷': {
      'icon': '馃尭',
      'desc': '浣犲鎰熸儏鍏呮弧娴极骞绘兂锛屾搮闀胯惀閫犳皼鍥淬€備綘鐨勬劅鏌撳姏寰堝己锛岃兘甯︾粰瀵规柟骞哥鎰熴€?,
      'tip': '寤鸿锛氬湪娴极涔嬩綑锛屼篃瑕佽剼韪忓疄鍦板湴缁忚惀鏃ュ父鍏崇郴銆?,
    },
    '闅忕紭鑷湪鍨?: {
      'icon': '馃寠',
      'desc': '浣犲湪鎰熸儏涓『鍏惰嚜鐒讹紝涓嶅己姹傘€傝繖绉嶆€佸害鑳藉噺灏戝緢澶氱劍铏戯紝浣嗕篃鍙兘閿欒繃鏈轰細銆?,
      'tip': '寤鸿锛氬湪瀵圭殑鏃舵満锛屽皾璇曚富鍔ㄨ繄鍑虹涓€姝ワ紝涓嶈璁╃紭鍒嗘簻璧般€?,
    },
  };

  void _selectOption(int i) {
    setState(() {
      _answers.add(i);
      if (_currentQ < _questions.length - 1) {
        _currentQ++;
      } else {
        _calculateResult();
      }
    });
  }

  void _calculateResult() {
    final types = ['涓诲姩鐑儏鍨?, '鐞嗘€хǔ閲嶅瀷', '娴极鎰熸€у瀷', '闅忕紭鑷湪鍨?];
    final dominantType = types[_answers.isNotEmpty ? _answers[0] % types.length : 0];
    setState(() {
      _resultType = dominantType;
      _showResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showResult) return _buildResultPage();

    final q = _questions[_currentQ];
    return Scaffold(
      appBar: AppBar(title: const Text('馃 鎭嬬埍鎬ф牸娴嬭瘯')),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 杩涘害
            Row(
              children: [
                Text(
                  '闂 ${_currentQ + 1}/${_questions.length}',
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                ),
                const Spacer(),
                Text(
                  '${((_currentQ / _questions.length) * 100).toInt()}%',
                  style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: _currentQ / _questions.length,
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 32),
            // 闂鍗＄墖
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                boxShadow: AppTheme.cardShadow,
              ),
              child: Text(
                q['q'] as String,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // 閫夐」
            ...List.generate((q['options'] as List).length, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _OptionButton(
                  label: String.fromCharCode(65 + i),
                  text: (q['options'] as List)[i] as String,
                  onTap: () => _selectOption(i),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildResultPage() {
    final result = _results[_resultType]!;
    return Scaffold(
      appBar: AppBar(title: const Text('浣犵殑鎭嬬埍鎬ф牸鎶ュ憡')),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 缁撴灉鍗＄墖
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primary, AppTheme.accent],
                ),
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              ),
              child: Column(
                children: [
                  Text(result['icon']!, style: const TextStyle(fontSize: 72)),
                  const SizedBox(height: 12),
                  Text(
                    _resultType,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // 鍒嗘瀽鍗＄墖
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '鎬ф牸鍒嗘瀽',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      result['desc']!,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.7,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.secondary.withOpacity(0.5)),
                      ),
                      child: Text(
                        result['tip']!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.primary,
                          fontStyle: FontStyle.italic,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // 淇濆瓨鎸夐挳
            ElevatedButton.icon(
              onPressed: () {
                _globalState.addMeiSeeds(20);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('馃崜 鑾峰緱 20 绮掕帗绫斤紒鎶ュ憡宸蹭繚瀛?)),
                );
                Navigator.pop(context);
              },
              icon: const Icon(Icons.save_alt),
              label: const Text('淇濆瓨鎶ュ憡 (+20鑾撶苯)'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  final String label;
  final String text;
  final VoidCallback onTap;

  const _OptionButton({
    required this.label,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            border: Border.all(color: AppTheme.secondary.withOpacity(0.6)),
            boxShadow: AppTheme.softShadow,
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.primary.withOpacity(0.5)),
                ),
                child: Center(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== 妗堜緥搴撶晫闈?====================
class CaseLibraryScreen extends StatelessWidget {
  const CaseLibraryScreen({super.key});

  static const _cases = [
    {
      'title': '寮傚湴鎭嬩笁骞达紝濡備綍缁存寔鎰熸儏娓╁害锛?,
      'tag': '寮傚湴鎭?,
      'summary': '鍖垮悕鐢ㄦ埛 @鑽夎帗鎯冲康浣?鍒嗕韩浜嗚嚜宸辩淮鎸佷笁骞村紓鍦版亱鐨勫績寰?..',
      'analysis': '涓撳瑙ｆ瀽锛氬紓鍦版亱鐨勬牳蹇冩槸"浠紡鎰?涓?淇′换鎰?鐨勫弻閲嶅缓绔嬨€?,
    },
    {
      'title': '鏆楁亱浜嗕袱骞达紝璇ヨ杩樻槸涓嶈锛?,
      'tag': '鏆楁亱',
      'summary': '鍖垮悕鐢ㄦ埛 @灏忚崏鑾撹鍕囨暍 鐨勬晠浜嬪憡璇夋垜浠紝鏆楁亱鐨勪唬浠?..',
      'analysis': '涓撳瑙ｆ瀽锛氭殫鎭嬬殑鏈€澶ч闄╂槸鏃堕棿鎴愭湰锛屽缓璁€傛椂琛ㄨ揪銆?,
    },
    {
      'title': '琚垎鎵嬪悗濡備綍姝ｈ鑷繁鐨勪环鍊硷紵',
      'tag': '澶辨亱',
      'summary': '@鑾撹帗鍔犳补 鐢ㄤ翰韬粡鍘嗚瘉鏄庯紝澶辨亱鍚庣殑鎴愰暱寰€寰€瓒呭嚭鎯宠薄...',
      'analysis': '涓撳瑙ｆ瀽锛氬け鎭嬫槸涓€娆￠噸鏂拌璇嗚嚜宸辩殑鏈轰細锛屽叧閿湪浜庡綊鍥犳柟寮忋€?,
    },
    {
      'title': '鎬庝箞鐪嬪嚭瀵规柟鏄惁鐪熺殑鍠滄浣狅紵',
      'tag': '杈ㄥ埆鎰熸儏',
      'summary': '姹囨€讳簡100涓湡瀹炴渚嬪悗锛岃繖10涓俊鍙峰€煎緱鍏虫敞...',
      'analysis': '涓撳瑙ｆ瀽锛氳鍔ㄦ瘮璇█鏇磋兘璇存槑闂锛岃瀵熸棩甯哥粏鑺傘€?,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('馃摎 鐪熷疄妗堜緥搴?)),
      body: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: _cases.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) => _CaseCard(caseData: _cases[i]),
      ),
    );
  }
}

class _CaseCard extends StatelessWidget {
  final Map<String, String> caseData;

  const _CaseCard({required this.caseData});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => _CaseDetailSheet(caseData: caseData),
          );
        },
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppTheme.secondary.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  caseData['tag']!,
                  style: const TextStyle(fontSize: 12, color: AppTheme.primary),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                caseData['title']!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                caseData['summary']!,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CaseDetailSheet extends StatelessWidget {
  final Map<String, String> caseData;

  const _CaseDetailSheet({required this.caseData});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLarge)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 鎷栧姩鏉?          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // 鏍囩
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.secondary.withOpacity(0.4),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              caseData['tag']!,
              style: const TextStyle(fontSize: 13, color: AppTheme.primary),
            ),
          ),
          const SizedBox(height: 12),
          // 鏍囬
          Text(
            caseData['title']!,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          // 鍐呭
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '馃摉 鏁呬簨姝ｆ枃',
                    style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${caseData['summary']}\n\n锛堝畬鏁存晠浜嬪唴瀹光€﹁繖閲屽睍绀烘渚嬭鎯咃紝淇濇姢闅愮宸插仛鍖垮悕澶勭悊锛?,
                    style: const TextStyle(fontSize: 14, height: 1.7, color: AppTheme.textPrimary),
                  ),
                  const SizedBox(height: 20),
                  // 涓撳瑙ｆ瀽
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '馃敩 涓撳瑙ｆ瀽',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primary,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          caseData['analysis']!,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== 鑾撳畬寰呯画 Tab ====================
class MeiWanDaiXuTab extends StatelessWidget {
  const MeiWanDaiXuTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('馃尡 鑾撳畬寰呯画'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ListenableBuilder(
              listenable: _globalState,
              builder: (_, __) => Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '绗?{_globalState.healingDay}澶?,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const WriteDiaryScreen()),
        ),
        backgroundColor: AppTheme.primary,
        icon: const Icon(Icons.edit, color: Colors.white),
        label: const Text(
          '鍐欒崏鑾撴棩璁?,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          // 鎯呯华鏇茬嚎
          ListenableBuilder(
            listenable: _globalState,
            builder: (_, __) => _buildMoodCurve(),
          ),
          const SizedBox(height: 16),
          // 娌绘剤璁″垝
          ListenableBuilder(
            listenable: _globalState,
            builder: (_, __) => _buildHealingPlan(context),
          ),
          const SizedBox(height: 16),
          // 鐤楁剤宸ュ叿
          _buildHealingTools(context),
          const SizedBox(height: 16),
          // 涓撲笟甯姪
          _buildProfessionalHelp(context),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildMoodCurve() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '馃搳 鎯呯华鏇茬嚎',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  '鍏辫褰?${_globalState.diaries.length} 绡?,
                  style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_globalState.diaries.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text('馃崜', style: TextStyle(fontSize: 48)),
                      SizedBox(height: 12),
                      Text(
                        '杩樻病鏈夎褰曪綖\n鐐瑰嚮鍙充笅瑙?鍐欒崏鑾撴棩璁?寮€濮嬪惂',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              SizedBox(
                height: 100,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(
                    min(_globalState.diaries.length, 7),
                    (i) {
                      final heights = [40.0, 55.0, 35.0, 65.0, 50.0, 70.0, 60.0];
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                _globalState.diaries[i].mood,
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                height: heights[i % heights.length],
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [AppTheme.secondary, AppTheme.primary],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealingPlan(BuildContext context) {
    final day = _globalState.healingDay;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '馃尡 21澶╂不鎰堣鍒?,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$day / 21',
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: day / 21,
                minHeight: 10,
                backgroundColor: AppTheme.secondary.withOpacity(0.3),
                color: AppTheme.greenAccent,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '浠婃棩浠诲姟',
                    style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _getDayTask(day),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _globalState.completePunch();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('馃崜 鎵撳崱鎴愬姛锛佽幏寰?15 绮掕帗绫斤紒')),
                  );
                },
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('鎵撳崱瀹屾垚 (+15鑾撶苯)'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDayTask(int day) {
    final tasks = [
      '鏁寸悊涓€浠舵棫鐗╁苟鎷嶇収璁板綍',
      '缁欒嚜宸卞啓涓€灏佷俊锛岃鍑轰笁涓紭鐐?,
      '瀛︿竴棣栨柊姝岋紝鍝肩粰鑷繁鍚?,
      '鍑洪棬鏁ｆ20鍒嗛挓锛屾劅鍙楅槼鍏?,
      '灏濊瘯鍋氫竴閬撲粠鏈仛杩囩殑鑿?,
      '鑱旂郴涓€浣嶈涔呮湭鑱旂郴鐨勬湅鍙?,
      '鏁寸悊浣犵殑鎵嬫満鐩稿唽锛屼繚鐣欑編濂?,
      '鍐欎笅5浠惰浣犳劅鎭╃殑浜?,
      '灏濊瘯涓€椤规柊鐨勫叴瓒ｇ埍濂?,
      '鐪嬩竴閮ㄨ浣犲紑蹇冪殑鐢靛奖',
      '鍒跺畾涓嬩釜鏈堢殑涓€涓皬鐩爣',
      '涓鸿嚜宸变拱涓€浠跺皬绀肩墿',
      '鍐ユ兂10鍒嗛挓锛屼笓娉ㄥ懠鍚?,
      '鍜屽浜烘墦涓€涓俯鏆栫殑鐢佃瘽',
      '璁板綍浠婂ぉ鎵€鏈夌編濂界殑鐬棿',
      '灏濊瘯杩愬姩鎴栫憸浼?0鍒嗛挓',
      '閲嶆柊甯冪疆浣犵殑鎴块棿涓€瑙?,
      '闃呰涓€绡囬紦鍔辫嚜宸辩殑鏂囩珷',
      '鍜屾湅鍙嬪垎浜竴涓揩涔愭晠浜?,
      '涓哄畬鎴愯繖娈垫梾绋嬪鍔辫嚜宸?,
    ];
    return tasks[min(day, tasks.length - 1)];
  }

  Widget _buildHealingTools(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: '馃О 鐤楁剤宸ュ叿鍖?, icon: Icons.build_outlined),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ToolCard(
                icon: '馃幍',
                title: '鐧藉櫔闊冲啣鎯?,
                subtitle: '鑽夎帗涓婚ASMR',
                onTap: () => _showASMRSheet(context),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ToolCard(
                icon: '馃尦',
                title: '铏氭嫙鏍戞礊',
                subtitle: '鍖垮悕鍊捐瘔',
                onTap: () => _showTreeHoleSheet(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showASMRSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: 300,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLarge)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text('馃幍', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            const Text(
              '鐧藉櫔闊冲啣鎯?,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '鍔熻兘寮€鍙戜腑锛屾暚璇锋湡寰?..',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('鍏抽棴'),
            ),
          ],
        ),
      ),
    );
  }

  void _showTreeHoleSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLarge)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text('馃尦', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            const Text(
              '铏氭嫙鏍戞礊',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '鍦ㄨ繖閲岋紝浣犲彲浠ュ尶鍚嶅€捐瘔...\n鍔熻兘寮€鍙戜腑锛屾暚璇锋湡寰?..',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('鍏抽棴'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalHelp(BuildContext context) {
    return GestureDetector(
      onTap: () => _showConsultantDialog(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(color: AppTheme.secondary.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Text('馃懇鈥嶁殨锔?, style: TextStyle(fontSize: 28)),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '鑱旂郴涓撲笟鍜ㄨ甯?,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    '涓撲笟蹇冪悊鍜ㄨ锛屼粯璐归绾?,
                    style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: AppTheme.primary, size: 16),
          ],
        ),
      ),
    );
  }

  void _showConsultantDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('馃懇鈥嶁殨锔?涓撲笟鍜ㄨ'),
        content: const Text(
          '涓撲笟蹇冪悊鍜ㄨ鏈嶅姟\n\n'
          '鈥?涓€瀵逛竴鎯呮劅鍜ㄨ\n'
          '鈥?蹇冪悊鐘舵€佽瘎浼癨n'
          '鈥?涓€у寲娌绘剤鏂规\n\n'
          '馃摓 鍜ㄨ鏂瑰紡锛氬湪绾胯棰?璇煶\n'
          '馃挵 璐圭敤锛氭牴鎹挩璇㈠笀鑰屽畾\n\n'
          '鍔熻兘寮€鍙戜腑锛屾暚璇锋湡寰?..',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('鍏抽棴'),
          ),
        ],
      ),
    );
  }
}

class _ToolCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ToolCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            boxShadow: AppTheme.softShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(icon, style: const TextStyle(fontSize: 36)),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== 鍐欐棩璁扮晫闈?====================
class WriteDiaryScreen extends StatefulWidget {
  const WriteDiaryScreen({super.key});

  @override
  State<WriteDiaryScreen> createState() => _WriteDiaryScreenState();
}

class _WriteDiaryScreenState extends State<WriteDiaryScreen> {
  final _contentController = TextEditingController();
  String _selectedMood = '馃崜';

  final _moods = ['馃崜', '馃槉', '馃槩', '馃槨', '馃尭', '馃挭', '馃グ', '馃槾'];

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('璇峰啓涓嬩綘鐨勫績鎯?..')),
      );
      return;
    }
    _globalState.addDiary(DiaryEntry(
      mood: _selectedMood,
      content: _contentController.text.trim(),
      time: DateTime.now(),
      aiAdvice: '璁板綍鏄竴绉嶅緢濂界殑鑷垜鐤楁剤鏂瑰紡锝?,
    ));
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('馃崜 鏃ヨ宸蹭繚瀛橈紝鑾峰緱 5 绮掕帗绫斤紒')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('馃崜 鍐欒崏鑾撴棩璁?),
        actions: [
          TextButton(
            onPressed: _submit,
            child: const Text(
              '淇濆瓨',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '浠婂ぉ鐨勫績鎯?,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              children: _moods.map((m) {
                final selected = _selectedMood == m;
                return GestureDetector(
                  onTap: () => setState(() => _selectedMood = m),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: selected ? AppTheme.primary.withOpacity(0.15) : AppTheme.background,
                      borderRadius: BorderRadius.circular(12),
                      border: selected ? Border.all(color: AppTheme.primary, width: 2) : null,
                    ),
                    child: Text(m, style: const TextStyle(fontSize: 28)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Text(
              '鍐欎笅浣犵殑鏁呬簨',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _contentController,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: '浠婂ぉ鍙戠敓浜嗕粈涔堣浣犲紑蹇?闅捐繃鐨勪簨鎯咃紵\n鎶婂績浜嬪啓涓嬫潵鍚?..',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.save),
                label: const Text('淇濆瓨鏃ヨ (+5鑾撶苯)'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== 鑾撳弸鏄熺悆 Tab ====================
class MeiYouXingQiuTab extends StatelessWidget {
  const MeiYouXingQiuTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('馃實 鑾撳弸鏄熺悆')),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: const [
          // 鏄熺悆浠嬬粛
          _PlanetIntro(),
          SizedBox(height: 20),
          // 璇濋骞垮満
          _SectionTitle(title: '馃敟 鐑棬璇濋', icon: Icons.local_fire_department),
          SizedBox(height: 12),
          _TopicList(),
          SizedBox(height: 20),
          // 鑾撳弸鍦堝叆鍙?          _SectionTitle(title: '馃懃 鑾撳弸鍦?, icon: Icons.group),
          SizedBox(height: 12),
          _CommunityList(),
          SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _PlanetIntro extends StatelessWidget {
  const _PlanetIntro();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
      ),
      child: const Column(
        children: [
          Text('馃實', style: TextStyle(fontSize: 56)),
          SizedBox(height: 12),
          Text(
            '鑾撳弸鏄熺悆',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '鍦ㄨ繖閲岄亣瑙佸織鍚岄亾鍚堢殑鏈嬪弸\n涓€璧锋垚闀匡紝鐩镐簰娌绘剤',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _TopicList extends StatelessWidget {
  const _TopicList();

  final List<Map<String, String>> _topics = const [
    {'icon': '馃挄', 'title': '#浠婂ぉ鐨勬不鎰堝皬浜?, 'count': '2.3涓?},
    {'icon': '馃専', 'title': '#鍓嶄换鏁欎細鎴戠殑浜?, 'count': '1.8涓?},
    {'icon': '馃挭', 'title': '#鍒嗘墜鍚庣殑铚曞彉', 'count': '1.5涓?},
    {'icon': '馃幆', 'title': '#杩界埍璺笂鐨勬晠浜?, 'count': '1.2涓?},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _topics.map((t) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            boxShadow: AppTheme.softShadow,
          ),
          child: Row(
            children: [
              Text(t['icon']!, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t['title']!,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      '${t['count']}浜哄弬涓?,
                      style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: AppTheme.textSecondary, size: 16),
            ],
          ),
        ),
      )).toList(),
    );
  }
}

class _CommunityList extends StatelessWidget {
  const _CommunityList();

  final List<Map<String, String>> _groups = const [
    {'icon': '馃尭', 'name': '澶辨亱浜掑姪缇?, 'member': '328浜?},
    {'icon': '馃挐', 'name': '鎭嬬埍鎴愰暱绀?, 'member': '512浜?},
    {'icon': '馃寵', 'name': '娣卞鏍戞礊', 'member': '256浜?},
    {'icon': '鈽€锔?, 'name': '姝ｅ悜鑳介噺鍦?, 'member': '189浜?},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _groups.map((g) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            boxShadow: AppTheme.softShadow,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Text(g['icon']!, style: const TextStyle(fontSize: 24)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      g['name']!,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      g['member']!,
                      style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  _globalState.joinGroup(g['name']!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('馃崜 宸插姞鍏?{g['name']}锛?)),
                  );
                },
                child: const Text('鍔犲叆'),
              ),
            ],
          ),
        ),
      )).toList(),
    );
  }
}

// ==================== 鎴戠殑 Tab ====================
class MyTab extends StatelessWidget {
  const MyTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('馃懁 鎴戠殑'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          // 鐢ㄦ埛淇℃伅鍗＄墖
          ListenableBuilder(
            listenable: _globalState,
            builder: (_, __) => _buildProfileCard(),
          ),
          const SizedBox(height: 20),
          // 鑽夎帗鍐滃満
          ListenableBuilder(
            listenable: _globalState,
            builder: (_, __) => _buildFarmCard(),
          ),
          const SizedBox(height: 20),
          // 鎴愬氨
          ListenableBuilder(
            listenable: _globalState,
            builder: (_, __) => _buildAchievementsCard(),
          ),
          const SizedBox(height: 20),
          // 鍔熻兘鍒楄〃
          _buildMenuList(context),
          const SizedBox(height: 20),
          // 鐧诲嚭鎸夐挳
          _buildLogoutButton(context),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, AppTheme.primaryLight],
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('馃崜', style: TextStyle(fontSize: 36)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _globalState.username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_globalState.currentMood} 娌绘剤绗?{_globalState.healingDay}澶?,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFarmCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '馃崜 鑽夎帗鍐滃満',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _FarmItem(
                  emoji: '馃尡',
                  label: '鑽夎帗鑻?,
                  unlocked: _globalState.farmItems['鑽夎帗鑻?]!,
                ),
                _FarmItem(
                  emoji: '馃崜',
                  label: '灏忚崏鑾?,
                  unlocked: _globalState.farmItems['灏忚崏鑾?]!,
                ),
                _FarmItem(
                  emoji: '馃崜',
                  label: '澶ц崏鑾?,
                  unlocked: _globalState.farmItems['澶ц崏鑾?]!,
                  size: 36,
                ),
                _FarmItem(
                  emoji: '馃憫馃崜',
                  label: '鑽夎帗鐜?,
                  unlocked: _globalState.farmItems['鑽夎帗鐜?]!,
                  size: 40,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsCard() {
    final achievements = [
      {'icon': '馃専', 'name': '鑾撶苯鏀堕泦鑰?, 'desc': '鑾峰緱50绮掕帗绫?, 'unlocked': _globalState.achievements.contains('鑾撶苯鏀堕泦鑰?)},
      {'icon': '馃弳', 'name': '鑾撶苯澶у笀', 'desc': '鑾峰緱100绮掕帗绫?, 'unlocked': _globalState.achievements.contains('鑾撶苯澶у笀')},
      {'icon': '馃摑', 'name': '鏃ヨ杈句汉', 'desc': '鍐欐弧3绡囨棩璁?, 'unlocked': _globalState.achievements.contains('鏃ヨ杈句汉')},
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '馃弲 鎴戠殑鎴愬氨',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ...achievements.map((a) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Text(
                    a['icon'] as String,
                    style: TextStyle(
                      fontSize: 28,
                      color: a['unlocked'] as bool ? null : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          a['name'] as String,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: a['unlocked'] as bool ? AppTheme.textPrimary : Colors.grey,
                          ),
                        ),
                        Text(
                          a['desc'] as String,
                          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  if (a['unlocked'] as bool)
                    const Icon(Icons.check_circle, color: AppTheme.greenAccent, size: 22)
                  else
                    const Icon(Icons.lock_outline, color: Colors.grey, size: 22),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuList(BuildContext context) {
    final menus = [
      {'icon': Icons.history, 'title': '鍘嗗彶璁板綍', 'color': Colors.blue},
      {'icon': Icons.bookmark_outline, 'title': '鎴戠殑鏀惰棌', 'color': Colors.orange},
      {'icon': Icons.notifications_outlined, 'title': '娑堟伅閫氱煡', 'color': Colors.red},
      {'icon': Icons.help_outline, 'title': '甯姪涓庡弽棣?, 'color': Colors.purple},
    ];
    return Card(
      child: Column(
        children: menus.asMap().entries.map((entry) {
          final i = entry.key;
          final m = entry.value;
          return Column(
            children: [
              ListTile(
                leading: Icon(m['icon'] as IconData, color: m['color'] as Color),
                title: Text(m['title'] as String),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.textSecondary),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${m['title']} - 鍔熻兘寮€鍙戜腑')),
                  );
                },
              ),
              if (i < menus.length - 1) const Divider(height: 1, indent: 56),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('纭畾瑕侀€€鍑虹櫥褰曞悧锛?),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('鍙栨秷'),
              ),
              ElevatedButton(
                onPressed: () {
                  _globalState.logout();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('纭畾閫€鍑?),
              ),
            ],
          ),
        );
      },
      icon: const Icon(Icons.logout, color: Colors.red),
      label: const Text('閫€鍑虹櫥褰?, style: TextStyle(color: Colors.red)),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.red),
        minimumSize: const Size(double.infinity, 48),
      ),
    );
  }
}

// 鍐滃満鐗╁搧缁勪欢
class _FarmItem extends StatelessWidget {
  final String emoji;
  final String label;
  final bool unlocked;
  final double size;

  const _FarmItem({
    required this.emoji,
    required this.label,
    required this.unlocked,
    this.size = 28,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          emoji,
          style: TextStyle(
            fontSize: size,
            color: unlocked ? null : Colors.grey.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: unlocked ? AppTheme.textPrimary : Colors.grey,
          ),
        ),
      ],
    );
  }
}

// ==================== 鑾撶浘瀹堟姢鐣岄潰 ====================
class MeiDunScreen extends StatelessWidget {
  const MeiDunScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('馃洝锔?鑾撶浘瀹堟姢')),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          // 椤堕儴浠嬬粛
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8E24AA), Color(0xFFAD1457)],
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            ),
            child: const Column(
              children: [
                Text('馃洝锔?, style: TextStyle(fontSize: 56)),
                SizedBox(height: 12),
                Text(
                  '鑾撶浘瀹堟姢',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '浜嗚В浜插瘑杈圭晫锛屼繚鎶よ嚜宸?,
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // 鍔熻兘鍒楄〃
          _buildFeatureCard(
            '馃毃', '璇嗗埆鍗遍櫓淇″彿',
            '瀛︿範璇嗗埆涓嶅仴搴峰叧绯荤殑棰勮淇″彿',
            ['鎺у埗娆茶繃寮?, '瑷€璇船浣?, '瀛ょ珛浣犱笌鏈嬪弸瀹朵汉', '鎯呯华鏆村姏'],
          ),
          const SizedBox(height: 12),
          _buildFeatureCard(
            '馃搵', '鍋ュ悍鍏崇郴鏍囧噯',
            '浠€涔堟槸鍋ュ悍鐨勬亱鐖卞叧绯伙紵',
            ['鐩镐簰灏婇噸', '骞崇瓑娌熼€?, '鏀寔褰兼鎴愰暱', '淇濇寔鐙珛绌洪棿'],
          ),
          const SizedBox(height: 12),
          _buildFeatureCard(
            '馃啒', '绱ф€ユ眰鍔?,
            '濡傞亣绱ф€ユ儏鍐碉紝璇峰姹傚府鍔?,
            ['鎶ヨ锛?10', '蹇冪悊鎻村姪鐑嚎锛?00-161-9995', '濡囪仈鐑嚎锛?2338'],
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(String icon, String title, String subtitle, List<String> items) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(icon, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: items.map((item) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  item,
                  style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== 璁剧疆鐣岄潰 ====================
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('鈿欙笍 璁剧疆')),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          // 娣辫壊妯″紡鍜屾坊鍔犲埌妗岄潰
          Card(
            child: Column(
              children: [
                // 娣辫壊妯″紡
                ListenableBuilder(
                  listenable: _globalState,
                  builder: (_, __) => SwitchListTile(
                    secondary: const Icon(Icons.dark_mode_outlined),
                    title: const Text('娣辫壊妯″紡'),
                    subtitle: const Text('寮€鍚悗鐣岄潰灏嗗彉涓烘繁鑹蹭富棰?),
                    value: _globalState.isDarkMode,
                    onChanged: (value) => _globalState.setDarkMode(value),
                    activeColor: AppTheme.primary,
                  ),
                ),
                const Divider(height: 1, indent: 56),
                // 娣诲姞鍒版闈?                ListTile(
                  leading: const Icon(Icons.add_to_home_screen_outlined),
                  title: const Text('娣诲姞鍒版闈?),
                  subtitle: const Text('灏嗗簲鐢ㄦ坊鍔犲埌鎵嬫満妗岄潰锛岀绾夸娇鐢?),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _showInstallGuide(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // 閫氱煡鍜屽叾浠栬缃?          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.notifications_outlined),
                  title: const Text('閫氱煡璁剧疆'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('鍔熻兘寮€鍙戜腑...')),
                    );
                  },
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text('闅愮鏀跨瓥'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _showPrivacyPolicy(context),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('鍏充簬鎴戜滑'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _showAboutUs(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // 涓嬭浇妗岄潰搴旂敤
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.computer, color: AppTheme.primary, size: 32),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('馃捇 涓嬭浇妗岄潰搴旂敤', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text('Windows/Mac/Linux 鐙珛杩愯', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('涓嬭浇鍚庡弻鍑诲嵆鍙繍琛岋紝鏃犻渶娴忚鍣紝鏀寔妯珫灞忓垏鎹紝鏁版嵁鑷姩鍚屾', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showDesktopDownload(context),
                      icon: const Icon(Icons.download),
                      label: const Text('涓€閿笅杞藉畨瑁呭寘', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMedium)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 鐗堟湰淇℃伅
          Card(
            child: ListTile(
              leading: const Icon(Icons.update, color: AppTheme.primary),
              title: const Text('妫€鏌ユ洿鏂?),
              subtitle: const Text('褰撳墠鐗堟湰 1.0.1'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('褰撳墠宸叉槸鏈€鏂扮増鏈紒')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showInstallGuide(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.65,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLarge)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // 鎷栧姩鏉?            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Text('馃摫', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            const Text(
              '娣诲姞鍒版闈?,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '璁╂兂浜嗚帗鎴愪负浣犵殑涓撳睘灏忕▼搴?,
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            // 瀹夎姝ラ
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildStepCard(
                      context,
                      '1',
                      '馃搷 鎵撳紑娴忚鍣ㄨ彍鍗?,
                      '鐐瑰嚮娴忚鍣ㄥ彸涓婅鐨勮彍鍗曟寜閽紙鈰?鎴?鈥⑩€⑩€級',
                      Icons.more_vert,
                    ),
                    const SizedBox(height: 12),
                    _buildStepCard(
                      context,
                      '2',
                      '馃摬 閫夋嫨"娣诲姞鍒颁富灞忓箷"',
                      '鍦ㄨ彍鍗曚腑鎵惧埌"娣诲姞鍒颁富灞忓箷"鎴?瀹夎搴旂敤"閫夐」',
                      Icons.add_to_home_screen,
                    ),
                    const SizedBox(height: 12),
                    _buildStepCard(
                      context,
                      '3',
                      '鉁?瀹屾垚娣诲姞',
                      '鐐瑰嚮娣诲姞鍚庯紝搴旂敤鍥炬爣灏变細鍑虹幇鍦ㄤ綘鐨勬墜鏈烘闈笂',
                      Icons.check_circle_outline,
                    ),
                    const SizedBox(height: 20),
                    // 鐗圭偣璇存槑
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                      ),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.offline_bolt, color: AppTheme.primary, size: 20),
                              SizedBox(width: 8),
                              Text(
                                '绂荤嚎浣跨敤',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '娣诲姞鍚庢棤闇€鎵撳紑娴忚鍣紝鐩存帴浠庢闈㈡墦寮€鍗冲彲浣跨敤锛?
                            '骞舵敮鎸佺绾胯闂儴鍒嗗姛鑳斤紒',
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // 灏濊瘯鑷姩瀹夎鎸夐挳
            ElevatedButton.icon(
              onPressed: () {
                _tryInstallPWA(context);
              },
              icon: const Icon(Icons.download),
              label: const Text('灏濊瘯鑷姩瀹夎'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCard(
    BuildContext context,
    String number,
    String title,
    String description,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: AppTheme.primary.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Icon(icon, color: AppTheme.primary, size: 24),
        ],
      ),
    );
  }

  void _tryInstallPWA(BuildContext context) async {
    try {
      // 鎻愮ず鐢ㄦ埛閫氳繃娴忚鍣ㄨ彍鍗曞畨瑁?PWA
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('馃摫 璇蜂娇鐢ㄦ祻瑙堝櫒"娣诲姞鍒颁富灞忓箷"鍔熻兘瀹夎搴旂敤'),
          duration: Duration(seconds: 3),
        ),
      );
      // 灞曠ず鎻愮ず
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.info_outline, color: AppTheme.primary),
                SizedBox(width: 8),
                Text('鎻愮ず'),
              ],
            ),
            content: const Text(
              '鐢变簬娴忚鍣ㄥ畨鍏ㄩ檺鍒讹紝\n瀹夎搴旂敤闇€瑕佹偍鍦ㄥ脊鍑虹殑鎻愮ず涓‘璁ゃ€俓n\n'
              '鎮ㄤ篃鍙互鎸夌収涓婇潰鐨勬墜鍔ㄦ楠ゆ坊鍔犲埌妗岄潰銆?,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('鐭ラ亾浜?),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // 闈?Web 鐜
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('褰撳墠鐜涓嶆敮鎸佽嚜鍔ㄥ畨瑁咃細$e')),
        );
      }
    }
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('馃敀 闅愮鏀跨瓥'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '鎯充簡鑾撻殣绉佹斂绛?,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 12),
              Text(
                '1. 鏁版嵁鏀堕泦锛氭垜浠粎鏀堕泦鎮ㄤ富鍔ㄦ彁渚涚殑淇℃伅锛岀敤浜庡簲鐢ㄥ姛鑳姐€俓n\n'
                '2. 鏁版嵁瀛樺偍锛氭偍鐨勬暟鎹瓨鍌ㄥ湪鏈湴璁惧锛屾垜浠笉浼氫笂浼犳偍鐨勪釜浜轰俊鎭€俓n\n'
                '3. 绗笁鏂规湇鍔★細鎴戜滑浣跨敤 Netlify 杩涜搴旂敤鎵樼锛屽彲鑳芥敹闆嗘湁闄愮殑璁块棶鏃ュ織銆俓n\n'
                '4. 鑱旂郴鏂瑰紡锛氬鏈夐棶棰橈紝璇疯仈绯绘垜浠€?,
                style: TextStyle(height: 1.6),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('鍏抽棴'),
          ),
        ],
      ),
    );
  }

  void _showAboutUs(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Row(
          children: [
            Text('馃崜', style: TextStyle(fontSize: 28)),
            SizedBox(width: 8),
            Text('鎯充簡鑾?),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('鐗堟湰锛?.0.1'),
            SizedBox(height: 8),
            Text('涓€涓俯鏆栫殑鎯呮劅娌绘剤灏忓畤瀹?),
            SizedBox(height: 12),
            Text(
              '馃挐 鎭嬬埍鏀荤暐 | 馃尡 澶辨亱鐤楁剤 | 馃實 鑾撳弸鏄熺悆\n\n'
              '鐢ㄥ績闄即锛屾瘡涓€澶?,
              style: TextStyle(height: 1.5),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('鍏抽棴'),
          ),
        ],
      ),
    );
  }

  void _showDesktopDownload(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.55,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 24),
            const Text('馃捇', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            const Text('涓嬭浇妗岄潰搴旂敤', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('閫夋嫨浣犵殑鎿嶄綔绯荤粺', style: TextStyle(color: AppTheme.textSecondary)),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildDownloadCard(
                      context,
                      icon: Icons.window,
                      title: 'Windows',
                      desc: 'Windows 10/11 (.exe)',
                      onTap: () => _downloadDesktopApp(context, 'windows'),
                    ),
                    const SizedBox(height: 12),
                    _buildDownloadCard(
                      context,
                      icon: Icons.laptop_mac,
                      title: 'macOS',
                      desc: 'Intel & Apple Silicon (.dmg)',
                      onTap: () => _downloadDesktopApp(context, 'macos'),
                    ),
                    const SizedBox(height: 12),
                    _buildDownloadCard(
                      context,
                      icon: Icons.terminal,
                      title: 'Linux',
                      desc: 'Ubuntu/Debian (.AppImage)',
                      onTap: () => _downloadDesktopApp(context, 'linux'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('鍙栨秷'),
              style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 46)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadCard(BuildContext context, {required IconData icon, required String title, required String desc, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppTheme.primary, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                  Text(desc, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.download, color: AppTheme.primary),
          ],
        ),
      ),
    );
  }

  void _downloadDesktopApp(BuildContext context, String platform) {
    // 鏄剧ず涓嬭浇鎻愮ず
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        content: Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primary),
            ),
            SizedBox(width: 16),
            Text('姝ｅ湪鍑嗗涓嬭浇...'),
          ],
        ),
      ),
    );

    // 妯℃嫙涓嬭浇寤惰繜锛岀劧鍚庤烦杞埌 Electron 涓嬭浇椤甸潰
    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.pop(context); // 鍏抽棴鍔犺浇寮圭獥
      Navigator.pop(context); // 鍏抽棴涓嬭浇閫夐」寮圭獥

      // 璺宠浆鍒颁笅杞介〉闈?      final uri = Uri.parse('https://lighthearted-frangipane-fb0fe3.netlify.app/download');
      launchUrl(uri, mode: LaunchMode.externalApplication);

      // 鏄剧ず鎴愬姛鎻愮ず
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('馃捇 鍗冲皢寮€濮嬩笅杞芥闈㈠簲鐢紒'),
          backgroundColor: AppTheme.primary,
                ),
      );
    });
  }
}

