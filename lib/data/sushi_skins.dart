import 'package:sushimeter/constants/app_strings.dart';

import '../models/sushi_skin.dart';

const sushiSkins = [
  SushiSkin(id: 'classic', name: 'Clásico', asset: AppStrings.rutaImagenSushi),
  SushiSkin(id: 'gunkan', name: 'Gunkan', asset: AppStrings.rutaImagenGunkan),
  SushiSkin(id: 'gyoza', name: 'Gyoza', asset: AppStrings.rutaImagenGyoza),
  SushiSkin(
    id: 'nigiri_gamba',
    name: 'Nigiri de gamba',
    asset: AppStrings.rutaImagenNigiriGamba,
  ),
  SushiSkin(
    id: 'nigiri_salmon',
    name: 'Nigiri de salmón',
    asset: AppStrings.rutaImagenSalmon,
  ),
  SushiSkin(
    id: 'palillos',
    name: 'Sushi con palillos',
    asset: AppStrings.rutaImagenSushiPalillos,
  ),
  SushiSkin(id: 'sushi2', name: 'Gunkan 2', asset: AppStrings.rutaImagenSushi2),
];
