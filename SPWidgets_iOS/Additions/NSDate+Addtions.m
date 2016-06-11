//
//  NSDate+Addtions.m
//  
//
//  Created by Roselifeye on 14-5-10.
//  Copyright (c) 2014年 Roselifeye. All rights reserved.
//

#import "NSDate+Addtions.h"

@implementation NSDate (Addtions)

+ (BOOL)isNightWithMorning:(NSInteger)morning
                  andNight:(NSInteger)night {
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitHour fromDate:now];
    if (components.hour >= night || components.hour <= morning)
        return YES;
    else
        return NO;
}

+ (NSDate *)beginToday {
    NSDate *now = [NSDate date];
    
    return [NSDate dateWithYear:now.year
                          Month:now.month
                            Day:now.day
                           Hour:0
                         Minute:0
                         Second:0];
}

+ (NSDate *)beginYesterday {
    NSDate *beginToday = [NSDate beginToday];
    NSTimeInterval interval = 24*60*60;

    return [[NSDate alloc] initWithTimeInterval:-interval
                                      sinceDate:beginToday];
}

+ (NSDate *)endYesterday {
    NSDate *beginToday = [NSDate beginToday];
    NSTimeInterval interval = 1;
    
    return [[NSDate alloc] initWithTimeInterval:-interval
                                      sinceDate:beginToday];
}

+ (NSDate *)beginDayBeforeYesterday {
    NSDate *beginYesterday = [NSDate beginYesterday];
    NSTimeInterval interval = 24*60*60;
    
    return [[NSDate alloc] initWithTimeInterval:-interval
                                      sinceDate:beginYesterday];
}

+ (NSDate *)endDayBeforeYesterday {
    NSDate *beginYesterday = [NSDate beginYesterday];
    NSTimeInterval interval = 1;
    
    return [[NSDate alloc] initWithTimeInterval:-interval
                                      sinceDate:beginYesterday];
}


+ (NSDate *)dateWithYear:(NSUInteger)year
                   Month:(NSUInteger)month
                     Day:(NSUInteger)day
                    Hour:(NSUInteger)hour
                  Minute:(NSUInteger)minute
                  Second:(NSUInteger)second {
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate date]];
    dateComponents.year = year;
    dateComponents.month = month;
    dateComponents.day = day;
    dateComponents.hour = hour;
    dateComponents.minute = minute;
    dateComponents.second = second;
    
    return [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
}

+ (NSDateFormatter *)defaultDateFormatterWithFormatYYYYMMddHHmmss {
    static NSDateFormatter *staticDateFormatterWithFormatYYYYMMddHHmmss;
    if (!staticDateFormatterWithFormatYYYYMMddHHmmss) {
        staticDateFormatterWithFormatYYYYMMddHHmmss = [[NSDateFormatter alloc] init];
        [staticDateFormatterWithFormatYYYYMMddHHmmss setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    }
    
    return staticDateFormatterWithFormatYYYYMMddHHmmss;
}

+ (NSDateFormatter *)defaultDateFormatterWithFormatYYYYMMdd {
    static NSDateFormatter *staticDateFormatterWithFormatYYYYMMddHHmmss;
    if (!staticDateFormatterWithFormatYYYYMMddHHmmss) {
        staticDateFormatterWithFormatYYYYMMddHHmmss = [[NSDateFormatter alloc] init];
        [staticDateFormatterWithFormatYYYYMMddHHmmss setDateFormat:@"YYYY.MM.dd"];
    }
    
    return staticDateFormatterWithFormatYYYYMMddHHmmss;
}


+ (NSDateFormatter *)defaultDateFormatterWithFormatMMddHHmm {
    static NSDateFormatter *staticDateFormatterWithFormatMMddHHmm;
    if (!staticDateFormatterWithFormatMMddHHmm) {
        staticDateFormatterWithFormatMMddHHmm = [[NSDateFormatter alloc] init];
        [staticDateFormatterWithFormatMMddHHmm setDateFormat:@"MM-dd HH:mm"];
    }
    
    return staticDateFormatterWithFormatMMddHHmm;
}

+ (NSDateFormatter *)defaultDateFormatterWithFormatYYYYMMddHHmmInChinese {
    static NSDateFormatter *staticDateFormatterWithFormatYYYYMMddHHmmssInChines;
    if (!staticDateFormatterWithFormatYYYYMMddHHmmssInChines) {
        staticDateFormatterWithFormatYYYYMMddHHmmssInChines = [[NSDateFormatter alloc] init];
        [staticDateFormatterWithFormatYYYYMMddHHmmssInChines setDateFormat:@"YYYY年MM月dd日 HH:mm"];
    }
    
    return staticDateFormatterWithFormatYYYYMMddHHmmssInChines;
}

+ (NSDateFormatter *)defaultDateFormatterWithFormatMMddHHmmInChinese {
    static NSDateFormatter *staticDateFormatterWithFormatMMddHHmmInChinese;
    if (!staticDateFormatterWithFormatMMddHHmmInChinese) {
        staticDateFormatterWithFormatMMddHHmmInChinese = [[NSDateFormatter alloc] init];
        [staticDateFormatterWithFormatMMddHHmmInChinese setDateFormat:@"MM月dd日 HH:mm"];
    }
    
    return staticDateFormatterWithFormatMMddHHmmInChinese;
}


#pragma mark - 
#pragma mark - Part of the date
- (NSDateComponents *)componentsOfDay {
    return [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
}

- (NSUInteger)year {
    return [self componentsOfDay].year;
}


- (NSUInteger)month {
    return [self componentsOfDay].month;
}

- (NSUInteger)day {
    return [self componentsOfDay].day;
}

- (NSUInteger)hour {
    return [self componentsOfDay].hour;
}


- (NSUInteger)minute {
    return [self componentsOfDay].minute;
}


- (NSUInteger)second {
    return [self componentsOfDay].second;
}


- (NSUInteger)weekday {
    return [self componentsOfDay].weekday;
}


- (NSUInteger)weekOfDayInYear {
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitWeekOfYear inUnit:NSCalendarUnitYear forDate:self];
}

- (NSDate *)workBeginTime {
    unsigned int flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:flags fromDate:self];
    [components setHour:9];
    [components setMinute:30];
    [components setSecond:0];
    
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (NSDate *)workEndTime {
    unsigned int flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:flags fromDate:self];
    [components setHour:18];
    [components setMinute:0];
    [components setSecond:0];
    
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}


