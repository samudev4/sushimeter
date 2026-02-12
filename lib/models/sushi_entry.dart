import 'package:hive/hive.dart';

part 'sushi_entry.g.dart';

@HiveType(typeId: 0)
class SushiEntry {
  @HiveField(0)
  final int pieces;

  @HiveField(1)
  final DateTime date;

  SushiEntry(this.pieces, this.date);
}
