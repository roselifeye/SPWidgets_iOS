//
//  SPCalendar.h
//  SPWidgets_iOS
//
//  Created by sy2036 on 2016-06-11.
//  Copyright © 2016 roselifeye. All rights reserved.
//

#import <UIKit/UIKit.h>

#define STCalendarViewTopBarHeight 60

#define STCalendarViewDayHeight 44

@class SPCalendar;

@protocol SPCalendarDelegate <NSObject>

- (void)calendarView:(SPCalendar *)calendarView currentMonth:(NSInteger)month targetHeight:(float)targetHeight animated:(BOOL)animated;

- (void)calendarView:(SPCalendar *)calendarView dateSeleceted:(NSDate *)date andPrevSelectedDate:(NSDate *)prevDate;

@end

@interface SPCalendar : UIView

@property (nonatomic, retain) id<SPCalendarDelegate> delegate;

@property (nonatomic, getter = calendarHeight) float calendarHeight;
@property (nonatomic, retain, getter = selectedDate) NSDate *selectedDate;

-(id)initWithParentView:(UIView *)pView;

- (void)selectDate:(int)date;
- (void)reset;

- (void)markDates:(NSArray *)dates;
/**
 *  The dates here can only be an array of NSDates.
 *  Only the specific days of the months will be marked.
 *
 *  @param dates Dates Array
 */
- (void)markEvents:(NSArray *)dates;

- (void)showNextMonth;
- (void)showPreviousMonth;

- (int)numRows;
- (void)updateSize;
- (UIImage *)drawCurrentState;

@end
