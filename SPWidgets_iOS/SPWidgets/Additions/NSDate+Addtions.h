//
//  NSDate+Addtions.h
//  
//
//  Created by Roselifeye on 14-5-10.
//  Copyright (c) 2014年 Roselifeye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Addtions)

+ (BOOL)isNightWithMorning:(NSInteger)morning
                  andNight:(NSInteger)night;
//  Get the date today.
+ (NSDate *)beginToday;
//  Get the date yesterday.
+ (NSDate *)beginYesterday;
//  Get the end of the date yesterday.
+ (NSDate *)endYesterday;
// Get the date the day before yesterday
+ (NSDate *)beginDayBeforeYesterday;
+ (NSDate *)endDayBeforeYesterday;

//  Return a customized NSDate value by inputs.
+ (NSDate *)dateWithYear:(NSUInteger)year
                   Month:(NSUInteger)month
                     Day:(NSUInteger)day
                    Hour:(NSUInteger)hour
                  Minute:(NSUInteger)minute
                  Second:(NSUInteger)second;

//  Formart the date with following patterns.
+ (NSDateFormatter *)defaultDateFormatterWithFormatYYYYMMddHHmmss;
+ (NSDateFormatter *)defaultDateFormatterWithFormatYYYYMMdd;
+ (NSDateFormatter *)defaultDateFormatterWithFormatMMddHHmm;
+ (NSDateFormatter *)defaultDateFormatterWithFormatYYYYMMddHHmmInChinese;
+ (NSDateFormatter *)defaultDateFormatterWithFormatMMddHHmmInChinese;

//  Get a part of the data information.
- (NSDateComponents *)componentsOfDay;
- (NSUInteger)year;
- (NSUInteger)month;
- (NSUInteger)day;
- (NSUInteger)hour;
- (NSUInteger)minute;
- (NSUInteger)second;
- (NSUInteger)weekday;
- (NSUInteger)weekOfDayInYear;

// Get the work begin time at 9:00.
- (NSDate *)workBeginTime;
// Get the work end time at 18:00.
- (NSDate *)workEndTime;

- (NSDate *)oneHourLater;

- (NSDate *)sameTimeOfDate;

- (BOOL)sameDayWithDate:(NSDate *)otherDate;

- (BOOL)sameWeekWithDate:(NSDate *)otherDate;

- (BOOL)sameMonthWithDate:(NSDate *)otherDate;

//  Get NSString format value of the specified pattern data.
- (NSString *)stringOfDateWithFormatYYYYMMddHHmmss;
- (NSString *)stringOfDateWithFormatYYYYMMdd;
- (NSString *)stringOfDateWithFormatMMddHHmm;
- (NSString *)stringOfDateWithFormatYYYYMMddHHmmInChinese;
- (NSString *)stringOfDateWithFormatMMddHHmmInChinese;

//  Offset of the specific date
- (NSDate *)offsetMonth:(int)numMonths;
- (NSDate *)offsetDay:(int)numDays;
- (NSDate *)offsetHours:(int)hours;

- (NSUInteger)firstWeekDayInMonth;
- (NSUInteger)numDaysInMonth;


@end
