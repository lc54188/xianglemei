import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';

// ==================== 应用入口 ====================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 初始化存储服务
  await StorageService.init();
  runApp(const XiangLeMeiApp());
}

// ==================== 存储服务 ====================
class StorageService {
  static late SharedPreferences _prefs;
  
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  // 键名常量
  static const String keyDarkMode = 'dark_mode';
  static const String keyUsername = 'username';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyMeiSeeds = 'mei_seeds';
  static const String keyHealingDay = 'healing_day';
  static const String keyCurrentMood = 'current_mood';
  
  // 深色模式
  static bool getDarkMode() => _prefs.getBool(keyDarkMode) ?? false;
  static Future<void> setDarkMode(bool value) => _prefs.setBool(keyDarkMode, value);
  
  // 用户名
  static String getUsername() => _prefs.getString(keyUsername) ?? '';
  static Future<void> setUsername(String value) => _prefs.setString(keyUsername, value);
  
  // 登录状态
  static bool getIsLoggedIn() => _prefs.getBool(keyIsLoggedIn) ?? false;
  static Future<void> setIsLoggedIn(bool value) => _prefs.setBool(keyIsLoggedIn, value);
  
  // 莓籽数
  static int getMeiSeeds() => _prefs.getInt(keyMeiSeeds) ?? 0;
  static Future<void> setMeiSeeds(int value) => _prefs.setInt(keyMeiSeeds, value);
  
  // 治愈天数
  static int getHealingDay() => _prefs.getInt(keyHealingDay) ?? 0;
  static Future<void> setHealingDay(int value) => _prefs.setInt(keyHealingDay, value);
  
  // 当前心情
  static String getCurrentMood() => _prefs.getString(keyCurrentMood) ?? '🍓';
  static Future<void> setCurrentMood(String value) => _prefs.setString(keyCurrentMood, value);
  
  // 清除所有数据
  static Future<void> clear() => _prefs.clear();
}

// ==================== 性能优化常量 ====================
const bool kDebugOptimize = false; // 生产环境关闭调试

// ==================== 主题配置 ====================
class AppTheme {
  // 品牌色系
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

  // 深色模式色系
  static const Color darkBackground = Color(0xFF1A1A2E);
  static const Color darkSurface = Color(0xFF252538);
  static const Color darkCardBg = Color(0xFF2D2D44);
  static const Color darkTextPrimary = Color(0xFFF5F5F5);
  static const Color darkTextSecondary = Color(0xFFB0B0C0);
  static const Color darkSecondary = Color(0xFF4A4A6A);
  
  // 安卓状态栏适配
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

  // 圆角常量
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 24.0;
  static const double radiusXLarge = 32.0;

  // 阴影样式
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

  // 亮色主题
  static ThemeData get theme => _buildTheme(Brightness.light);

