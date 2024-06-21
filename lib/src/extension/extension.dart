// import 'dart:math';
//
// import '../datetime/date_util.dart';
//
// extension NumExtension on num {
//   num min(num other) {
//     return other > this ? this : other;
//   }
//
//   num max(num other) {
//     return other > this ? other : this;
//   }
// }
//
// extension IntExtension on int {
//   int min(int other) {
//     return other > this ? this : other;
//   }
//
//   int max(int other) {
//     return other > this ? other : this;
//   }
// }
//
// extension StringExtension on String {
//   bool isNullOrEmpty() => isEmpty;
//
//   bool isNotNullAndNotEmpty() => isNotEmpty;
//
//   String ellipsis([int? length]) {
//     if (isNullOrEmpty()) return '';
//     if (length == null || this.length <= length) return this;
//     length = (length / 2).floor() - 3;
//     return '${substring(0, length)}...${substring(this.length - length)}';
//   }
//
//   bool containsList(List<String> keys) {
//     if (keys.isEmpty) return true;
//     String regStr = "(?=.*${keys.join(')(?=.*')})".toLowerCase();
//     return toLowerCase().contains(RegExp(regStr));
//   }
//
//   String getDateStr() {
//     if (length > 10) return substring(0, 10).replaceAll("/", "-");
//     return this;
//   }
//
//   String getTimeStr() {
//     if (length > 16) return substring(11, 16);
//     return this;
//   }
// }
//
// extension DateTimeExtension on DateTime {
//   /// 时间转换，只支持以下字符串
//   DateTime copy(
//       {int? year, int? month, int? day, int? hour, int? minute, int? second}) {
//     return DateTime(
//       year ?? this.year,
//       month ?? this.month,
//       day ?? this.day,
//       hour ?? this.hour,
//       minute ?? this.minute,
//       second ?? this.second,
//     );
//   }
//
//   String getFormatStr(
//       {DateFormat format = DateFormat.NORMAL,
//       String? dateSeparate,
//       String? timeSeparate}) {
//     return DateUtil.getDateStrByDateTime(this,
//         format: format,
//         dateSeparate: dateSeparate,
//         timeSeparate: timeSeparate);
//   }
//
//   String getDateStr({String? dateSeparate}) =>
//       DateUtil.getDateStrByDateTime(this,
//           format: DateFormat.YEAR_MONTH_DAY, dateSeparate: dateSeparate);
//
//   /// 是否时同一天
//   bool isAtSameDayAs(DateTime other) =>
//       day == other.day && year == other.year && month == other.month;
//
//   DateTime minDate(DateTime? other) {
//     return (other == null || isBefore(other)) ? this : other;
//   }
//
//   DateTime maxDate(DateTime? other) {
//     return (other == null || isAfter(other)) ? this : other;
//   }
//
//   /// 获取当前时间系统的本地时区
//   double getTimeZone() {
//     DateTime local = DateTime.now();
//     DateTime localUtc = local.toUtc();
//     DateTime nowUtc = DateTime.utc(local.year, local.month, local.day,
//         local.hour, local.minute, local.second);
//     DateTime utc = DateTime.utc(localUtc.year, localUtc.month, localUtc.day,
//         localUtc.hour, localUtc.minute, localUtc.second);
//     Duration d = nowUtc.difference(utc);
//     return d.inMinutes / 60.0;
//   }
// }
//
// extension IterableExtension<E> on Iterable<E> {}
//
// extension ListExtension<T> on List<T> {
//   List<T> subListEnd(int start, [int? end]) {
//     return sublist(start, min(end ?? length, length));
//   }
// }
//
// extension MapExtension<K, V> on Map<K, V> {
//   String str(String key) => (this[key] ?? '').toString();
// }
