// import 'dart:math';
//
// class NumUtil {
//   ///  基于googleMap中的算法得到两经纬度之间的距离,计算精度与谷歌地图的距离精度差不多，相差范围在0.2米以下（单位m）
//   ///	 [lon1] 第一点的精度
//   ///	 [lat1] 第一点的纬度
//   ///	 [lon2] 第二点的精度
//   ///	 [lat3] 第二点的纬度
//   ///	 返回的距离，单位m
//   static num getDistance(num lon1, num lat1, num lon2, num lat2) {
//     // 赤道半径(单位m)
//     const double earthRadius = 6378137;
//     double radLat1 = rad(lat1);
//     double radLat2 = rad(lat2);
//     double a = radLat1 - radLat2;
//     double b = rad(lon1) - rad(lon2);
//     double s = 2 *
//         asin(sqrt(pow(sin(a / 2), 2) +
//             cos(radLat1) * cos(radLat2) * pow(sin(b / 2), 2)));
//     s = s * earthRadius;
//     return s;
//   }
//
//   ///转化为弧度(rad)
//   static double rad(num d) => d * pi / 180.0;
// }
