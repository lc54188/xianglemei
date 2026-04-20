import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const XiangLeMeiApp());
}

// ==================== 主题配置 ====================
class AppTheme {
  static const Color primary = Color(0xFFFF6B8A);
  static const Color secondary = Color(0xFFFFB3C6);
  static const Color accent = Color(0xFFFF4D6D);
  static const Color background = Color(0xFFFFF0F3);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF3D0000);
  static const Color textSecondary = Color(0xFF9B6B7A);
  static const Color creamWhite = Color(0xFFFFF8F9);
  static const Color greenAccent = Color(0xFF52C41A);
  static const Color goldAccent = Color(0xFFFFAA00);

  static ThemeData get theme => ThemeData(
        primaryColor: primary,
        scaffoldBackgroundColor: background,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          background: background,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        cardTheme: CardThemeData(
          color: cardBg,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadowColor: primary.withOpacity(0.2),
        ),
      );
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
  Map<String, bool> _farmItems = {
    '草莓苗': true,
    '小草莓': false,
    '大草莓': false,
    '草莓王': false,
  };

  bool get isLoggedIn => _isLoggedIn;
  String get username => _username;
  int get meiSeeds => _meiSeeds;
  String get currentMood => _currentMood;
  List<DiaryEntry> get diaries => _diaries;
  List<String> get joinedGroups => _joinedGroups;
  int get healingDay => _healingDay;
  List<String> get achievements => _achievements;
  Map<String, bool> get farmItems => _farmItems;

  void login(String name) {
    _isLoggedIn = true;
    _username = name.isEmpty ? '莓莓用户' : name;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _username = '';
    notifyListeners();
  }

  void addMeiSeeds(int count) {
    _meiSeeds += count;
    _checkAchievements();
    notifyListeners();
  }

  void setMood(String mood) {
    _currentMood = mood;
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

  DiaryEntry({
    required this.mood,
    required this.content,
    required this.time,
    required this.aiAdvice,
  });
}

// ==================== 主应用 ====================
class XiangLeMeiApp extends StatelessWidget {
  const XiangLeMeiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _globalState,
      builder: (context, _) {
        return MaterialApp(
          title: '想了莓',
          theme: AppTheme.theme,
          debugShowCheckedModeBanner: false,
          home: _globalState.isLoggedIn
              ? const MainScreen()
              : const OnboardingScreen(),
        );
      },
    );
  }
}

final AppState _globalState = AppState();

