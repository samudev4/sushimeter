import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sushimeter/constants/app_colors.dart';
import 'package:sushimeter/constants/app_strings.dart';
import '../models/sushi_entry.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Timer? _snackBarTimer;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy · HH:mm');

    return Scaffold(
      backgroundColor: AppColors.colorFondoScaffold(context),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.colorFondoAppBar(context),
        title: Text(
          AppStrings.textoHistorial,
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.normal,
            color: AppColors.colorTexto(context),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: ValueListenableBuilder(
          valueListenable: Hive.box<SushiEntry>('sushiBox').listenable(),
          builder: (_, Box<SushiEntry> box, _) {
            if (box.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.textoNoHayRegistrosTodavia,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: AppColors.colorTexto(context),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 28),
                    Text(
                      AppStrings.textoPuedesEliminarUnRegistro,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: AppColors.colorTexto(context),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 25),
                child: Column(
                  children: List.generate(box.length, (index) {
                    final entry = box.getAt(index)!;

                    return Dismissible(
                      key: ValueKey(entry.date),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.centerRight,
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.delete_outline,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      onDismissed: (_) {
                        final removedEntry = entry;
                        final removedIndex = index;

                        box.deleteAt(index);

                        final messenger = ScaffoldMessenger.of(context);

                        _snackBarTimer?.cancel();
                        messenger.clearSnackBars();

                        messenger.showSnackBar(
                          SnackBar(
                            duration: const Duration(seconds: 3),
                            content: Text(
                              AppStrings.textoRegistroEliminado,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            action: SnackBarAction(
                              label: AppStrings.textoDeshacer,
                              onPressed: () async {
                                _snackBarTimer?.cancel();

                                final items = box.values.toList();
                                items.insert(
                                  removedIndex.clamp(0, items.length),
                                  removedEntry,
                                );
                                await box.clear();
                                await box.addAll(items);

                                messenger.hideCurrentSnackBar();
                              },
                            ),
                          ),
                        );
                        _snackBarTimer = Timer(const Duration(seconds: 3), () {
                          if (messenger.mounted) {
                            messenger.hideCurrentSnackBar();
                          }
                        });
                      },

                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        color: AppColors.colorFondoScaffold(context),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                        child: ListTile(
                          title: Text(
                            '${entry.pieces} 🍣',
                            style: GoogleFonts.poppins(
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                              color: AppColors.colorTexto(context),
                            ),
                          ),
                          subtitle: Text(
                            dateFormat.format(entry.date),
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              color: AppColors.colorTexto(context),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