- (NSDate *)oneHourLater {
    return [NSDate dateWithTimeInterval:3600 sinceDate:self];
}

- (NSDate *)sameTimeOfDate {
    unsigned int flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:flags fromDate:self];
    [components setHour:[[NSDate date] hour]];
    [components setMinute:[[NSDate date] minute]];
    [components setSecond:[[NSDate date] second]];
    
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (BOOL)sameDayWithDate:(NSDate *)otherDate {
    if (self.year == otherDate.year && self.month == otherDate.month && self.day == otherDate.day)
        return YES;
    else
        return NO;
}

- (BOOL)sameWeekWithDate:(NSDate *)otherDate {
    if (self.year == otherDate.year  && self.month == otherDate.month && self.weekOfDayInYear == otherDate.weekOfDayInYear)
        return YES;
    else
        return NO;
}

- (BOOL)sameMonthWithDate:(NSDate *)otherDate {
    if (self.year == otherDate.year && self.month == otherDate.month)
        return YES;
    else
        return NO;
}

#pragma mark - 
#pragma mark - String of the date
- (NSString *)stringOfDateWithFormatYYYYMMddHHmmss {
    return [[NSDate defaultDateFormatterWithFormatYYYYMMddHHmmss] stringFromDate:self];
}

- (NSString *)stringOfDateWithFormatYYYYMMdd {
    return [[NSDate defaultDateFormatterWithFormatYYYYMMdd] stringFromDate:self];
}

- (NSString *)stringOfDateWithFormatMMddHHmm {
    return [[NSDate defaultDateFormatterWithFormatMMddHHmm] stringFromDate:self];
}

- (NSString *)stringOfDateWithFormatYYYYMMddHHmmInChinese {
    return [[NSDate defaultDateFormatterWithFormatYYYYMMddHHmmInChinese] stringFromDate:self];
}

- (NSString *)stringOfDateWithFormatMMddHHmmInChinese {
    return [[NSDate defaultDateFormatterWithFormatMMddHHmmInChinese] stringFromDate:self];
}

#pragma mark - 
#pragma mark - Offset of the Date
- (NSDate *)offsetMonth:(int)numMonths {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:2]; //monday is first day
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:numMonths];
    //[offsetComponents setHour:1];
    //[offsetComponents setMinute:30];
    return [gregorian dateByAddingComponents:offsetComponents toDate:self options:0];
}

- (NSDate *)offsetHours:(int)hours {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:2]; //monday is first day
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    //[offsetComponents setMonth:numMonths];
    [offsetComponents setHour:hours];
    //[offsetComponents setMinute:30];
    return [gregorian dateByAddingComponents:offsetComponents
                                      toDate:self options:0];
}

- (NSDate *)offsetDay:(int)numDays {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:2]; //monday is first day
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:numDays];
    //[offsetComponents setHour:1];
    //[offsetComponents setMinute:30];
    
    return [gregorian dateByAddingComponents:offsetComponents toDate:self options:0];
}

- (NSUInteger)firstWeekDayInMonth {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:2];
    
    //Set date to first of month
    NSDateComponents *comps = [gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay fromDate:self];
    [comps setDay:1];
    NSDate *newDate = [gregorian dateFromComponents:comps];
    
    return [gregorian ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:newDate];
}

- (NSUInteger)numDaysInMonth {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSRange rng = [cal rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    NSUInteger numberOfDaysInMonth = rng.length;
    return numberOfDaysInMonth;
}

@end