  // 暗色主题
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
      cardTheme: CardThemeData(
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
      dialogTheme: DialogThemeData(
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

// ==================== 数据模型 ====================
class AppState extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _username = '';
  int _meiSeeds = 0;
  String _currentMood = '🍓';
  List<DiaryEntry> _diaries = [];
  List<String> _joinedGroups = [];
  int _healingDay = 0;
  List<String> _achievements = [];
  bool _isDarkMode = false; // 深色模式状态
  Map<String, bool> _farmItems = {
    '草莓苗': true,
    '小草莓': false,
    '大草莓': false,
    '草莓王': false,
  };

  // 构造函数：从存储加载数据
  AppState() {
    _loadFromStorage();
  }

  // 从存储加载数据
  void _loadFromStorage() {
    _isDarkMode = StorageService.getDarkMode();
    _isLoggedIn = StorageService.getIsLoggedIn();
    _username = StorageService.getUsername();
    _meiSeeds = StorageService.getMeiSeeds();
    _healingDay = StorageService.getHealingDay();
    _currentMood = StorageService.getCurrentMood();
  }

  // 性能优化：getter直接返回，减少函数调用开销
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
    _username = name.isEmpty ? '莓莓用户' : name;
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
    if (_meiSeeds >= 50 && !_achievements.contains('莓籽收集者')) {
      _achievements.add('莓籽收集者');
    }
    if (_meiSeeds >= 100 && !_achievements.contains('莓籽大师')) {
      _achievements.add('莓籽大师');
    }
    if (_diaries.length >= 3 && !_achievements.contains('日记达人')) {
      _achievements.add('日记达人');
    }
  }

  void _checkFarmGrowth() {
    if (_healingDay >= 3 && !_farmItems['小草莓']!) {
      _farmItems['小草莓'] = true;
    }
    if (_healingDay >= 7 && !_farmItems['大草莓']!) {
      _farmItems['大草莓'] = true;
    }
    if (_healingDay >= 21 && !_farmItems['草莓王']!) {
      _farmItems['草莓王'] = true;
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

// ==================== 全局状态单例 ====================
final AppState _globalState = AppState();

// ==================== 页面过渡动画 ====================
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

// ==================== 主应用 ====================
class XiangLeMeiApp extends StatelessWidget {
  const XiangLeMeiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _globalState,
      builder: (context, _) {
        final isDark = _globalState.isDarkMode;
        return MaterialApp(
          title: '想了莓',
          theme: AppTheme.theme,
          darkTheme: AppTheme.darkTheme,
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          debugShowCheckedModeBanner: false,
          // 全局页面过渡动画
          builder: (context, child) {
            // 横竖屏适配：响应式布局
            return OrientationBuilder(
              builder: (context, orientation) {
                // 根据屏幕方向调整UI
                final isLandscape = orientation == Orientation.landscape;
                final screenSize = MediaQuery.of(context).size;
                final isTablet = screenSize.shortestSide >= 600;
                
                // 设置系统UI样式
                SystemChrome.setSystemUIOverlayStyle(
                  isDark ? AppTheme.darkSystemOverlayStyle : AppTheme.systemOverlayStyle,
                );
                
                // 允许横竖屏切换
                SystemChrome.setPreferredOrientations([
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

// 性能优化：独立的认证路由组件
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

// ==================== 引导页 ====================
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
      icon: '🍓',
      title: '欢迎来到想了莓',
      subtitle: '一个属于你的情感治愈小宇宙',
      gradient: [Color(0xFFFF6B8A), Color(0xFFFF8FAB)],
    ),
    _OnboardingPageData(
      icon: '💝',
      title: '恋爱技巧全攻略',
      subtitle: 'AI助手帮你搞定每一次心动时刻',
      gradient: [Color(0xFFFF4D6D), Color(0xFFFF6B8A)],
    ),
    _OnboardingPageData(
      icon: '🌱',
      title: '失恋也能重新开始',
      subtitle: '21天治愈计划，陪你慢慢走出来',
      gradient: [Color(0xFFFF8FAB), Color(0xFFFFB3C6)],
    ),
    _OnboardingPageData(
      icon: '🛡️',
      title: '守护你的健康与边界',
      subtitle: '莓盾守护，让爱更安全',
      gradient: [Color(0xFFC9184A), Color(0xFFE55A7A)],
    ),
    _OnboardingPageData(
      icon: '🌟',
      title: '找到你的莓友星球',
      subtitle: '志同道合的朋友就在这里等你',
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
          // 页面内容
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _pages.length,
            itemBuilder: (context, index) => _OnboardingPage(data: _pages[index]),
          ),
          // 底部控制区
          Positioned(
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
                  // 页面指示器
                  _PageIndicator(
                    count: _pages.length,
                    currentIndex: _currentPage,
                  ),
                  const SizedBox(height: 24),
                  // 按钮
                  _GradientButton(
                    onPressed: _nextPage,
                    child: Text(
                      _currentPage < _pages.length - 1 ? '下一步' : '开始体验 🍓',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                  // 跳过按钮
                  if (_currentPage < _pages.length - 1) ...[
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => _showLoginSheet(context),
                      child: const Text(
                        '跳过',
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

// 引导页数据模型
class _OnboardingPageData {
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

// 引导页单个页面
class _OnboardingPage extends StatelessWidget {
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
              // 图标（带动画效果）
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.8, end: 1.0),
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut,
                builder: (context, value, child) => Transform.scale(
                  scale: value,
                  child: Text(data.icon, style: const TextStyle(fontSize: 100)),
                ),
              ),
              const SizedBox(height: 40),
              // 标题
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
              // 副标题
              Text(
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

// 页面指示器
class _PageIndicator extends StatelessWidget {
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

// 渐变按钮组件
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

// ==================== 登录弹窗 ====================
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
    _globalState.login(name.isNotEmpty ? name : '莓莓用户');
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
            // 拖动条
            Center(
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
            // Logo和标题
            Center(
              child: Column(
                children: [
                  const Text('🍓', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 8),
                  Text(
                    '想了莓',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isRegister ? '创建你的莓莓账号' : '欢迎回来，莓莓人！',
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            // 昵称输入（注册模式）
            if (_isRegister) ...[
              _buildTextField(
                controller: _nameController,
                focusNode: _focusNode1,
                label: '昵称',
                hint: '给自己起个可爱的名字 🍓',
                prefixIcon: Icons.person_outline,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
            ],
            // 手机号/邮箱输入
            _buildTextField(
              controller: _phoneController,
              focusNode: _focusNode2,
              label: '手机号 / 邮箱',
              hint: '请输入账号',
              prefixIcon: Icons.phone_android_outlined,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _handleLogin(),
            ),
            const SizedBox(height: 24),
            // 登录/注册按钮
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _handleLogin,
                child: Text(
                  _isRegister ? '注册并开始 🍓' : '登录',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // 切换注册/登录
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isRegister ? '已有账号？' : '还没有账号？',
                  style: const TextStyle(color: AppTheme.textSecondary),
                ),
                TextButton(
                  onPressed: () => setState(() => _isRegister = !_isRegister),
                  child: Text(
                    _isRegister ? '直接登录' : '立即注册',
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // 微信快捷登录
            Center(
              child: OutlinedButton.icon(
                onPressed: () {
                  _globalState.login('微信用户');
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.chat_bubble_outline, color: Color(0xFF07C160)),
                label: const Text(
                  '微信快捷登录',
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

// ==================== 主界面（底部导航） ====================
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

// 安卓优化的底部导航栏
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
                label: '首页',
                isSelected: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                icon: Icons.favorite_border,
                activeIcon: Icons.favorite,
                label: '莓好攻略',
                isSelected: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _NavItem(
                icon: Icons.eco_outlined,
                activeIcon: Icons.eco,
                label: '莓完待续',
                isSelected: currentIndex == 2,
                onTap: () => onTap(2),
              ),
              _NavItem(
                icon: Icons.public_outlined,
                activeIcon: Icons.public,
                label: '莓友星球',
                isSelected: currentIndex == 3,
                onTap: () => onTap(3),
              ),
              _NavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: '我的',
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

// ==================== 首页 Tab ====================
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
            // 顶部应用栏
            SliverAppBar(
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
                              '你好，${_globalState.username} ${_globalState.currentMood}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '今天也要元气满满哦～',
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
                  Text('🍓', style: TextStyle(fontSize: 24)),
                  SizedBox(width: 8),
                  Text('想了莓'),
                ],
              ),
            ),
            // 内容区域
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // 莓籽卡片
                  ListenableBuilder(
                    listenable: _globalState,
                    builder: (_, __) => const _SeedsCard(),
                  ),
                  const SizedBox(height: 16),
                  // 今日心情
                  const _MoodSelector(),
                  const SizedBox(height: 20),
                  // 核心功能标题
                  const _SectionTitle(title: '核心功能', icon: Icons.grid_view_rounded),
                  const SizedBox(height: 12),
                  // 功能网格
                  _FunctionGrid(),
                  const SizedBox(height: 20),
                  // 莓盾守护
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

// 区块标题组件
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

// 莓籽卡片
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
            const Text('🍓', style: TextStyle(fontSize: 48)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '我的莓籽',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  Text(
                    '${_globalState.meiSeeds} 粒',
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
                '治愈第 ${_globalState.healingDay} 天',
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 心情选择器
class _MoodSelector extends StatelessWidget {
  const _MoodSelector();

  static const _moods = ['🍓', '😊', '😢', '😡', '🌸', '💪', '🥰', '😴'];

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
                  '今日心情',
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

// 功能网格
class _FunctionGrid extends StatelessWidget {
  _FunctionGrid();

  final List<_FunctionItem> _items = const [
    _FunctionItem(icon: Icons.favorite, label: '莓好攻略', color: Color(0xFFFFE0E6), tab: 1),
    _FunctionItem(icon: Icons.eco, label: '莓完待续', color: Color(0xFFE8F5E9), tab: 2),
    _FunctionItem(icon: Icons.public, label: '莓友星球', color: Color(0xFFE3F2FD), tab: 3),
    _FunctionItem(icon: Icons.person, label: '我的', color: Color(0xFFFCE4EC), tab: 4),
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

// 莓盾守护卡片
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
            const Text('🛡️', style: TextStyle(fontSize: 40)),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '莓盾守护',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '了解亲密边界与健康知识 →',
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

// ==================== 莓好攻略 Tab ====================
class MeiHaoGongLueTab extends StatelessWidget {
  const MeiHaoGongLueTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('💝 莓好攻略'),
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
                    '🍓 ${_globalState.meiSeeds}',
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
          // AI 对话练习 - 主推
          _AICard(),
          SizedBox(height: 20),
          // 场景攻略
          _SectionTitle(title: '场景化技巧', icon: Icons.grid_view_rounded),
          SizedBox(height: 12),
          _ScenarioGrid(),
          SizedBox(height: 20),
          // 恋爱测试
          _TestCard(),
          SizedBox(height: 12),
          // 案例库
          _CaseLibraryLinkCard(),
          SizedBox(height: 100),
        ],
      ),
    );
  }
}

// AI卡片
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
                Text('🤖', style: TextStyle(fontSize: 36)),
                SizedBox(width: 12),
                Text(
                  'AI 对话练习',
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
              '"对方说在干嘛，我该怎么回？" 告诉AI你的困惑，获得高情商建议',
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
                    '开始练习 →',
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

// 场景网格
class _ScenarioGrid extends StatelessWidget {
  const _ScenarioGrid();

  final List<_Scenario> _scenarios = const [
    _Scenario(icon: '☕', title: '初次约会', desc: '如何让Ta记住你'),
    _Scenario(icon: '💬', title: '暧昧升温', desc: '把暧昧变成确认'),
    _Scenario(icon: '💌', title: '表白技巧', desc: '成功率最高的方式'),
    _Scenario(icon: '🌙', title: '挽回方法', desc: '理性地重新开始'),
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

// 测试卡片
class _TestCard extends StatelessWidget {
  const _TestCard();

  @override
  Widget build(BuildContext context) {
    return _ListCard(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoveTestScreen()),
      ),
      icon: '🧠',
      title: '恋爱性格测试',
      subtitle: '了解你的恋爱风格，获取个性化建议',
    );
  }
}

// 案例库入口卡片
class _CaseLibraryLinkCard extends StatelessWidget {
  const _CaseLibraryLinkCard();

  @override
  Widget build(BuildContext context) {
    return _ListCard(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CaseLibraryScreen()),
      ),
      icon: '📚',
      title: '真实案例库',
      subtitle: '匿名故事 + 专家解析，从别人的经历中学习',
    );
  }
}

// 列表卡片通用组件
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

// ==================== AI 对话练习界面 ====================
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
    '对方说"在干嘛"，我怎么回？',
    '喜欢的人不主动，怎么办？',
    '约会结束后如何发消息？',
    '如何自然地告白？',
  ];

  final List<String> _aiResponses = const [
    '根据对方说"在干嘛"的场景，建议你这样回复：\n\n💡 方案A（活泼型）：\n"刚刚在想你呀～你呢？"\n\n💡 方案B（神秘型）：\n"在做一件很重要的事，猜猜是什么？"\n\n💡 方案C（自然型）：\n"刷到一个很好玩的视频！分享给你～"\n\n⚠️ 温馨提示：以上建议仅供参考，请结合对方性格和你们的关系实际判断。',
    '面对喜欢的人不主动的情况：\n\n🌸 先观察Ta是否对所有人都不主动（性格原因 vs 对你不感兴趣）\n\n✨ 建议：适当主动释放信号，比如找共同话题、偶尔主动约好友一起出行。\n\n💝 记住：主动不代表掉价，真诚的表达最有魅力！\n\n⚠️ 温馨提示：感情需要双向奔赴，请保护好自己的情绪。',
    '约会结束后的最佳发消息时机：\n\n⏰ 到家后 30 分钟内：发一条轻松的消息\n"到家了！今天很开心，下次还想一起～"\n\n🚫 避免：立刻疯狂发消息、深夜轰炸\n✅ 推荐：简短真诚，给对方留有空间\n\n⚠️ 温馨提示：每段关系的节奏都不同，以上仅供参考。',
    '自然告白的几种方式：\n\n💌 方式一（创意型）：\n借助一个小礼物或特别的场景自然引出\n\n🗣️ 方式二（直接型）：\n"我喜欢你，想和你在一起"\n——简单直接，成功率最高\n\n🎭 方式三（试探型）：\n"如果有人喜欢你，你会怎么样？"\n\n⚠️ 温馨提示：无论结果如何，勇敢表达都是值得肯定的！',
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
        title: const Text('🤖 AI 恋爱助手'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showDisclaimer(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // 免责声明
          Container(
            width: double.infinity,
            color: const Color(0xFFFFF3CD),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: const Text(
              '⚠️ AI建议仅供参考，请结合实际情况判断',
              style: TextStyle(fontSize: 12, color: Color(0xFF856404)),
              textAlign: TextAlign.center,
            ),
          ),
          // 聊天内容
          Expanded(
            child: _messages.isEmpty
                ? _buildQuickQuestions()
                : _buildChatList(),
          ),
          // 输入框
          _buildInputBar(),
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
            '常见问题快捷提问：',
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
                hintText: '输入你的情感困惑...',
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
        title: const Text('⚠️ 免责声明'),
        content: const Text(
          '1. AI助手提供的建议仅供参考\n'
          '2. 不能替代专业的心理咨询\n'
          '3. 请结合实际情况和直觉判断\n'
          '4. 保护好自己的隐私和安全\n\n'
          '如有严重心理困扰，请寻求专业帮助。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('我知道了'),
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
              'AI思考中...',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== 场景详情界面 ====================
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
            '💡 核心技巧',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildTipCard('1', '保持真诚，不要刻意表演'),
          _buildTipCard('2', '关注对方的反应，随机应变'),
          _buildTipCard('3', '不要急于求成，给彼此时间'),
          const SizedBox(height: 24),
          const Text(
            '📝 实战话术',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('💬 推荐开场白：', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(
                    '"今天发现一家很棒的咖啡店，想不想一起去试试？"',
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

// ==================== 恋爱测试界面 ====================
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
      'q': '恋爱中你更倾向于？',
      'options': ['主动表达感情', '等对方先开口', '随缘，顺其自然', '用行动代替言语'],
    },
    {
      'q': '约会时你会提前多久做准备？',
      'options': ['提前几天精心准备', '当天临时决定', '提前一天想想就好', '几乎不准备，随意最好'],
    },
    {
      'q': '当和对方产生矛盾时，你会？',
      'options': ['立刻沟通解决', '先冷静一段时间', '等对方先道歉', '假装没事，忽略问题'],
    },
    {
      'q': '你认为理想的恋爱节奏是？',
      'options': ['快速确认关系', '慢慢了解，自然发展', '先成为好朋友再说', '感觉对了就马上行动'],
    },
  ];

  final Map<String, Map<String, String>> _results = {
    '主动热情型': {
      'icon': '🔥',
      'desc': '你热情奔放，敢于表达，是恋爱中的主动方。你的优势是让对方感到被重视，但要注意不要给对方太大压力。',
      'tip': '建议：适当给对方留一些空间和神秘感，会让关系更持久。',
    },
    '理性稳重型': {
      'icon': '🧊',
      'desc': '你理性而稳重，在感情中比较谨慎。你会认真分析关系，不轻易冲动。',
      'tip': '建议：适当放开心扉，勇于表达情感，让对方感受到你的温度。',
    },
    '浪漫感性型': {
      'icon': '🌸',
      'desc': '你对感情充满浪漫幻想，擅长营造氛围。你的感染力很强，能带给对方幸福感。',
      'tip': '建议：在浪漫之余，也要脚踏实地地经营日常关系。',
    },
    '随缘自在型': {
      'icon': '🌊',
      'desc': '你在感情中顺其自然，不强求。这种态度能减少很多焦虑，但也可能错过机会。',
      'tip': '建议：在对的时机，尝试主动迈出第一步，不要让缘分溜走。',
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
    final types = ['主动热情型', '理性稳重型', '浪漫感性型', '随缘自在型'];
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
      appBar: AppBar(title: const Text('🧠 恋爱性格测试')),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 进度
            Row(
              children: [
                Text(
                  '问题 ${_currentQ + 1}/${_questions.length}',
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
            // 问题卡片
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
            // 选项
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
      appBar: AppBar(title: const Text('你的恋爱性格报告')),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 结果卡片
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
            // 分析卡片
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '性格分析',
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
            // 保存按钮
            ElevatedButton.icon(
              onPressed: () {
                _globalState.addMeiSeeds(20);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('🍓 获得 20 粒莓籽！报告已保存')),
                );
                Navigator.pop(context);
              },
              icon: const Icon(Icons.save_alt),
              label: const Text('保存报告 (+20莓籽)'),
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

// ==================== 案例库界面 ====================
class CaseLibraryScreen extends StatelessWidget {
  const CaseLibraryScreen({super.key});

  static const _cases = [
    {
      'title': '异地恋三年，如何维持感情温度？',
      'tag': '异地恋',
      'summary': '匿名用户 @草莓想念你 分享了自己维持三年异地恋的心得...',
      'analysis': '专家解析：异地恋的核心是"仪式感"与"信任感"的双重建立。',
    },
    {
      'title': '暗恋了两年，该说还是不说？',
      'tag': '暗恋',
      'summary': '匿名用户 @小草莓要勇敢 的故事告诉我们，暗恋的代价...',
      'analysis': '专家解析：暗恋的最大风险是时间成本，建议适时表达。',
    },
    {
      'title': '被分手后如何正视自己的价值？',
      'tag': '失恋',
      'summary': '@莓莓加油 用亲身经历证明，失恋后的成长往往超出想象...',
      'analysis': '专家解析：失恋是一次重新认识自己的机会，关键在于归因方式。',
    },
    {
      'title': '怎么看出对方是否真的喜欢你？',
      'tag': '辨别感情',
      'summary': '汇总了100个真实案例后，这10个信号值得关注...',
      'analysis': '专家解析：行动比语言更能说明问题，观察日常细节。',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📚 真实案例库')),
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
          // 拖动条
          Center(
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
          // 标签
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
          // 标题
          Text(
            caseData['title']!,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          // 内容
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '📖 故事正文',
                    style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${caseData['summary']}\n\n（完整故事内容…这里展示案例详情，保护隐私已做匿名处理）',
                    style: const TextStyle(fontSize: 14, height: 1.7, color: AppTheme.textPrimary),
                  ),
                  const SizedBox(height: 20),
                  // 专家解析
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
                          '🔬 专家解析',
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

// ==================== 莓完待续 Tab ====================
class MeiWanDaiXuTab extends StatelessWidget {
  const MeiWanDaiXuTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('🌱 莓完待续'),
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
                    '第${_globalState.healingDay}天',
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
          '写草莓日记',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          // 情绪曲线
          ListenableBuilder(
            listenable: _globalState,
            builder: (_, __) => _buildMoodCurve(),
          ),
          const SizedBox(height: 16),
          // 治愈计划
          ListenableBuilder(
            listenable: _globalState,
            builder: (_, __) => _buildHealingPlan(context),
          ),
          const SizedBox(height: 16),
          // 疗愈工具
          _buildHealingTools(context),
          const SizedBox(height: 16),
          // 专业帮助
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
                  '📊 情绪曲线',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  '共记录 ${_globalState.diaries.length} 篇',
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
                      Text('🍓', style: TextStyle(fontSize: 48)),
                      SizedBox(height: 12),
                      Text(
                        '还没有记录～\n点击右下角"写草莓日记"开始吧',
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
                  '🌱 21天治愈计划',
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
                    '今日任务',
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
                    const SnackBar(content: Text('🍓 打卡成功！获得 15 粒莓籽！')),
                  );
                },
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('打卡完成 (+15莓籽)'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDayTask(int day) {
    final tasks = [
      '整理一件旧物并拍照记录',
      '给自己写一封信，说出三个优点',
      '学一首新歌，哼给自己听',
      '出门散步20分钟，感受阳光',
      '尝试做一道从未做过的菜',
      '联系一位许久未联系的朋友',
      '整理你的手机相册，保留美好',
      '写下5件让你感恩的事',
      '尝试一项新的兴趣爱好',
      '看一部让你开心的电影',
      '制定下个月的一个小目标',
      '为自己买一件小礼物',
      '冥想10分钟，专注呼吸',
      '和家人打一个温暖的电话',
      '记录今天所有美好的瞬间',
      '尝试运动或瑜伽30分钟',
      '重新布置你的房间一角',
      '阅读一篇鼓励自己的文章',
      '和朋友分享一个快乐故事',
      '为完成这段旅程奖励自己',
    ];
    return tasks[min(day, tasks.length - 1)];
  }

  Widget _buildHealingTools(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(title: '🧰 疗愈工具包', icon: Icons.build_outlined),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ToolCard(
                icon: '🎵',
                title: '白噪音冥想',
                subtitle: '草莓主题ASMR',
                onTap: () => _showASMRSheet(context),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ToolCard(
                icon: '🌳',
                title: '虚拟树洞',
                subtitle: '匿名倾诉',
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
            const Text('🎵', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            const Text(
              '白噪音冥想',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '功能开发中，敬请期待...',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('关闭'),
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
            const Text('🌳', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            const Text(
              '虚拟树洞',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '在这里，你可以匿名倾诉...\n功能开发中，敬请期待...',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('关闭'),
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
              child: const Text('👩‍⚕️', style: TextStyle(fontSize: 28)),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '联系专业咨询师',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    '专业心理咨询，付费预约',
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
        title: const Text('👩‍⚕️ 专业咨询'),
        content: const Text(
          '专业心理咨询服务\n\n'
          '• 一对一情感咨询\n'
          '• 心理状态评估\n'
          '• 个性化治愈方案\n\n'
          '📞 咨询方式：在线视频/语音\n'
          '💰 费用：根据咨询师而定\n\n'
          '功能开发中，敬请期待...',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
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

// ==================== 写日记界面 ====================
class WriteDiaryScreen extends StatefulWidget {
  const WriteDiaryScreen({super.key});

  @override
  State<WriteDiaryScreen> createState() => _WriteDiaryScreenState();
}

class _WriteDiaryScreenState extends State<WriteDiaryScreen> {
  final _contentController = TextEditingController();
  String _selectedMood = '🍓';

  final _moods = ['🍓', '😊', '😢', '😡', '🌸', '💪', '🥰', '😴'];

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请写下你的心情...')),
      );
      return;
    }
    _globalState.addDiary(DiaryEntry(
      mood: _selectedMood,
      content: _contentController.text.trim(),
      time: DateTime.now(),
      aiAdvice: '记录是一种很好的自我疗愈方式～',
    ));
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🍓 日记已保存，获得 5 粒莓籽！')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🍓 写草莓日记'),
        actions: [
          TextButton(
            onPressed: _submit,
            child: const Text(
              '保存',
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
              '今天的心情',
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
              '写下你的故事',
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
                hintText: '今天发生了什么让你开心/难过的事情？\n把心事写下来吧...',
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
                label: const Text('保存日记 (+5莓籽)'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== 莓友星球 Tab ====================
class MeiYouXingQiuTab extends StatelessWidget {
  const MeiYouXingQiuTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('🌍 莓友星球')),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: const [
          // 星球介绍
          _PlanetIntro(),
          SizedBox(height: 20),
          // 话题广场
          _SectionTitle(title: '🔥 热门话题', icon: Icons.local_fire_department),
          SizedBox(height: 12),
          _TopicList(),
          SizedBox(height: 20),
          // 莓友圈入口
          _SectionTitle(title: '👥 莓友圈', icon: Icons.group),
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
          Text('🌍', style: TextStyle(fontSize: 56)),
          SizedBox(height: 12),
          Text(
            '莓友星球',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '在这里遇见志同道合的朋友\n一起成长，相互治愈',
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
    {'icon': '💕', 'title': '#今天的治愈小事', 'count': '2.3万'},
    {'icon': '🌟', 'title': '#前任教会我的事', 'count': '1.8万'},
    {'icon': '💪', 'title': '#分手后的蜕变', 'count': '1.5万'},
    {'icon': '🎯', 'title': '#追爱路上的故事', 'count': '1.2万'},
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
                      '${t['count']}人参与',
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
    {'icon': '🌸', 'name': '失恋互助群', 'member': '328人'},
    {'icon': '💝', 'name': '恋爱成长社', 'member': '512人'},
    {'icon': '🌙', 'name': '深夜树洞', 'member': '256人'},
    {'icon': '☀️', 'name': '正向能量圈', 'member': '189人'},
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
                    SnackBar(content: Text('🍓 已加入${g['name']}！')),
                  );
                },
                child: const Text('加入'),
              ),
            ],
          ),
        ),
      )).toList(),
    );
  }
}

// ==================== 我的 Tab ====================
class MyTab extends StatelessWidget {
  const MyTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('👤 我的'),
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
          // 用户信息卡片
          ListenableBuilder(
            listenable: _globalState,
            builder: (_, __) => _buildProfileCard(),
          ),
          const SizedBox(height: 20),
          // 草莓农场
          ListenableBuilder(
            listenable: _globalState,
            builder: (_, __) => _buildFarmCard(),
          ),
          const SizedBox(height: 20),
          // 成就
          ListenableBuilder(
            listenable: _globalState,
            builder: (_, __) => _buildAchievementsCard(),
          ),
          const SizedBox(height: 20),
          // 功能列表
          _buildMenuList(context),
          const SizedBox(height: 20),
          // 登出按钮
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
              child: Text('🍓', style: TextStyle(fontSize: 36)),
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
                  '${_globalState.currentMood} 治愈第${_globalState.healingDay}天',
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
              '🍓 草莓农场',
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
                  emoji: '🌱',
                  label: '草莓苗',
                  unlocked: _globalState.farmItems['草莓苗']!,
                ),
                _FarmItem(
                  emoji: '🍓',
                  label: '小草莓',
                  unlocked: _globalState.farmItems['小草莓']!,
                ),
                _FarmItem(
                  emoji: '🍓',
                  label: '大草莓',
                  unlocked: _globalState.farmItems['大草莓']!,
                  size: 36,
                ),
                _FarmItem(
                  emoji: '👑🍓',
                  label: '草莓王',
                  unlocked: _globalState.farmItems['草莓王']!,
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
      {'icon': '🌟', 'name': '莓籽收集者', 'desc': '获得50粒莓籽', 'unlocked': _globalState.achievements.contains('莓籽收集者')},
      {'icon': '🏆', 'name': '莓籽大师', 'desc': '获得100粒莓籽', 'unlocked': _globalState.achievements.contains('莓籽大师')},
      {'icon': '📝', 'name': '日记达人', 'desc': '写满3篇日记', 'unlocked': _globalState.achievements.contains('日记达人')},
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🏅 我的成就',
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
      {'icon': Icons.history, 'title': '历史记录', 'color': Colors.blue},
      {'icon': Icons.bookmark_outline, 'title': '我的收藏', 'color': Colors.orange},
      {'icon': Icons.notifications_outlined, 'title': '消息通知', 'color': Colors.red},
      {'icon': Icons.help_outline, 'title': '帮助与反馈', 'color': Colors.purple},
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
                    SnackBar(content: Text('${m['title']} - 功能开发中')),
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
            title: const Text('确定要退出登录吗？'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('取消'),
              ),
              ElevatedButton(
                onPressed: () {
                  _globalState.logout();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('确定退出'),
              ),
            ],
          ),
        );
      },
      icon: const Icon(Icons.logout, color: Colors.red),
      label: const Text('退出登录', style: TextStyle(color: Colors.red)),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.red),
        minimumSize: const Size(double.infinity, 48),
      ),
    );
  }
}

// 农场物品组件
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

// ==================== 莓盾守护界面 ====================
class MeiDunScreen extends StatelessWidget {
  const MeiDunScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🛡️ 莓盾守护')),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          // 顶部介绍
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
                Text('🛡️', style: TextStyle(fontSize: 56)),
                SizedBox(height: 12),
                Text(
                  '莓盾守护',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '了解亲密边界，保护自己',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // 功能列表
          _buildFeatureCard(
            '🚨', '识别危险信号',
            '学习识别不健康关系的预警信号',
            ['控制欲过强', '言语贬低', '孤立你与朋友家人', '情绪暴力'],
          ),
          const SizedBox(height: 12),
          _buildFeatureCard(
            '📋', '健康关系标准',
            '什么是健康的恋爱关系？',
            ['相互尊重', '平等沟通', '支持彼此成长', '保持独立空间'],
          ),
          const SizedBox(height: 12),
          _buildFeatureCard(
            '🆘', '紧急求助',
            '如遇紧急情况，请寻求帮助',
            ['报警：110', '心理援助热线：400-161-9995', '妇联热线：12338'],
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

// ==================== 设置界面 ====================
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('⚙️ 设置')),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          // 深色模式和添加到桌面
          Card(
            child: Column(
              children: [
                // 深色模式
                ListenableBuilder(
                  listenable: _globalState,
                  builder: (_, __) => SwitchListTile(
                    secondary: const Icon(Icons.dark_mode_outlined),
                    title: const Text('深色模式'),
                    subtitle: const Text('开启后界面将变为深色主题'),
                    value: _globalState.isDarkMode,
                    onChanged: (value) => _globalState.setDarkMode(value),
                    activeColor: AppTheme.primary,
                  ),
                ),
                const Divider(height: 1, indent: 56),
                // 添加到桌面
                ListTile(
                  leading: const Icon(Icons.add_to_home_screen_outlined),
                  title: const Text('添加到桌面'),
                  subtitle: const Text('将应用添加到手机桌面，离线使用'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _showInstallGuide(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // 通知和其他设置
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.notifications_outlined),
                  title: const Text('通知设置'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('功能开发中...')),
                    );
                  },
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text('隐私政策'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _showPrivacyPolicy(context),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('关于我们'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _showAboutUs(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // 下载桌面应用
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
                            Text('💻 下载桌面应用', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text('Windows/Mac/Linux 独立运行', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('下载后双击即可运行，无需浏览器，支持横竖屏切换，数据自动同步', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showDesktopDownload(context),
                      icon: const Icon(Icons.download),
                      label: const Text('一键下载安装包', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
          // 版本信息
          Card(
            child: ListTile(
              leading: const Icon(Icons.update, color: AppTheme.primary),
              title: const Text('检查更新'),
              subtitle: const Text('当前版本 1.0.1'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('当前已是最新版本！')),
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
            // 拖动条
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Text('📱', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            const Text(
              '添加到桌面',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '让想了莓成为你的专属小程序',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            // 安装步骤
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildStepCard(
                      context,
                      '1',
                      '📍 打开浏览器菜单',
                      '点击浏览器右上角的菜单按钮（⋮ 或 •••）',
                      Icons.more_vert,
                    ),
                    const SizedBox(height: 12),
                    _buildStepCard(
                      context,
                      '2',
                      '📲 选择"添加到主屏幕"',
                      '在菜单中找到"添加到主屏幕"或"安装应用"选项',
                      Icons.add_to_home_screen,
                    ),
                    const SizedBox(height: 12),
                    _buildStepCard(
                      context,
                      '3',
                      '✨ 完成添加',
                      '点击添加后，应用图标就会出现在你的手机桌面上',
                      Icons.check_circle_outline,
                    ),
                    const SizedBox(height: 20),
                    // 特点说明
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
                                '离线使用',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '添加后无需打开浏览器，直接从桌面打开即可使用，'
                            '并支持离线访问部分功能！',
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
            // 尝试自动安装按钮
            ElevatedButton.icon(
              onPressed: () {
                _tryInstallPWA(context);
              },
              icon: const Icon(Icons.download),
              label: const Text('尝试自动安装'),
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
      // 提示用户通过浏览器菜单安装 PWA
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('📱 请使用浏览器"添加到主屏幕"功能安装应用'),
          duration: Duration(seconds: 3),
        ),
      );
      // 展示提示
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.info_outline, color: AppTheme.primary),
                SizedBox(width: 8),
                Text('提示'),
              ],
            ),
            content: const Text(
              '由于浏览器安全限制，\n安装应用需要您在弹出的提示中确认。\n\n'
              '您也可以按照上面的手动步骤添加到桌面。',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('知道了'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // 非 Web 环境
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('当前环境不支持自动安装：$e')),
        );
      }
    }
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('🔒 隐私政策'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '想了莓隐私政策',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 12),
              Text(
                '1. 数据收集：我们仅收集您主动提供的信息，用于应用功能。\n\n'
                '2. 数据存储：您的数据存储在本地设备，我们不会上传您的个人信息。\n\n'
                '3. 第三方服务：我们使用 Netlify 进行应用托管，可能收集有限的访问日志。\n\n'
                '4. 联系方式：如有问题，请联系我们。',
                style: TextStyle(height: 1.6),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
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
            Text('🍓', style: TextStyle(fontSize: 28)),
            SizedBox(width: 8),
            Text('想了莓'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('版本：1.0.1'),
            SizedBox(height: 8),
            Text('一个温暖的情感治愈小宇宙'),
            SizedBox(height: 12),
            Text(
              '💝 恋爱攻略 | 🌱 失恋疗愈 | 🌍 莓友星球\n\n'
              '用心陪伴，每一天',
              style: TextStyle(height: 1.5),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
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
            const Text('💻', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            const Text('下载桌面应用', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('选择你的操作系统', style: TextStyle(color: AppTheme.textSecondary)),
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
              child: const Text('取消'),
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
    // 显示下载提示
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
            Text('正在准备下载...'),
          ],
        ),
      ),
    );

    // 模拟下载延迟，然后跳转到 Electron 下载页面
    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.pop(context); // 关闭加载弹窗
      Navigator.pop(context); // 关闭下载选项弹窗

      // 跳转到下载页面
      final uri = Uri.parse('https://lighthearted-frangipane-fb0fe3.netlify.app/download');
      launchUrl(uri, mode: LaunchMode.externalApplication);

      // 显示成功提示
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('💻 即将开始下载桌面应用！'),
          backgroundColor: AppTheme.primary,
                ),
      );
    });
  }
}
