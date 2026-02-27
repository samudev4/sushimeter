// ignore_for_file: deprecated_member_use

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sushimeter/constants/app_strings.dart';
import 'package:sushimeter/data/sushi_skins.dart';
import 'package:sushimeter/widgets/bouncing_sushi_icon.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:sushimeter/constants/app_colors.dart';
import '../models/sushi_entry.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen>
    with TickerProviderStateMixin {
  int _counter = 0;

  final GlobalKey _sushiKey = GlobalKey();
  final GlobalKey _counterKey = GlobalKey();
  final GlobalKey _finishKey = GlobalKey();

  late AnimationController _rotationController;
  late AnimationController _tapController;
  late Animation<double> _scaleAnimation;
  String _selectedSushiId = 'classic';

  bool _showSushiHint = false;

  Future<void> _loadSelectedSushi() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedSushiId = prefs.getString('selected_sushi') ?? 'classic';
    });
  }

  String get _currentSushiAsset {
    return sushiSkins.firstWhere((s) => s.id == _selectedSushiId).asset;
  }

  @override
  void initState() {
    super.initState();
    _loadSelectedSushi();
    _loadHintState();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _tapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.15,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.15,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 50,
      ),
    ]).animate(_tapController);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showTutorialIfNeeded();
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _tapController.dispose();
    super.dispose();
  }

  Future<void> _loadHintState() async {
    final prefs = await SharedPreferences.getInstance();
    final used = prefs.getBool('sushi_customizer_used') ?? false;

    if (!mounted) return;

    setState(() {
      _showSushiHint = !used;
    });
  }

  Future<void> _showTutorialIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('tutorial_seen') ?? false;

    if (seen || !mounted) return;

    TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.black.withOpacity(0.85),
      paddingFocus: 12,
      textSkip: AppStrings.textoSaltar,
      onFinish: () => prefs.setBool('tutorial_seen', true),
      onSkip: () {
        prefs.setBool('tutorial_seen', true);
        return true;
      },
    ).show(context: context);
  }

  List<TargetFocus> _createTargets() {
    return [
      TargetFocus(
        identify: "sushi",
        keyTarget: _sushiKey,
        shape: ShapeLightFocus.Circle,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: _tutorialText(AppStrings.textoTocaElSushiParaContar),
          ),
        ],
      ),
      TargetFocus(
        identify: "counter",
        keyTarget: _counterKey,
        shape: ShapeLightFocus.RRect,
        radius: 12,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: _tutorialText(
              AppStrings.textoAquiPuedesVerCuantasPiezasLlevas,
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "finish",
        keyTarget: _finishKey,
        shape: ShapeLightFocus.RRect,
        radius: 20,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: _tutorialText(
              AppStrings.textoCuandoTerminesGuardaTuSesionAqui,
            ),
          ),
        ],
      ),
    ];
  }

  Widget _tutorialText(String text) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
      ),
    );
  }

  void _updateRotationSpeed() {
    final seconds = (12 - (_counter * 0.3)).clamp(3.0, 12.0);
    _rotationController.duration = Duration(
      milliseconds: (seconds * 1000).toInt(),
    );
    _rotationController.repeat();
  }

  String _getMotivationalText() {
    if (_counter == 0) return AppStrings.textoTocaElSushiParaEmpezar;
    if (_counter <= 10) return AppStrings.textoAunEstasVacio;
    if (_counter <= 20) return AppStrings.textoCalentandoMotores;
    if (_counter <= 30) return AppStrings.textoPareceQueTeEstasEmpezandoLlenar;
    if (_counter <= 40) return AppStrings.textoOjoEstoYaEsSerio;
    if (_counter <= 50) return AppStrings.textoEstasEnModoBestia;
    return AppStrings.textoVasAExplotar;
  }

  void _increment() {
    _tapController.forward(from: 0);
    setState(() {
      _counter++;
      _updateRotationSpeed();
    });
  }

  void _decrement() {
    if (_counter == 0) return;
    setState(() {
      _counter--;
      _updateRotationSpeed();
    });
  }

  void _reset() {
    setState(() {
      _counter = 0;
      _rotationController.duration = const Duration(seconds: 12);
      _rotationController.reset();
      _rotationController.repeat();
    });
  }

  Future<void> _finish() async {
    if (_counter == 0) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.colorFondoScaffold(context),
        title: Text(
          AppStrings.textoHasTerminado,
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.colorTexto(context),
          ),
        ),
        content: Text(
          AppStrings.textoSeGuardaraEstaSesion,
          style: GoogleFonts.poppins(
            fontSize: 18,
            color: AppColors.colorTexto(context),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              AppStrings.textoCancelar,
              style: GoogleFonts.poppins(color: AppColors.error, fontSize: 16),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.colorFondoBoton(context),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              AppStrings.textoConfirmar,
              style: GoogleFonts.poppins(
                color: AppColors.colorTextoBoton(context),
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      Hive.box<SushiEntry>(
        'sushiBox',
      ).add(SushiEntry(_counter, DateTime.now()));
      _reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorFondoScaffold(context),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.colorFondoAppBar(context),
        centerTitle: true,
        title: Text(
          AppStrings.textoNombreApp,
          style: GoogleFonts.poppins(
            fontSize: 28,
            color: AppColors.colorTexto(context),
          ),
        ),
        actions: [
          IconButton(
            onPressed: _decrement,
            icon: Icon(
              Icons.exposure_minus_1,
              color: AppColors.colorTexto(context),
            ),
          ),
          IconButton(
            onPressed: _reset,
            icon: Icon(
              Icons.restart_alt_outlined,
              color: AppColors.colorTexto(context),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 80),

                        GestureDetector(
                          key: _sushiKey,
                          onTap: _increment,
                          onLongPress: _openSushiCustomizer,
                          child: AnimatedBuilder(
                            animation: Listenable.merge([
                              _rotationController,
                              _scaleAnimation,
                            ]),
                            builder: (_, child) {
                              return Transform.rotate(
                                angle: _rotationController.value * 2 * pi,
                                child: Transform.scale(
                                  scale: _scaleAnimation.value,
                                  child: child,
                                ),
                              );
                            },
                            child: Image.asset(_currentSushiAsset, height: 200),
                          ),
                        ),
                        SizedBox(height: 20),

                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: _showSushiHint
                              ? Column(
                                  key: const ValueKey('hint'),
                                  children: [
                                    const SizedBox(height: 12),
                                    Wrap(
                                      alignment: WrapAlignment.center,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      spacing: 6,
                                      children: [
                                        const Icon(
                                          Icons.touch_app_outlined,
                                          size: 18,
                                          color: Colors.grey,
                                        ),
                                        Text(
                                          'Mantén pulsado el sushi para cambiar su apariencia',
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ),

                        const SizedBox(height: 40),

                        AnimatedSwitcher(
                          key: _counterKey,
                          duration: const Duration(milliseconds: 250),
                          child: Text(
                            '$_counter',
                            key: ValueKey(_counter),
                            style: GoogleFonts.poppins(
                              fontSize: 52,
                              color: AppColors.colorTexto(context),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            _getMotivationalText(),
                            key: ValueKey(_getMotivationalText()),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: AppColors.colorTexto(context),
                            ),
                          ),
                        ),

                        const Spacer(),

                        Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: GestureDetector(
                            key: _finishKey,
                            onTap: _finish,
                            child: Container(
                              height: 58,
                              decoration: BoxDecoration(
                                color: AppColors.colorFondoBoton(context),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                AppStrings.textoHeTerminado,
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.colorTextoBoton(context),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _openSushiCustomizer() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sushi_customizer_used', true);

    setState(() {
      _showSushiHint = false;
    });
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.65,
          minChildSize: 0.25,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.colorFondoScaffold(context),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  // Handle
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    textAlign: TextAlign.center,
                    'Personaliza tu sushi',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColors.colorTexto(context),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Expanded(
                    child: GridView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                          ),
                      itemCount: sushiSkins.length,
                      itemBuilder: (_, index) {
                        final sushi = sushiSkins[index];
                        final selected = sushi.id == _selectedSushiId;

                        return GestureDetector(
                          onTap: () async {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setString('selected_sushi', sushi.id);

                            setState(() {
                              _selectedSushiId = sushi.id;
                            });

                            Navigator.pop(context);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: selected
                                    ? AppColors.colorFondoBoton(context)
                                    : Colors.transparent,
                                width: 3,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                BouncingSushiIcon(
                                  enabled:
                                      !selected, // 👈 el seleccionado NO bota
                                  child: Image.asset(sushi.asset, height: 60),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  sushi.name,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.colorTexto(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
