// import 'date_util.dart';
// /**
//  * @Author: thl
//  * @GitHub: https://github.com/Sky24n
//  * @Description: Timeline Util.
//  * @Date: 2018/10/3
//  */
//
// ///(xx)Configurable output.
// ///(xx)为可配置输出.
// enum DayFormat {
//   ///(less than 10s->just now)、x minutes、x hours、(Yesterday)、x days.
//   ///(小于10s->刚刚)、x分钟、x小时、(昨天)、x天.
//   simple,
//
//   ///(less than 10s->just now)、x minutes、x hours、[This year:(Yesterday/a day ago)、(two days age)、MM-dd ]、[past years: yyyy-MM-dd]
//   ///(小于10s->刚刚)、x分钟、x小时、[今年: (昨天/1天前)、(2天前)、MM-dd],[往年: yyyy-MM-dd].
//   common,
//
//   ///日期 + HH:mm
//   ///(less than 10s->just now)、x minutes、x hours、[This year:(Yesterday HH:mm/a day ago)、(two days age)、MM-dd HH:mm]、[past years: yyyy-MM-dd HH:mm]
//   ///小于10s->刚刚)、x分钟、x小时、[今年: (昨天 HH:mm/1天前)、(2天前)、MM-dd HH:mm],[往年: yyyy-MM-dd HH:mm].
//   full,
// }
//
// ///Timeline information configuration.
// ///Timeline信息配置.
// abstract class TimelineInfo {
//   String suffixAgo(); //suffix ago(后缀 后).
//
//   String suffixAfter(); //suffix after(后缀 前).
//
//   String lessThanTenSecond() => ''; //just now(刚刚).
//
//   String customYesterday() => ''; //Yesterday(昨天).优先级高于keepOneDay
//
//   bool keepOneDay(); //保持1天,example: true -> 1天前, false -> MM-dd.
//
//   bool keepTwoDays(); //保持2天,example: true -> 2天前, false -> MM-dd.
//
//   String oneMinute(int minutes); //a minute(1分钟).
//
//   String minutes(int minutes); //x minutes(x分钟).
//
//   String anHour(int hours); //an hour(1小时).
//
//   String hours(int hours); //x hours(x小时).
//
//   String oneDay(int days); //a day(1天).
//
//   String days(int days); //x days(x天).
// }
//
// class ZhInfo implements TimelineInfo {
//   String suffixAgo() => '前';
//
//   String suffixAfter() => '后';
//
//   String lessThanTenSecond() => '刚刚';
//
//   String customYesterday() => '昨天';
//
//   bool keepOneDay() => true;
//
//   bool keepTwoDays() => true;
//
//   String oneMinute(int minutes) => '$minutes分钟';
//
//   String minutes(int minutes) => '$minutes分钟';
//
//   String anHour(int hours) => '$hours小时';
//
//   String hours(int hours) => '$hours小时';
//
//   String oneDay(int days) => '$days天';
//
//   String days(int days) => '$days天';
// }
//
// class EnInfo implements TimelineInfo {
//   String suffixAgo() => ' ago';
//
//   String suffixAfter() => ' after';
//
//   String lessThanTenSecond() => 'just now';
//
//   String customYesterday() => 'Yesterday';
//
//   bool keepOneDay() => true;
//
//   bool keepTwoDays() => true;
//
//   String oneMinute(int minutes) => 'a minute';
//
//   String minutes(int minutes) => '$minutes minutes';
//
//   String anHour(int hours) => 'an hour';
//
//   String hours(int hours) => '$hours hours';
//
//   String oneDay(int days) => 'a day';
//
//   String days(int days) => '$days days';
// }
//
// class ZhNormalInfo implements TimelineInfo {
//   String suffixAgo() => '前';
//
//   String suffixAfter() => '后';
//
//   String lessThanTenSecond() => '刚刚';
//
//   String customYesterday() => '昨天';
//
//   bool keepOneDay() => true;
//
//   bool keepTwoDays() => false;
//
//   String oneMinute(int minutes) => '$minutes分钟';
//
//   String minutes(int minutes) => '$minutes分钟';
//
//   String anHour(int hours) => '$hours小时';
//
//   String hours(int hours) => '$hours小时';
//
//   String oneDay(int days) => '$days天';
//
//   String days(int days) => '$days天';
// }
//
// class EnNormalInfo implements TimelineInfo {
//   String suffixAgo() => ' ago';
//
//   String suffixAfter() => ' after';
//
//   String lessThanTenSecond() => 'just now';
//
//   String customYesterday() => 'Yesterday';
//
//   bool keepOneDay() => true;
//
//   bool keepTwoDays() => false;
//
//   String oneMinute(int minutes) => 'a minute';
//
//   String minutes(int minutes) => '$minutes minutes';
//
//   String anHour(int hours) => 'an hour';
//
//   String hours(int hours) => '$hours hours';
//
//   String oneDay(int days) => 'a day';
//
//   String days(int days) => '$days days';
// }
//
// Map<String, TimelineInfo> _timelineInfoMap = {
//   'zh': ZhInfo(),
//   'en': EnInfo(),
//   'zh_normal': ZhNormalInfo(),
//   //keepTwoDays() => false
//   'en_normal': EnNormalInfo(),
//   //keepTwoDays() => false
// };
//
// ///add custom configuration.
// void setLocaleInfo(String locale, TimelineInfo timelineInfo) {
//   assert(locale != null, '[locale] must not be null');
//   assert(timelineInfo != null, '[timelineInfo] must not be null');
//   _timelineInfoMap[locale] = timelineInfo;
// }
//
// /// TimelineUtil
// class TimeFormatUtil {
//   /// format time by DateTime.
//   /// dateTime
//   /// locDateTime: current time or schedule time.
//   /// locale: output key.
//   static String formatByDateTime(DateTime dateTime,
//       {DateTime? locDateTime,
//       String locale = 'zh',
//       DayFormat dayFormat = DayFormat.common}) {
//     int? locTimeMillis = locDateTime?.millisecondsSinceEpoch;
//     return format(dateTime.millisecondsSinceEpoch,
//         locTimeMillis: locTimeMillis, locale: locale, dayFormat: dayFormat);
//   }
//
//   /// format time by millis.
//   /// dateTime : millis.
//   /// locDateTime: current time or schedule time. millis.
//   /// locale: output key.
//   static String format(
//     int timeMillis, {
//     int? locTimeMillis,
//     String locale = 'zh',
//     DayFormat dayFormat = DayFormat.common,
//   }) {
//     int millis = locTimeMillis ?? DateTime.now().millisecondsSinceEpoch;
//     TimelineInfo info = _timelineInfoMap[locale] ?? ZhInfo();
//
//     int elapsed = millis - timeMillis;
//     String suffix;
//     if (elapsed < 0) {
//       elapsed = elapsed.abs();
//       suffix = info.suffixAfter();
//       dayFormat = DayFormat.simple;
//     } else {
//       suffix = info.suffixAgo();
//     }
//
//     String timeline;
//     if (info.customYesterday().isNotEmpty &&
//         DateUtil.isYesterdayByMillis(timeMillis, millis)) {
//       return _getYesterday(timeMillis, info, dayFormat);
//     }
//
//     if (!DateUtil.yearIsEqualByMillis(timeMillis, millis)) {
//       timeline = _getYear(timeMillis, dayFormat);
//       if (timeline.isNotEmpty) return timeline;
//     }
//
//     final num seconds = elapsed / 1000;
//     final num minutes = seconds / 60;
//     final num hours = minutes / 60;
//     final num days = hours / 24;
//     if (seconds < 120) {
//       timeline = info.oneMinute(1);
//       if (suffix != info.suffixAfter() &&
//           info.lessThanTenSecond().isNotEmpty &&
//           seconds < 10) {
//         timeline = info.lessThanTenSecond();
//         suffix = "";
//       }
//     } else if (minutes < 60) {
//       timeline = info.minutes(minutes.round());
//     } else if (hours < 24) {
//       timeline = info.hours(hours.round());
//     } else {
//       if ((days.round() == 1 && info.keepOneDay() == true) ||
//           (days.round() == 2 && info.keepTwoDays() == true)) {
//         dayFormat = DayFormat.simple;
//       }
//       timeline = _formatDays(timeMillis, days.round(), info, dayFormat);
//       suffix = (dayFormat == DayFormat.simple ? suffix : "");
//     }
//     return timeline + suffix;
//   }
//
//   /// get Yesterday.
//   /// 获取昨天.
//   static String _getYesterday(
//       int timeMillis, TimelineInfo info, DayFormat dayFormat) {
//     return info.customYesterday() +
//         (dayFormat == DayFormat.full
//             ? " ${DateUtil.getDateStrByMs(timeMillis, format: DateFormat.HOUR_MINUTE) ?? ''}"
//             : "");
//   }
//
//   /// get is not year info.
//   /// 获取非今年信息.
//   static String _getYear(int timeMillis, DayFormat dayFormat) {
//     if (dayFormat != DayFormat.simple) {
//       return DateUtil.getDateStrByMs(timeMillis,
//               format: (dayFormat == DayFormat.common
//                   ? DateFormat.YEAR_MONTH_DAY
//                   : DateFormat.YEAR_MONTH_DAY_HOUR_MINUTE)) ??
//           '';
//     }
//     return "";
//   }
//
//   /// format Days.
//   static String _formatDays(int timeMillis, num days, TimelineInfo timelineInfo,
//       DayFormat dayFormat) {
//     String timeline;
//     switch (dayFormat) {
//       case DayFormat.simple:
//         timeline = (days == 1
//             ? timelineInfo.oneDay(days.round())
//             : timelineInfo.days(days.round()));
//         break;
//       case DayFormat.common:
//         timeline =
//             DateUtil.getDateStrByMs(timeMillis, format: DateFormat.MONTH_DAY) ??
//                 '';
//         break;
//       case DayFormat.full:
//         timeline = DateUtil.getDateStrByMs(timeMillis,
//                 format: DateFormat.MONTH_DAY_HOUR_MINUTE) ??
//             '';
//         break;
//     }
//     return timeline;
//   }
// }
//
// /// 时间计算器（上月、本月、下月、本年）
// class TimeTool {
//   /// 当月自然月天数
//   late int maxMouthDays;
//
//   /// 上一个月自然月天数
//   late int maxLastMouthDays;
//
//   /// 下一个月自然月天数
//   late int maxNextMouthDays;
//
//   /// 本月开始时间
//   late DateTime startMouthTime;
//
//   /// 本月结束时间
//   late DateTime endMouthTime;
//
//   /// 上一月开始时间
//   late DateTime startLastMouthTime;
//
//   /// 上一月结束时间
//   late DateTime endLastMouthTime;
//
//   /// 下一月开始时间
//   late DateTime startNextMouthTime;
//
//   /// 下一月结束时间
//   late DateTime endNextMouthTime;
//
//   /// 本年开始时间
//   late DateTime startYearTime;
//
//   /// 本年结束
//   late DateTime endYearTime;
//
//   /// 近一年年开始时间
//   late DateTime startNearlyYearTime;
//
//   /// 近一年年结束时间
//   late DateTime endNearlyYearTime;
//
//   /// 本周开始时间
//   late DateTime startWorkTime;
//
//   /// 本周结束时间
//   late DateTime endWorkTime;
//
//   /// 上一周开始时间
//   late DateTime startLastWorkTime;
//
//   /// 上一周结束时间
//   late DateTime endLastWorkTime;
//
//   /// 下一周开始时间
//   late DateTime startNextWorkTime;
//
//   /// 下一周结束时间
//   late DateTime endNextWorkTime;
//
//   /// 今日开始时间
//   late DateTime startDayTime;
//
//   /// 今日结束时间
//   late DateTime endDayTime;
//
//   /// 昨日开始时间
//   late DateTime startLastDayTime;
//
//   /// 昨日结束时间
//   late DateTime endLastDayTime;
//
//   /// 明日开始时间
//   late DateTime startNextDayTime;
//
//   /// 明日结束时间
//   late DateTime endNextDayTime;
//
//   /// 当前时间
//   late DateTime nowTime;
//
//   TimeTool({DateTime? time}) {
//     nowTime = time ?? DateTime.now();
//     int year = nowTime.year;
//     int month = nowTime.month;
//     int day = nowTime.day;
//
//     // 本日
//     startDayTime = DateTime(year, month, day, 0, 0, 0);
//     endDayTime = DateTime(year, month, day, 23, 56, 56);
//     // 昨日
//     startLastDayTime = DateTime(year, month, day - 1, 0, 0, 0);
//     endLastDayTime = DateTime(year, month, day - 1, 23, 56, 56);
//     // 明日
//     startNextDayTime = DateTime(year, month, day + 1, 0, 0, 0);
//     endNextDayTime = DateTime(year, month, day + 1, 23, 56, 56);
//
//     // 本周
//     startWorkTime =
//         startDayTime.subtract(Duration(days: (nowTime.weekday - 1)));
//     endWorkTime = endDayTime.add(Duration(days: (7 - nowTime.weekday)));
//     // 上周
//     startLastWorkTime = startWorkTime.subtract(const Duration(days: 7));
//     endLastWorkTime = endWorkTime.subtract(const Duration(days: 7));
//     // 下周
//     startNextWorkTime = startWorkTime.add(const Duration(days: 7));
//     endNextWorkTime = endWorkTime.add(const Duration(days: 7));
//
//     // 本年
//     startYearTime = DateTime(year);
//     endYearTime = DateTime(year, 12, 31, 23, 59, 59);
//
//     // 近一年（365天)
//     startNearlyYearTime = nowTime.subtract(const Duration(days: 365));
//     endNearlyYearTime = nowTime;
//
//     // 本月
//     maxMouthDays = DateUtil.getDaysInMouth(year: year, month: month);
//     startMouthTime = DateTime(year, month);
//     endMouthTime = DateTime(year, month, maxMouthDays, 23, 59, 59, 999);
//
//     // 上一个月
//     int lastYear = year;
//     int lastMouth = month - 1;
//     if (month == 1) {
//       lastYear = year - 1;
//       lastMouth = 12;
//     }
//     maxLastMouthDays =
//         DateUtil.getDaysInMouth(year: lastYear, month: lastMouth);
//     startLastMouthTime = DateTime(lastYear, lastMouth);
//     endLastMouthTime =
//         DateTime(lastYear, lastMouth, maxLastMouthDays, 23, 59, 59, 999);
//
//     // 下个月
//     int nextYear = year;
//     int nextMouth = month + 1;
//     if (month == 12) {
//       nextYear = year + 1;
//       nextMouth = 1;
//     }
//     maxNextMouthDays =
//         DateUtil.getDaysInMouth(year: nextYear, month: nextMouth);
//     startNextMouthTime = DateTime(nextYear, nextMouth);
//     endNextMouthTime =
//         DateTime(nextYear, nextMouth, maxNextMouthDays, 23, 59, 59, 999);
//   }
// }
//
// class TimeModel {
//   String? startTime;
//   String? endTime;
//   String timeStr;
//
//   TimeModel({
//     this.startTime,
//     this.endTime,
//     required this.timeStr,
//   });
//
//   static List<TimeModel> getTimes() {
//     TimeTool timeTool = TimeTool();
//     return [
//       TimeModel(
//           startTime: '1970-01-01 00:00:01',
//           endTime: '3000-12-31 23:59:59',
//           timeStr: '全部'),
//       TimeModel(
//           startTime: DateUtil.getDateStrByDateTime(timeTool.startDayTime),
//           endTime: DateUtil.getDateStrByDateTime(timeTool.endDayTime),
//           timeStr: '今日'),
//       TimeModel(
//           startTime: DateUtil.getDateStrByDateTime(timeTool.startWorkTime),
//           endTime: DateUtil.getDateStrByDateTime(timeTool.endWorkTime),
//           timeStr: '本周'),
//       TimeModel(
//           startTime: DateUtil.getDateStrByDateTime(timeTool.startMouthTime),
//           endTime: DateUtil.getDateStrByDateTime(timeTool.endMouthTime),
//           timeStr: '本月'),
//       TimeModel(
//           startTime: DateUtil.getDateStrByDateTime(timeTool.startLastMouthTime),
//           endTime: DateUtil.getDateStrByDateTime(timeTool.endLastMouthTime),
//           timeStr: '上月'),
//       TimeModel(
//           startTime: DateUtil.getDateStrByDateTime(timeTool.startYearTime),
//           endTime: DateUtil.getDateStrByDateTime(timeTool.endYearTime),
//           timeStr: '本年'),
//     ];
//   }
// }