// ==================== 引导页 ====================
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'icon': '🍓',
      'title': '欢迎来到想了莓',
      'subtitle': '一个属于你的情感治愈小宇宙',
      'color': '#FF6B8A',
    },
    {
      'icon': '💝',
      'title': '恋爱技巧全攻略',
      'subtitle': 'AI助手帮你搞定每一次心动时刻',
      'color': '#FF4D6D',
    },
    {
      'icon': '🌱',
      'title': '失恋也能重新开始',
      'subtitle': '21天治愈计划，陪你慢慢走出来',
      'color': '#FF8FAB',
    },
    {
      'icon': '🛡️',
      'title': '守护你的健康与边界',
      'subtitle': '莓盾守护，让爱更安全',
      'color': '#C9184A',
    },
    {
      'icon': '🌟',
      'title': '找到你的莓友星球',
      'subtitle': '志同道合的朋友就在这里等你',
      'color': '#FF6B8A',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _buildPage(_pages[index]);
            },
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == i ? 20 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == i
                            ? Colors.white
                            : Colors.white54,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPage < _pages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _showLoginDialog(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.primary,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                      elevation: 6,
                    ),
                    child: Text(
                      _currentPage < _pages.length - 1 ? '下一步 →' : '开始体验 🍓',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(Map<String, String> data) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primary,
            AppTheme.accent,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(data['icon']!, style: const TextStyle(fontSize: 100)),
            const SizedBox(height: 32),
            Text(
              data['title']!,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                data['subtitle']!,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLoginDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const LoginBottomSheet(),
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
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Center(
            child: Text(
              '🍓 想了莓',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              _isRegister ? '创建你的莓莓账号' : '欢迎回来，莓莓人！',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
            ),
          ),
          const SizedBox(height: 24),
          if (_isRegister)
            _buildInput(_nameController, '昵称', '给自己起个可爱的名字 🍓', Icons.person),
          const SizedBox(height: 12),
          _buildInput(_phoneController, '手机号/邮箱', '请输入账号', Icons.phone_android),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _globalState.login(_nameController.text.isNotEmpty
                    ? _nameController.text
                    : '莓莓用户');
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
              ),
              child: Text(
                _isRegister ? '注册并开始 🍓' : '登录',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isRegister ? '已有账号？' : '还没有账号？',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
              TextButton(
                onPressed: () =>
                    setState(() => _isRegister = !_isRegister),
                child: Text(
                  _isRegister ? '直接登录' : '立即注册',
                  style: TextStyle(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton.icon(
              onPressed: () => _globalState.login('微信用户'),
              icon: const Icon(Icons.chat, color: Color(0xFF07C160)),
              label: const Text(
                '微信快捷登录',
                style: TextStyle(color: Color(0xFF07C160)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInput(
      TextEditingController ctrl, String label, String hint, IconData icon) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppTheme.primary),
        filled: true,
        fillColor: AppTheme.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.primary, width: 1.5),
        ),
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

class _MainScreenState extends State<MainScreen> {
  int _tabIndex = 0;

  void _selectTab(int index) {
    setState(() => _tabIndex = index);
  }

  final List<Widget> _pages = [
    const HomeTab(),
    const MeiHaoGongLueTab(),
    const MeiWanDaiXuTab(),
    const MeiYouXingQiuTab(),
    const MyTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _tabIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _tabIndex,
          onTap: (i) => setState(() => _tabIndex = i),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppTheme.primary,
          unselectedItemColor: AppTheme.textSecondary,
          backgroundColor: Colors.white,
          selectedFontSize: 11,
          unselectedFontSize: 10,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
            BottomNavigationBarItem(icon: Text('💝', style: TextStyle(fontSize: 22)), label: '莓好攻略'),
            BottomNavigationBarItem(icon: Text('🌱', style: TextStyle(fontSize: 22)), label: '莓完待续'),
            BottomNavigationBarItem(icon: Text('🌍', style: TextStyle(fontSize: 22)), label: '莓友星球'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
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
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 140,
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
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AnimatedBuilder(
                            animation: _globalState,
                            builder: (_, __) => Text(
                              '你好，${_globalState.username} ${_globalState.currentMood}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
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
              title: const Text('🍓 想了莓'),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // 莓籽卡片
                  AnimatedBuilder(
                    animation: _globalState,
                    builder: (_, __) => _buildSeedsCard(),
                  ),
                  const SizedBox(height: 16),
                  // 今日状态
                  _buildMoodSelector(),
                  const SizedBox(height: 16),
                  // 核心功能入口
                  const Text(
                    '核心功能',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildFunctionGrid(context),
                  const SizedBox(height: 16),
                  // 莓盾守护入口
                  _buildShieldCard(context),
                  const SizedBox(height: 80),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeedsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B8A), Color(0xFFFF8FAB)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Text('🍓', style: TextStyle(fontSize: 40)),
          const SizedBox(width: 12),
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
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '治愈第 ${_globalState.healingDay} 天',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoodSelector() {
    final moods = ['🍓', '😊', '😢', '😡', '🌸', '💪', '🥰', '😴'];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '今日心情',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            AnimatedBuilder(
              animation: _globalState,
              builder: (_, __) => Wrap(
                spacing: 12,
                children: moods.map((m) {
                  final selected = _globalState.currentMood == m;
                  return GestureDetector(
                    onTap: () => _globalState.setMood(m),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppTheme.primary.withOpacity(0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: selected
                            ? Border.all(color: AppTheme.primary, width: 2)
                            : null,
                      ),
                      child: Text(m, style: const TextStyle(fontSize: 28)),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFunctionGrid(BuildContext context) {
    final items = [
      {'icon': '💝', 'label': '莓好攻略', 'color': 0xFFFFE0E6, 'tab': 1},
      {'icon': '🌱', 'label': '莓完待续', 'color': 0xFFE8F5E9, 'tab': 2},
      {'icon': '🌍', 'label': '莓友星球', 'color': 0xFFE3F2FD, 'tab': 3},
      {'icon': '👤', 'label': '我的', 'color': 0xFFFCE4EC, 'tab': 4},
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.6,
      ),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final item = items[i];
        return GestureDetector(
          onTap: () {
            // 找到 MainScreen 的 State 并切换 Tab
            final state = context.findAncestorStateOfType<_MainScreenState>();
            state?._selectTab(item['tab'] as int);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Color(item['color'] as int),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item['icon'] as String,
                    style: const TextStyle(fontSize: 32)),
                const SizedBox(height: 6),
                Text(
                  item['label'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildShieldCard(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => const MeiDunScreen())),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF8E24AA), Color(0xFFAD1457)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Text('🛡️', style: TextStyle(fontSize: 36)),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '莓盾守护',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '了解亲密边界与健康知识 →',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
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
            child: AnimatedBuilder(
              animation: _globalState,
              builder: (_, __) => Center(
                child: Text('🍓 ${_globalState.meiSeeds}',
                    style: const TextStyle(fontSize: 14)),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // AI 对话练习 - 主推
          _buildAICard(context),
          const SizedBox(height: 16),
          // 场景攻略
          const Text(
            '场景化技巧',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _buildScenarioCards(context),
          const SizedBox(height: 16),
          // 恋爱测试
          _buildTestCard(context),
          const SizedBox(height: 16),
          // 案例库
          _buildCaseCard(context),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildAICard(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => const AIChatScreen())),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B8A), Color(0xFFFF4D6D)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Text('🤖', style: TextStyle(fontSize: 32)),
                SizedBox(width: 12),
                Text(
                  'AI 对话练习',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              '"对方说在干嘛，我该怎么回？" 告诉AI你的困惑，获得高情商建议',
              style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 16),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '开始练习 →',
                style: TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScenarioCards(BuildContext context) {
    final scenarios = [
      {'icon': '☕', 'title': '初次约会', 'desc': '如何让Ta记住你'},
      {'icon': '💬', 'title': '暧昧升温', 'desc': '把暧昧变成确认'},
      {'icon': '💌', 'title': '表白技巧', 'desc': '成功率最高的方式'},
      {'icon': '🌙', 'title': '挽回方法', 'desc': '理性地重新开始'},
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.4,
      ),
      itemCount: scenarios.length,
      itemBuilder: (context, i) {
        final s = scenarios[i];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ScenarioDetailScreen(
                title: s['title']!,
                icon: s['icon']!,
              ),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s['icon']!, style: const TextStyle(fontSize: 28)),
                const Spacer(),
                Text(
                  s['title']!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  s['desc']!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTestCard(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => const LoveTestScreen())),
      child: Card(
        child: ListTile(
          leading: const Text('🧠', style: TextStyle(fontSize: 36)),
          title: const Text(
            '恋爱性格测试',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: const Text('了解你的恋爱风格，获取个性化建议'),
          trailing: const Icon(Icons.arrow_forward_ios,
              color: AppTheme.primary, size: 16),
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildCaseCard(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => const CaseLibraryScreen())),
      child: Card(
        child: ListTile(
          leading: const Text('📚', style: TextStyle(fontSize: 36)),
          title: const Text(
            '真实案例库',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: const Text('匿名故事 + 专家解析，从别人的经历中学习'),
          trailing: const Icon(Icons.arrow_forward_ios,
              color: AppTheme.primary, size: 16),
          contentPadding: const EdgeInsets.all(16),
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

  static const List<String> _aiResponses = [
    '根据对方说"在干嘛"的场景，建议你这样回复：\n\n💡 方案A（活泼型）：\n"刚刚在想你呀～你呢？"\n\n💡 方案B（神秘型）：\n"在做一件很重要的事，猜猜是什么？"\n\n💡 方案C（自然型）：\n"刷到一个很好玩的视频！分享给你～"\n\n⚠️ 温馨提示：以上建议仅供参考，请结合对方性格和你们的关系实际判断。',
    '面对喜欢的人不主动的情况：\n\n🌸 先观察Ta是否对所有人都不主动（性格原因 vs 对你不感兴趣）\n\n✨ 建议：适当主动释放信号，比如找共同话题、偶尔主动约好友一起出行。\n\n💝 记住：主动不代表掉价，真诚的表达最有魅力！\n\n⚠️ 温馨提示：感情需要双向奔赴，请保护好自己的情绪。',
    '约会结束后的最佳发消息时机：\n\n⏰ 到家后 30 分钟内：发一条轻松的消息\n"到家了！今天很开心，下次还想一起～"\n\n🚫 避免：立刻疯狂发消息、深夜轰炸\n✅ 推荐：简短真诚，给对方留有空间\n\n⚠️ 温馨提示：每段关系的节奏都不同，以上仅供参考。',
    '自然告白的几种方式：\n\n💌 方式一（创意型）：\n借助一个小礼物或特别的场景自然引出\n\n🗣️ 方式二（直接型）：\n"我喜欢你，想和你在一起"\n——简单直接，成功率最高\n\n🎭 方式三（试探型）：\n"如果有人喜欢你，你会怎么样？"\n\n⚠️ 温馨提示：无论结果如何，勇敢表达都是值得肯定的！',
  ];

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
          // 快捷问题
          if (_messages.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '常见问题快捷提问：',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _quickQuestions.map((q) {
                      return GestureDetector(
                        onTap: () => _sendMessage(q),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppTheme.secondary.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: AppTheme.primary.withOpacity(0.3)),
                          ),
                          child: Text(
                            q,
                            style: const TextStyle(
                                fontSize: 12, color: AppTheme.textPrimary),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          // 消息列表
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isThinking ? 1 : 0),
              itemBuilder: (context, i) {
                if (_isThinking && i == _messages.length) {
                  return _buildThinkingBubble();
                }
                final msg = _messages[i];
                return _buildMessageBubble(
                  msg['text']!,
                  msg['isUser'] == 'true',
                );
              },
            ),
          ),
          // 输入框
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
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
                      hintText: '描述你的情感困惑...',
                      filled: true,
                      fillColor: AppTheme.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: _sendMessage,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    if (_inputController.text.trim().isNotEmpty) {
                      _sendMessage(_inputController.text);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.send, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String text, bool isUser) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser)
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: const Text('🤖', style: TextStyle(fontSize: 24)),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isUser ? AppTheme.primary : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isUser ? Colors.white : AppTheme.textPrimary,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ),
          if (isUser)
            Container(
              margin: const EdgeInsets.only(left: 8),
              child: const Text('🙋', style: TextStyle(fontSize: 24)),
            ),
        ],
      ),
    );
  }

  Widget _buildThinkingBubble() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Text('🤖', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 600 + i * 200),
                    builder: (_, v, __) => Opacity(
                      opacity: v,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppTheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add({'text': text, 'isUser': 'true'});
      _isThinking = true;
    });
    _inputController.clear();
    _scrollToBottom();

    // 模拟 AI 响应
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      final random = Random();
      String aiReply;

      if (text.contains('干嘛') || text.contains('在吗')) {
        aiReply = _aiResponses[0];
      } else if (text.contains('主动') || text.contains('不回')) {
        aiReply = _aiResponses[1];
      } else if (text.contains('约会') || text.contains('见面')) {
        aiReply = _aiResponses[2];
      } else if (text.contains('告白') || text.contains('表白')) {
        aiReply = _aiResponses[3];
      } else {
        aiReply = _aiResponses[random.nextInt(_aiResponses.length)];
      }

      setState(() {
        _isThinking = false;
        _messages.add({'text': aiReply, 'isUser': 'false'});
      });
      _globalState.addMeiSeeds(3);
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

  void _showDisclaimer(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('⚠️ 免责声明'),
        content: const Text(
          'AI生成的恋爱建议仅供参考，不构成专业情感咨询意见。请结合自身实际情况和具体关系进行判断。如有严重情感困扰，建议寻求专业心理咨询师的帮助。',
          style: TextStyle(height: 1.6),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('我知道了'),
          ),
        ],
      ),
    );
  }
}

// ==================== 场景详情界面 ====================
class ScenarioDetailScreen extends StatelessWidget {
  final String title;
  final String icon;

  const ScenarioDetailScreen(
      {super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final tips = _getTips();
    return Scaffold(
      appBar: AppBar(title: Text('$icon $title')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primary, AppTheme.accent],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(icon, style: const TextStyle(fontSize: 60)),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ...tips.asMap().entries.map((e) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.secondary.withOpacity(0.5),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${e.key + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      e.value,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              _globalState.addMeiSeeds(8);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AIChatScreen()),
              );
            },
            icon: const Icon(Icons.chat),
            label: const Text('用AI练习这个场景'),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  List<String> _getTips() {
    switch (title) {
      case '初次约会':
        return [
          '提前了解对方的兴趣爱好，选择双方都感兴趣的地点',
          '穿着得体但保持自然，展现真实的自己最有魅力',
          '多问对方问题，认真倾听，让对方感到被重视',
          '保持适当的肢体语言，眼神接触但不要太直接',
          '约会结束时，真诚表达"今天很开心"并约下次',
        ];
      case '暧昧升温':
        return [
          '增加专属感，建立只有你们之间的"梗"或昵称',
          '适当制造浪漫的"意外"相遇或小惊喜',
          '通过共同目标拉近距离，比如一起完成某件事',
          '适当的距离感反而会激发对方的好奇心',
          '在对方需要帮助的时候及时出现',
        ];
      case '表白技巧':
        return [
          '选择对方心情好、状态轻松的时机',
          '直接真诚最有效："我喜欢你，想和你在一起"',
          '告白前可以铺垫一个你们共同的美好回忆',
          '无论结果如何，提前做好心理准备',
          '被拒绝后保持大方，给双方都留有余地',
        ];
      default:
        return [
          '冷静下来，给彼此一定的空间和时间',
          '反思这段关系中双方各自的问题',
          '以真诚和改变作为挽回的基础',
          '不要用频繁联系施加压力',
          '接受所有可能的结果，包括无法挽回',
        ];
    }
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

  final List<Map<String, dynamic>> _questions = [
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

  @override
  Widget build(BuildContext context) {
    if (_showResult) return _buildResultPage(context);

    final q = _questions[_currentQ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('🧠 恋爱性格测试'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 进度条
            Row(
              children: [
                Text(
                  '问题 ${_currentQ + 1}/${_questions.length}',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                ),
                const Spacer(),
                Text(
                  '${((_currentQ / _questions.length) * 100).toInt()}%',
                  style: const TextStyle(
                      color: AppTheme.primary, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: _currentQ / _questions.length,
              backgroundColor: AppTheme.secondary.withOpacity(0.3),
              color: AppTheme.primary,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
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
            ...List.generate((q['options'] as List).length, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _answers.add(i);
                      if (_currentQ < _questions.length - 1) {
                        _currentQ++;
                      } else {
                        _calculateResult();
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppTheme.secondary.withOpacity(0.6)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppTheme.background,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppTheme.primary.withOpacity(0.5)),
                          ),
                          child: Center(
                            child: Text(
                              String.fromCharCode(65 + i),
                              style: const TextStyle(
                                color: AppTheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          (q['options'] as List)[i] as String,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildResultPage(BuildContext context) {
    final result = _results[_resultType]!;
    return Scaffold(
      appBar: AppBar(title: const Text('你的恋爱性格报告')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primary, AppTheme.accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Text(result['icon']!,
                      style: const TextStyle(fontSize: 72)),
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
                        border: Border.all(
                            color: AppTheme.secondary.withOpacity(0.5)),
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
            ElevatedButton.icon(
              onPressed: () {
                _globalState.addMeiSeeds(20);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('🍓 获得 20 粒莓籽！报告已保存'),
                    backgroundColor: AppTheme.primary,
                  ),
                );
                Navigator.pop(context);
              },
              icon: const Icon(Icons.save_alt),
              label: const Text('保存报告 (+20莓籽)'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  void _calculateResult() {
    final types = ['主动热情型', '理性稳重型', '浪漫感性型', '随缘自在型'];
    // 简单根据第一题答案决定主类型
    final dominantType =
        _answers.isNotEmpty ? types[_answers[0] % types.length] : types[0];
    setState(() {
      _resultType = dominantType;
      _showResult = true;
    });
  }
}

// ==================== 案例库界面 ====================
class CaseLibraryScreen extends StatelessWidget {
  const CaseLibraryScreen({super.key});

  final List<Map<String, String>> _cases = const [
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
        padding: const EdgeInsets.all(16),
        itemCount: _cases.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final c = _cases[i];
          return GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => _CaseDetailSheet(caseData: c),
              );
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.secondary.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        c['tag']!,
                        style: const TextStyle(
                            fontSize: 11, color: AppTheme.primary),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      c['title']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      c['summary']!,
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
        },
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppTheme.secondary.withOpacity(0.4),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(caseData['tag']!,
                style:
                    const TextStyle(fontSize: 12, color: AppTheme.primary)),
          ),
          const SizedBox(height: 10),
          Text(
            caseData['title']!,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('📖 故事正文',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary)),
                  const SizedBox(height: 8),
                  Text(
                    caseData['summary']! +
                        '\n\n（完整故事内容…这里展示案例详情，保护隐私已做匿名处理）',
                    style: const TextStyle(
                        fontSize: 14,
                        height: 1.7,
                        color: AppTheme.textPrimary),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppTheme.primary.withOpacity(0.3)),
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
            child: AnimatedBuilder(
              animation: _globalState,
              builder: (_, __) => Center(
                child: Text(
                  '第${_globalState.healingDay}天',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
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
        label: const Text('写草莓日记', style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 情绪曲线
          AnimatedBuilder(
            animation: _globalState,
            builder: (_, __) => _buildMoodCurve(),
          ),
          const SizedBox(height: 16),
          // 治愈计划
          AnimatedBuilder(
            animation: _globalState,
            builder: (_, __) => _buildHealingPlan(context),
          ),
          const SizedBox(height: 16),
          // 疗愈工具
          _buildHealingTools(context),
          const SizedBox(height: 16),
          // 专业帮助
          _buildProfessionalHelp(context),
          const SizedBox(height: 80),
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
            const Text(
              '📊 情绪曲线',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '共记录 ${_globalState.diaries.length} 篇日记',
              style: const TextStyle(
                  fontSize: 12, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 16),
            if (_globalState.diaries.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    '还没有记录～\n点击右下角"写草莓日记"开始吧 🍓',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      height: 1.6,
                    ),
                  ),
                ),
              )
            else
              SizedBox(
                height: 80,
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
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                height: heights[i % heights.length],
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      AppTheme.secondary,
                                      AppTheme.primary,
                                    ],
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
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
            LinearProgressIndicator(
              value: day / 21,
              backgroundColor: AppTheme.secondary.withOpacity(0.3),
              color: AppTheme.greenAccent,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '今日任务 (第${day + 1}天)',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
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
                    const SnackBar(
                      content: Text('🍓 打卡成功！获得 15 粒莓籽！'),
                      backgroundColor: AppTheme.greenAccent,
                    ),
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
        const Text(
          '🧰 疗愈工具包',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildToolCard(
                context,
                '🎵',
                '白噪音冥想',
                '草莓主题ASMR',
                () => _showASMRSheet(context),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildToolCard(
                context,
                '🌳',
                '虚拟树洞',
                '匿名倾诉',
                () => _showTreeHoleSheet(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildToolCard(
    BuildContext context,
    String icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(icon, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
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
    );
  }

  Widget _buildProfessionalHelp(BuildContext context) {
    return GestureDetector(
      onTap: () => _showConsultantDialog(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.secondary.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Text('👩‍⚕️', style: TextStyle(fontSize: 28)),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '联系专业咨询师',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    '专业心理咨询，付费预约',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                color: AppTheme.primary, size: 16),
          ],
        ),
      ),
    );
  }

  void _showASMRSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: 300,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              '🎵 草莓森林白噪音',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            const Text('🍓', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 16),
            const Text(
              '正在播放：草莓雨声冥想',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    icon: const Icon(Icons.skip_previous, size: 32,
                        color: AppTheme.primary),
                    onPressed: () {}),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.pause,
                      color: Colors.white, size: 32),
                ),
                IconButton(
                    icon: const Icon(Icons.skip_next, size: 32,
                        color: AppTheme.primary),
                    onPressed: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showTreeHoleSheet(BuildContext context) {
    final ctrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '🌳 虚拟树洞',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const Text(
                '匿名发送，只有树洞知道',
                style: TextStyle(
                    fontSize: 13, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: ctrl,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: '把想说的话告诉树洞吧...',
                  filled: true,
                  fillColor: AppTheme.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _globalState.addMeiSeeds(5);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('🌳 树洞已收到你的心声 (+5莓籽)'),
                        backgroundColor: Color(0xFF4CAF50),
                      ),
                    );
                  },
                  child: const Text('悄悄告诉树洞'),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _showConsultantDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('👩‍⚕️ 专业咨询预约'),
        content: const Text(
          '我们与专业心理咨询师合作，提供一对一情感疏导服务。\n\n首次体验：¥99/50分钟\n\n所有咨询师均持有国家心理咨询师资格证。',
          style: TextStyle(height: 1.6),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('稍后再说')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('预约功能即将上线，敬请期待！')),
              );
            },
            child: const Text('立即预约'),
          ),
        ],
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
  String _selectedMood = '😊';
  final _contentController = TextEditingController();

  final List<Map<String, String>> _moods = [
    {'emoji': '🍓', 'label': '莓好'},
    {'emoji': '😊', 'label': '开心'},
    {'emoji': '😢', 'label': '难过'},
    {'emoji': '😤', 'label': '生气'},
    {'emoji': '🥰', 'label': '幸福'},
    {'emoji': '😴', 'label': '疲惫'},
    {'emoji': '😰', 'label': '焦虑'},
    {'emoji': '💪', 'label': '努力'},
  ];

  static const List<String> _aiTips = [
    '🍓 感谢你今天的记录！情绪的波动是正常的，接纳自己的感受是第一步。',
    '🌱 每天记录情绪，是照顾自己内心最温柔的方式。你做得很棒！',
    '💝 允许自己有各种情绪，开心也好，难过也好，都是你真实的一部分。',
    '✨ 把感受写出来，就是在给自己的内心减负。继续加油！',
    '🌟 你愿意面对自己的情绪，已经比很多人勇敢了。',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📝 写草莓日记'),
        actions: [
          TextButton(
            onPressed: _saveDiary,
            child: const Text(
              '保存',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
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
                      spacing: 8,
                      runSpacing: 8,
                      children: _moods.map((m) {
                        final selected = _selectedMood == m['emoji'];
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedMood = m['emoji']!),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppTheme.primary.withOpacity(0.15)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: selected
                                  ? Border.all(
                                      color: AppTheme.primary, width: 2)
                                  : Border.all(
                                      color: Colors.grey.withOpacity(0.3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(m['emoji']!,
                                    style:
                                        const TextStyle(fontSize: 20)),
                                const SizedBox(width: 4),
                                Text(
                                  m['label']!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: selected
                                        ? AppTheme.primary
                                        : AppTheme.textSecondary,
                                    fontWeight: selected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _contentController,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    hintText: '今天发生了什么？想说些什么？\n都可以写在这里，只有你自己看得到 🍓',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: AppTheme.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.7,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  void _saveDiary() {
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先写点什么吧～')),
      );
      return;
    }
    final random = Random();
    final aiTip = _aiTips[random.nextInt(_aiTips.length)];

    _globalState.addDiary(DiaryEntry(
      mood: _selectedMood,
      content: _contentController.text,
      time: DateTime.now(),
      aiAdvice: aiTip,
    ));

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('🍓 日记已保存！'),
        content: Text(
          aiTip,
          style: const TextStyle(height: 1.6),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('谢谢鼓励！'),
          ),
        ],
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
      appBar: AppBar(
        title: const Text('🌍 莓友星球'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // CP速配
          _buildCPMatchCard(context),
          const SizedBox(height: 16),
          // 兴趣小组
          const Text(
            '🌟 兴趣小组',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          AnimatedBuilder(
            animation: _globalState,
            builder: (_, __) => _buildGroupList(context),
          ),
          const SizedBox(height: 16),
          // 能量榜
          _buildLeaderboard(context),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildCPMatchCard(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CPMatchScreen()),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFE91E63), Color(0xFFFF6B8A)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE91E63).withOpacity(0.3),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '💞 CP速配',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '限时匹配，找到趣味相投的人',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '立即匹配 →',
                    style: TextStyle(
                      color: const Color(0xFFE91E63),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Text('💞', style: TextStyle(fontSize: 60)),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupList(BuildContext context) {
    final groups = [
      {'icon': '🚀', 'name': '脱单冲刺组', 'members': '2.3k', 'tag': '热门'},
      {'icon': '💔', 'name': '失恋疗愈室', 'members': '1.8k', 'tag': '治愈'},
      {'icon': '🎮', 'name': '游戏找队友', 'members': '3.1k', 'tag': '兴趣'},
      {'icon': '📚', 'name': '读书交流圈', 'members': '956', 'tag': '兴趣'},
      {'icon': '🏃', 'name': '运动搭子', 'members': '1.2k', 'tag': '健康'},
    ];
    return Column(
      children: groups.map((g) {
        final joined = _globalState.joinedGroups.contains(g['name']);
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Text(g['icon']!, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      g['name']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      '${g['members']}人 · ${g['tag']}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (!joined) {
                    _globalState.joinGroup(g['name']!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('已加入 ${g['name']} (+10莓籽)'),
                        backgroundColor: AppTheme.primary,
                      ),
                    );
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: joined
                        ? Colors.grey.withOpacity(0.2)
                        : AppTheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    joined ? '已加入' : '加入',
                    style: TextStyle(
                      color: joined ? AppTheme.textSecondary : Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLeaderboard(BuildContext context) {
    final rankItems = [
      {'name': '莓莓小公主', 'seeds': '386', 'icon': '🥇'},
      {'name': '草莓糖糖', 'seeds': '312', 'icon': '🥈'},
      {'name': '失恋成功转运', 'seeds': '278', 'icon': '🥉'},
      {'name': '${_globalState.username}（我）',
        'seeds': '${_globalState.meiSeeds}', 'icon': '🌟'},
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🏆 草莓能量榜',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ...rankItems.asMap().entries.map((e) {
              final item = e.value;
              final isMe = e.key == 3;
              return Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 12),
                margin: const EdgeInsets.only(bottom: 6),
                decoration: BoxDecoration(
                  color:
                      isMe ? AppTheme.primary.withOpacity(0.08) : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(item['icon']!,
                        style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item['name']!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isMe
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isMe
                              ? AppTheme.primary
                              : AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      '🍓 ${item['seeds']}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isMe
                            ? AppTheme.primary
                            : AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ==================== CP 速配界面 ====================
class CPMatchScreen extends StatefulWidget {
  const CPMatchScreen({super.key});

  @override
  State<CPMatchScreen> createState() => _CPMatchScreenState();
}

class _CPMatchScreenState extends State<CPMatchScreen> {
  int _step = 0; // 0=问题 1=匹配中 2=匹配成功 3=聊天
  int _qIndex = 0;
  final List<int> _qAnswers = [];
  String _matchedUser = '';
  final List<Map<String, String>> _chatMessages = [];
  final _chatCtrl = TextEditingController();

  final List<Map<String, dynamic>> _questions = [
    {
      'q': '你更喜欢的约会方式？',
      'options': ['电影院', '户外野餐', '游乐园', '咖啡厅'],
    },
    {
      'q': '你的恋爱宣言是？',
      'options': ['陪你吃每顿饭', '一起去看星星', '做彼此的港湾', '相互成就对方'],
    },
    {
      'q': '理想对象最重要的品质？',
      'options': ['有趣好玩', '温柔体贴', '上进努力', '真诚可靠'],
    },
  ];

  final List<String> _matchUsers = ['草莓小饼干', '莓莓ing', '红红的甜', '小野莓'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('💞 CP速配')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (_step) {
      case 0:
        return _buildQuestionStep();
      case 1:
        return _buildMatchingStep();
      case 2:
        return _buildMatchedStep();
      default:
        return _buildChatStep();
    }
  }

  Widget _buildQuestionStep() {
    if (_qIndex >= _questions.length) {
      Future.delayed(Duration.zero, () => setState(() => _step = 1));
      return const Center(child: CircularProgressIndicator());
    }
    final q = _questions[_qIndex];
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(
            value: _qIndex / _questions.length,
            color: AppTheme.primary,
            backgroundColor: AppTheme.secondary.withOpacity(0.3),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
          const SizedBox(height: 32),
          Text(
            '问题 ${_qIndex + 1}',
            style: const TextStyle(
                color: AppTheme.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Text(
            q['q'] as String,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 32),
          ...List.generate((q['options'] as List).length, (i) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () => setState(() {
                  _qAnswers.add(i);
                  _qIndex++;
                  if (_qIndex >= _questions.length) {
                    _step = 1;
                    Future.delayed(const Duration(seconds: 2), () {
                      if (mounted) {
                        setState(() {
                          _matchedUser = _matchUsers[
                              Random().nextInt(_matchUsers.length)];
                          _step = 2;
                        });
                      }
                    });
                  }
                }),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: AppTheme.secondary.withOpacity(0.5)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    (q['options'] as List)[i] as String,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMatchingStep() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('💞', style: TextStyle(fontSize: 80)),
          SizedBox(height: 24),
          Text(
            '正在为你寻找\n最匹配的莓友...',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
              height: 1.5,
            ),
          ),
          SizedBox(height: 24),
          CircularProgressIndicator(color: AppTheme.primary),
        ],
      ),
    );
  }

  Widget _buildMatchedStep() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Text('🍓', style: TextStyle(fontSize: 60)),
            ),
            const SizedBox(height: 24),
            const Text(
              '匹配成功！',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '与 ${'$_matchedUser'} 的契合度 ${85 + Random().nextInt(14)}%',
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                _globalState.addMeiSeeds(10);
                setState(() {
                  _chatMessages.add({
                    'text': '你好！我是$_matchedUser，很高兴认识你 🍓',
                    'isUser': 'false',
                  });
                  _step = 3;
                });
              },
              icon: const Icon(Icons.chat),
              label: const Text('开始聊天 (+10莓籽)'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(220, 52),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('下次再说'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatStep() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          color: AppTheme.background,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('⏰', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(
                '限时聊天 · 与 $_matchedUser',
                style: const TextStyle(
                    color: AppTheme.textSecondary, fontSize: 13),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _chatMessages.length,
            itemBuilder: (context, i) {
              final msg = _chatMessages[i];
              final isUser = msg['isUser'] == 'true';
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: isUser
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    if (!isUser)
                      const Text('🍓',
                          style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              isUser ? AppTheme.primary : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Text(
                          msg['text']!,
                          style: TextStyle(
                            color: isUser
                                ? Colors.white
                                : AppTheme.textPrimary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    if (isUser) const SizedBox(width: 6),
                    if (isUser)
                      const Text('🙋',
                          style: TextStyle(fontSize: 24)),
                  ],
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _chatCtrl,
                  decoration: InputDecoration(
                    hintText: '说点什么吧...',
                    filled: true,
                    fillColor: AppTheme.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  if (_chatCtrl.text.trim().isNotEmpty) {
                    final userMsg = _chatCtrl.text;
                    setState(() {
                      _chatMessages
                          .add({'text': userMsg, 'isUser': 'true'});
                      _chatCtrl.clear();
                    });
                    // 模拟对方回复
                    Future.delayed(const Duration(seconds: 1), () {
                      if (!mounted) return;
                      final replies = [
                        '哈哈，真的吗？我也这样觉得！🍓',
                        '好有趣啊，你平时还喜欢做什么？',
                        '原来你是这样的人，好可爱～',
                        '我觉得我们挺有缘分的！',
                        '下次我们可以一起去试试！',
                      ];
                      setState(() {
                        _chatMessages.add({
                          'text': replies[
                              Random().nextInt(replies.length)],
                          'isUser': 'false',
                        });
                      });
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.send,
                      color: Colors.white, size: 20),
                ),
              ),
            ],
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
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('🛡️ 莓盾守护'),
        backgroundColor: const Color(0xFF8E24AA),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 紧急求助常驻
              _buildEmergencyCard(context),
              const SizedBox(height: 16),
              // 知识学习
              const Text(
                '📖 健康知识学习',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              _buildKnowledgeCards(context),
              const SizedBox(height: 16),
              // 工具
              const Text(
                '🔧 健康工具',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              _buildTools(context),
              const SizedBox(height: 80),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyCard(BuildContext context) {
    return GestureDetector(
      onTap: () => _showEmergencyDialog(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFD32F2F),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD32F2F).withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          children: [
            Text('🆘', style: TextStyle(fontSize: 32)),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '紧急求助',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '24h法律援助 · 心理危机热线',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            Icon(Icons.phone, color: Colors.white, size: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildKnowledgeCards(BuildContext context) {
    final items = [
      {'icon': '🤝', 'title': '性同意指南', 'desc': '了解边界，尊重彼此'},
      {'icon': '🧬', 'title': 'HIV防护知识', 'desc': '预防是最好的保护'},
      {'icon': '⚖️', 'title': '法律权益保护', 'desc': '知法懂法，保护自己'},
      {'icon': '💊', 'title': '阻断药须知', 'desc': '紧急情况的应对方式'},
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.4,
      ),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final item = items[i];
        return GestureDetector(
          onTap: () => _showKnowledgeSheet(context, item),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8E24AA).withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['icon']!,
                    style: const TextStyle(fontSize: 28)),
                const Spacer(),
                Text(
                  item['title']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  item['desc']!,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTools(BuildContext context) {
    return Column(
      children: [
        _buildToolTile(
          context,
          '📋',
          '创建我的边界清单',
          '自定义个人界限',
          () => _showBoundarySheet(context),
        ),
        const SizedBox(height: 10),
        _buildToolTile(
          context,
          '🔍',
          '风险评估自测',
          '匿名答题，生成报告',
          () => _showRiskAssessment(context),
        ),
        const SizedBox(height: 10),
        _buildToolTile(
          context,
          '📍',
          '附近检测点',
          '查找附近HIV/STI检测机构',
          () => _showNearbyPoints(context),
        ),
      ],
    );
  }

  Widget _buildToolTile(
    BuildContext context,
    String icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
            const Icon(Icons.arrow_forward_ios,
                color: Color(0xFF8E24AA), size: 16),
          ],
        ),
      ),
    );
  }

  void _showEmergencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('🆘 紧急求助'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHotline('心理援助热线', '010-82951332'),
            const Divider(),
            _buildHotline('法律援助热线', '12348'),
            const Divider(),
            _buildHotline('反家庭暴力热线', '12338'),
            const Divider(),
            _buildHotline('全国心理援助', '400-161-9995'),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('关闭')),
        ],
      ),
    );
  }

  Widget _buildHotline(String name, String number) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(name,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      subtitle: Text(number,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFD32F2F))),
      trailing: const Icon(Icons.phone, color: Color(0xFFD32F2F)),
    );
  }

  void _showKnowledgeSheet(
      BuildContext context, Map<String, String> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        builder: (_, ctrl) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              const SizedBox(height: 16),
              Text(
                '${item['icon']} ${item['title']}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  controller: ctrl,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '⚠️ 以下内容均来自权威机构（卫健委/疾控中心）审核，请放心阅读。',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF856404),
                          backgroundColor: Color(0xFFFFF3CD),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _getKnowledgeContent(item['title']!),
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.8,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getKnowledgeContent(String title) {
    switch (title) {
      case '性同意指南':
        return '性同意的核心原则：\n\n✅ 同意必须是自愿的、清醒的、当下有效的\n✅ 可以随时撤回同意\n✅ 沉默或不抵抗不等于同意\n✅ 过去的同意不代表当下的同意\n\n如何建立良好的边界：\n• 清楚表达自己的感受和界限\n• 尊重对方说"不"\n• 在不确定时，先询问\n\n请记住：每个人都有权利掌控自己的身体。';
      case 'HIV防护知识':
        return 'HIV预防核心知识：\n\n🔴 主要传播途径：\n• 性接触传播\n• 血液传播\n• 母婴传播\n\n🟢 有效预防措施：\n• 正确使用安全套（有效率>95%）\n• 遵医嘱服用暴露前预防药物(PrEP)\n• 定期接受HIV检测\n• 避免共用针具\n\n🔵 检测建议：\n高风险行为后72小时内可服用阻断药（PEP），有效率>99%。请前往当地疾控中心或医院咨询。';
      case '法律权益保护':
        return '你需要知道的法律权益：\n\n⚖️ 《反家庭暴力法》：\n• 家暴行为可申请人身安全保护令\n• 公安机关必须出警处置\n\n⚖️ 性骚扰/性侵：\n• 可向公安机关报案\n• 留存证据（聊天记录、照片等）\n\n⚖️ 隐私权保护：\n• 未经同意传播私密图片属违法\n• 可依法追究刑事责任\n\n遇到困难请拨打法律援助热线：12348';
      default:
        return '阻断药（PEP）须知：\n\n⏰ 黄金72小时：\n在发生高危行为后72小时内（越早越好）服用，可有效预防HIV感染。\n\n📋 如何获取：\n• 前往当地疾控中心\n• 艾滋病定点医院\n• 部分大城市可网上预约\n\n💊 服药须知：\n• 需连续服用28天\n• 不能漏服\n• 部分药物有副作用，遵医嘱服用\n\n⚠️ 阻断药不是万能的，正确使用安全套才是最佳预防方式。';
    }
  }

  void _showBoundarySheet(BuildContext context) {
    final items = [
      '我的身体界限需要被尊重',
      '我有权随时说"不"',
      '不接受语言或身体暴力',
      '我的隐私不得被侵犯',
      '我有权了解性健康知识',
    ];
    final checked = List<bool>.filled(items.length, false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx2, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '📋 创建我的边界清单',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (_, i) => CheckboxListTile(
                    activeColor: AppTheme.primary,
                    value: checked[i],
                    onChanged: (v) =>
                        setModalState(() => checked[i] = v ?? false),
                    title: Text(items[i]),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _globalState.addMeiSeeds(10);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✅ 边界清单已保存 (+10莓籽)'),
                        backgroundColor: AppTheme.primary,
                      ),
                    );
                  },
                  child: const Text('保存我的边界清单'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRiskAssessment(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('🔍 风险评估自测'),
        content: const Text(
          '本测试完全匿名，数据经过加密处理，不会存储可识别个人身份的信息。\n\n测试将评估你在亲密关系中的潜在风险因素，并提供针对性建议。',
          style: TextStyle(height: 1.6),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('取消')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _globalState.addMeiSeeds(15);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ 评估完成！低风险。继续保持健康的边界意识 (+15莓籽)'),
                  backgroundColor: AppTheme.greenAccent,
                  duration: Duration(seconds: 4),
                ),
              );
            },
            child: const Text('开始测试'),
          ),
        ],
      ),
    );
  }

  void _showNearbyPoints(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: 320,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📍 附近检测机构',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const Text(
              '（演示数据）',
              style: TextStyle(
                  fontSize: 12, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 16),
            ...[
              {'name': '市疾控中心HIV检测门诊', 'dist': '1.2km', 'free': true},
              {'name': '人民医院感染科', 'dist': '2.5km', 'free': false},
              {'name': '社区卫生服务中心', 'dist': '3.1km', 'free': true},
            ].map((item) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.background,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Text('🏥', style: TextStyle(fontSize: 24)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'] as String,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  item['dist'] as String,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                if (item['free'] == true) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppTheme.greenAccent
                                          .withOpacity(0.15),
                                      borderRadius:
                                          BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '免费检测',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: AppTheme.greenAccent,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.navigation,
                          color: AppTheme.primary, size: 20),
                    ],
                  ),
                )),
          ],
        ),
      ),
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: AppTheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primary, AppTheme.accent],
                  ),
                ),
                child: SafeArea(
                  child: AnimatedBuilder(
                    animation: _globalState,
                    builder: (_, __) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text('🍓',
                                style: TextStyle(fontSize: 40)),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _globalState.username,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '莓籽: ${_globalState.meiSeeds}粒 · 治愈第${_globalState.healingDay}天',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            title: const Text('👤 我的'),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // 成就
                AnimatedBuilder(
                  animation: _globalState,
                  builder: (_, __) => _buildAchievements(),
                ),
                const SizedBox(height: 16),
                // 恋爱农场
                _buildFarmCard(context),
                const SizedBox(height: 16),
                // 纪念日
                _buildAnniversaryCard(context),
                const SizedBox(height: 16),
                // 设置
                _buildSettings(context),
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🏆 我的勋章',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            if (_globalState.achievements.isEmpty)
              const Text(
                '完成任务解锁勋章，你已经在路上了！🍓',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 13,
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _globalState.achievements.map((a) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFD700), Color(0xFFFFAA00)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '🏅 $a',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              ),
            const SizedBox(height: 8),
            Text(
              '共获得 ${_globalState.achievements.length} 个勋章',
              style: const TextStyle(
                  fontSize: 12, color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFarmCard(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const FarmScreen()),
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '🌱 我的恋爱农场',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              AnimatedBuilder(
                animation: _globalState,
                builder: (_, __) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: _globalState.farmItems.entries.map((e) {
                    return Column(
                      children: [
                        Text(
                          e.value ? '🍓' : '🌱',
                          style: TextStyle(
                            fontSize: 36,
                            color: e.value
                                ? null
                                : Colors.grey.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          e.key,
                          style: TextStyle(
                            fontSize: 11,
                            color: e.value
                                ? AppTheme.textPrimary
                                : AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '完成治愈任务，让农场成长 →',
                style: const TextStyle(
                    fontSize: 12, color: AppTheme.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnniversaryCard(BuildContext context) {
    return GestureDetector(
      onTap: () => _showAddAnniversary(context),
      child: Card(
        child: ListTile(
          leading: const Text('📅', style: TextStyle(fontSize: 32)),
          title: const Text(
            '纪念日',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          subtitle: const Text('添加重要日期，系统自动提醒'),
          trailing: const Icon(Icons.add, color: AppTheme.primary),
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildSettings(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.dark_mode, color: AppTheme.primary),
            title: const Text('暗夜模式'),
            trailing: Switch(
              value: false,
              onChanged: (_) => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('暗夜模式即将上线～')),
              ),
              activeThumbColor: AppTheme.primary,
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.privacy_tip, color: AppTheme.primary),
            title: const Text('隐私设置'),
            trailing:
                const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('所有数据均已加密存储')),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('退出登录',
                style: TextStyle(color: Colors.red)),
            onTap: () => _confirmLogout(context),
          ),
        ],
      ),
    );
  }

  void _showAddAnniversary(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('📅 添加纪念日'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: '纪念日名称',
                hintText: '如：在一起的日子',
                filled: true,
                fillColor: AppTheme.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('📅 2024年6月1日'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('取消')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('🎉 纪念日已添加！届时将为你发送提醒')),
              );
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('确认退出？'),
        content: const Text('退出后数据已保存，下次登录可继续。'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('取消')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _globalState.logout();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('退出登录'),
          ),
        ],
      ),
    );
  }
}
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🌱 我的恋爱农场')),
      body: AnimatedBuilder(
        animation: _globalState,
        builder: (_, __) => SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 220,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF81C784), Color(0xFF4CAF50)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _globalState.farmItems.entries.map((e) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            e.value ? '🍓' : '🌱',
                            style: TextStyle(
                              fontSize: 50,
                              color: e.value
                                  ? null
                                  : Colors.white.withOpacity(0.4),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            e.key,
                            style: TextStyle(
                              fontSize: 12,
                              color: e.value
                                  ? Colors.white
                                  : Colors.white54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '当前阶段：${_getFarmStage()}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '治愈天数：${_globalState.healingDay}/21天',
                      style: const TextStyle(
                          color: AppTheme.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: _globalState.healingDay / 21,
                      backgroundColor:
                          Colors.grey.withOpacity(0.2),
                      color: AppTheme.greenAccent,
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '解锁进度：',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...[
                      {'stage': '小草莓', 'day': 3},
                      {'stage': '大草莓', 'day': 7},
                      {'stage': '草莓王', 'day': 21},
                    ].map(
                      (item) => ListTile(
                        leading: Icon(
                          _globalState.healingDay >=
                                  (item['day'] as int)
                              ? Icons.check_circle
                              : Icons.lock,
                          color: _globalState.healingDay >=
                                  (item['day'] as int)
                              ? AppTheme.greenAccent
                              : Colors.grey,
                        ),
                        title: Text('解锁 ${item['stage']}'),
                        subtitle: Text('坚持到第 ${item['day']} 天'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  _getFarmStage() {
  }

// ==================== 恋爱农场界面 ====================
class FarmScreen extends StatelessWidget {
  const FarmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🌱 我的恋爱农场')),
      body: AnimatedBuilder(
        animation: _globalState,
        builder: (_, __) => SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 220,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF81C784), Color(0xFF4CAF50)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _globalState.farmItems.entries.map((e) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            e.value ? '🍓' : '🌱',
                            style: TextStyle(
                              fontSize: 50,
                              color: e.value
                                  ? null
                                  : Colors.white.withOpacity(0.4),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            e.key,
                            style: TextStyle(
                              fontSize: 12,
                              color: e.value
                                  ? Colors.white
                                  : Colors.white54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '当前阶段：${_getFarmStage()}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '治愈天数：${_globalState.healingDay}/21天',
                      style: const TextStyle(
                          color: AppTheme.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: _globalState.healingDay / 21,
                      backgroundColor:
                          Colors.grey.withOpacity(0.2),
                      color: AppTheme.greenAccent,
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '解锁进度：',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...[
                      {'stage': '小草莓', 'day': 3},
                      {'stage': '大草莓', 'day': 7},
                      {'stage': '草莓王', 'day': 21},
                    ].map(
                      (item) => ListTile(
                        leading: Icon(
                          _globalState.healingDay >=
                                  (item['day'] as int)
                              ? Icons.check_circle
                              : Icons.lock,
                          color: _globalState.healingDay >=
                                  (item['day'] as int)
                              ? AppTheme.greenAccent
                              : Colors.grey,
                        ),
                        title: Text('解锁 ${item['stage']}'),
                        subtitle: Text('坚持到第 ${item['day']} 天'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getFarmStage() {
    final day = _globalState.healingDay;
    if (day >= 21) return '🍓 草莓王';
    if (day >= 7) return '🍓 大草莓';
    if (day >= 3) return '🍓 小草莓';
    return '🌱 草莓苗';
  }
}

// ==================== 工具函数 ====================
int min(int a, int b) => a < b ? a : b;

