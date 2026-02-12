// ignore_for_file: deprecated_member_use

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sushimeter/constants/app_strings.dart';
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

  @override
  void initState() {
    super.initState();

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
                fontSize: 16
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
                        const SizedBox(height: 120),

                        GestureDetector(
                          key: _sushiKey,
                          onTap: _increment,
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
                            child: Image.asset(
                              AppStrings.rutaImagenSushi,
                              height: 200,
                            ),
                          ),
                        ),

                        const SizedBox(height: 80),

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

                        const SizedBox(height: 32),

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
}
