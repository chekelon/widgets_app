import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgets_app/config/theme/app_theme.dart';

final isDarkmodeProvider = StateProvider<bool>((ref) => false);

// Listado de colores onmutable
final colorListProvider = Provider((ref) => colorList);

//Un simple int
final selectedColorProvider = StateProvider<int>((ref) => 0);
