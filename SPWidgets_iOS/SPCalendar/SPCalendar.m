//
//  SPCalendar.m
//  SPWidgets_iOS
//
//  Created by sy2036 on 2016-06-11.
//  Copyright © 2016 roselifeye. All rights reserved.
//

#import "SPCalendar.h"
#import <QuartzCore/QuartzCore.h>
#import "NSDate+Addtions.h"
#import "UIView+Addtions.h"
#import "NSMutableArray+Addtions.h"
#import "UIColor+expanded.h"

@interface SPCalendar() {
    int stCalendarViewWidth;
    int STCalendarViewDayWidth;
    
    NSDate *currentMonth;
    
    //  Diplay the current month in the top bar.
    UILabel *labelCurrentMonth;
    
    BOOL isAnimating;
    BOOL prepAnimationPreviousMonth;
    BOOL prepAnimationNextMonth;
    
    UIImageView *animationView_A;
    UIImageView *animationView_B;
    
    NSArray *markedDates;
    NSArray *markedEvents;
    
    NSDate *prevSelectedDate;
}

@end

@implementation SPCalendar

#pragma mark - Init
- (id)initWithParentView:(UIView *)pView {
    stCalendarViewWidth = pView.frame.size.width;
    STCalendarViewDayWidth = (stCalendarViewWidth-2*6)/7;
    self = [super initWithFrame:CGRectMake(0, 0, stCalendarViewWidth, 0)];
    if (self) {
        self.contentMode = UIViewContentModeTop;
        self.clipsToBounds = YES;
        
        isAnimating = NO;
        labelCurrentMonth = [[UILabel alloc] initWithFrame:CGRectMake(34, 0, stCalendarViewWidth-68, 40)];
        [self addSubview:labelCurrentMonth];
        labelCurrentMonth.backgroundColor = [UIColor whiteColor];
        labelCurrentMonth.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
        labelCurrentMonth.textColor = [UIColor colorWithWhite:0.29 alpha:1];
        labelCurrentMonth.textAlignment = NSTextAlignmentCenter;
        
        /**
         *  So delegate can be set after init and still get called on init,
         *  recalulate the height.
         */
        [self performSelector:@selector(reset) withObject:nil afterDelay:0.1];
    }
    return self;
}

#pragma mark - Select Date
- (void)selectDate:(int)date {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth |
                               NSCalendarUnitDay fromDate:currentMonth];
    [comps setDay:date];
    self.selectedDate = [gregorian dateFromComponents:comps];
    
    NSInteger selectedDateYear = [self.selectedDate year];
    NSInteger selectedDateMonth = [self.selectedDate month];
    NSInteger currentMonthYear = [currentMonth year];
    NSInteger currentMonthMonth = [currentMonth month];
    
    if (selectedDateYear < currentMonthYear) {
        [self showPreviousMonth];
    } else if (selectedDateYear > currentMonthYear) {
        [self showNextMonth];
    } else if (selectedDateMonth < currentMonthMonth) {
        [self showPreviousMonth];
    } else if (selectedDateMonth > currentMonthMonth) {
        [self showNextMonth];
    } else {
        //[self multipleSelectedDates];
        [self setNeedsDisplay];
    }
    if ([self.delegate respondsToSelector:@selector(calendarView:dateSeleceted:andPrevSelectedDate:)])
        [self.delegate calendarView:self dateSeleceted:self.selectedDate andPrevSelectedDate:prevSelectedDate];
}

- (void)multipleSelectedDates {
    if (prevSelectedDate != nil && prevSelectedDate != self.selectedDate) {
        NSMutableArray *dates = [NSMutableArray array];
        NSDate *startDay = [prevSelectedDate earlierDate:self.selectedDate];
        NSDate *endDay = [prevSelectedDate laterDate:self.selectedDate];
        for (int i = (int)[startDay day]; i <= [endDay day]; i++) {
            [dates addObject:[NSNumber numberWithInt:i]];
        }
        [self markDates:dates];
    }
}

#pragma mark - Mark Dates
//  NSArray can either contain NSDate objects or NSNumber objects with an int of the day.
- (void)markDates:(NSArray *)dates {
    markedDates = dates;
    [self setNeedsDisplay];
}

//  Mark events with dates by yellow nodes.
- (void)markEvents:(NSArray *)dates {
    markedEvents = dates;
    [self setNeedsDisplay];
}

#pragma mark - Set date to now
- (void)reset {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth |
                                                          NSCalendarUnitDay) fromDate: [NSDate date]];
    currentMonth = [gregorian dateFromComponents:components]; //clean month
    
    [self updateSize];
    [self setNeedsDisplay];
    [self.delegate calendarView:self currentMonth:[currentMonth month] targetHeight:self.calendarHeight animated:NO];
}

#pragma mark - Next & Previous
- (UIView *)monthMoveHolderSettingForNext:(BOOL)isNextMonth {
    //  Old month
    float oldSize = self.calendarHeight;
    UIImage *imageCurrentMonth = [self drawCurrentState];
    
    //  New month
    if (isNextMonth) {
        prepAnimationNextMonth = NO;
        currentMonth = [currentMonth offsetMonth:1];
    } else {
        prepAnimationPreviousMonth = NO;
        currentMonth = [currentMonth offsetMonth:-1];
    }
    [self setNeedsDisplay];
    
    UIImage *imageNextMonth = [self drawCurrentState];
    float targetSize = fmaxf(oldSize, self.calendarHeight);
    UIView *animationHolder = [[UIView alloc] initWithFrame:CGRectMake(0, STCalendarViewTopBarHeight, stCalendarViewWidth, targetSize-STCalendarViewTopBarHeight)];
    
    [animationHolder setClipsToBounds:YES];
    [self addSubview:animationHolder];
    //  Animate
    animationView_A = [[UIImageView alloc] initWithImage:imageCurrentMonth];
    animationView_B = [[UIImageView alloc] initWithImage:imageNextMonth];
    [animationHolder addSubview:animationView_A];
    [animationHolder addSubview:animationView_B];
    
    return animationHolder;
}

- (void)showNextMonth {
    if (isAnimating) return;
    isAnimating = YES;
    markedDates = nil;
    prepAnimationNextMonth = YES;
    [self setNeedsDisplay];
    
    int lastBlock = (int)[currentMonth firstWeekDayInMonth]+(int)[currentMonth numDaysInMonth]-1;
    int numBlocks = [self numRows]*7;
    BOOL hasNextMonthDays = lastBlock<numBlocks;
    
    UIView *animationHolder = [self monthMoveHolderSettingForNext:YES];
    if (hasNextMonthDays) {
        animationView_B.frameY = animationView_A.frameY + animationView_A.frameHeight - (STCalendarViewDayHeight+3);
    } else {
        animationView_B.frameY = animationView_A.frameY + animationView_A.frameHeight - 3;
    }
    //  Animation
    [UIView animateWithDuration:.35
                     animations:^{
                         [self updateSize];
                         //blockSafeSelf.frameHeight = 100;
                         if (hasNextMonthDays) {
                             animationView_A.frameY = -animationView_A.frameHeight + STCalendarViewDayHeight+3;
                         } else {
                             animationView_A.frameY = -animationView_A.frameHeight + 3;
                         }
                         animationView_B.frameY = 0;
                     }
                     completion:^(BOOL finished) {
                         [animationView_A removeFromSuperview];
                         [animationView_B removeFromSuperview];
                         animationView_A = nil;
                         animationView_B = nil;
                         isAnimating = NO;
                         [animationHolder removeFromSuperview];
                     }
     ];
    if ([self.delegate respondsToSelector:@selector(calendarView:currentMonth:targetHeight:animated:)])
        [self.delegate calendarView:self currentMonth:[currentMonth month] targetHeight:self.calendarHeight animated:YES];
}

- (void)showPreviousMonth {
    if (isAnimating) return;
    isAnimating = YES;
    markedDates = nil;
    prepAnimationPreviousMonth = YES;
    [self setNeedsDisplay];
    
    BOOL hasPreviousDays = [currentMonth firstWeekDayInMonth]>1;
    
    UIView *animationHolder = [self monthMoveHolderSettingForNext:NO];
    if (hasPreviousDays) {
        animationView_B.frameY = animationView_A.frameY - (animationView_B.frameHeight-STCalendarViewDayHeight) + 3;
    } else {
        animationView_B.frameY = animationView_A.frameY - animationView_B.frameHeight + 3;
    }
    
    [UIView animateWithDuration:.35
                     animations:^{
                         [self updateSize];
                         if (hasPreviousDays) {
                             animationView_A.frameY = animationView_B.frameHeight-(STCalendarViewDayHeight+3);
                             
                         } else {
                             animationView_A.frameY = animationView_B.frameHeight-3;
                         }
                         animationView_B.frameY = 0;
                     }
                     completion:^(BOOL finished) {
                         [animationView_A removeFromSuperview];
                         [animationView_B removeFromSuperview];
                         animationView_A = nil;
                         animationView_B = nil;
                         isAnimating=NO;
                         [animationHolder removeFromSuperview];
                     }
     ];
    if ([self.delegate respondsToSelector:@selector(calendarView:currentMonth:targetHeight:animated:)])
        [self.delegate calendarView:self currentMonth:[currentMonth month] targetHeight:self.calendarHeight animated:YES];
}

#pragma mark - update size & row count
- (void)updateSize {
    self.frameHeight = self.calendarHeight;
    [self setNeedsDisplay];
}

- (float)calendarHeight {
    return STCalendarViewTopBarHeight + [self numRows]*(STCalendarViewDayHeight+2)+1;
}

- (int)numRows {
    float lastBlock = [currentMonth numDaysInMonth]+([currentMonth firstWeekDayInMonth]-1);
    return ceilf(lastBlock/7);
}

#pragma mark - Touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    prevSelectedDate = self.selectedDate;
    self.selectedDate = nil;
    
    //Touch a specific day
    if (touchPoint.y > STCalendarViewTopBarHeight) {
        float xLocation = touchPoint.x;
        float yLocation = touchPoint.y-STCalendarViewTopBarHeight;
        
        int column = floorf(xLocation/(STCalendarViewDayWidth+2));
        int row = floorf(yLocation/(STCalendarViewDayHeight+2));
        
        int blockNr = (column+1)+row*7;
        int firstWeekDay = (int)[currentMonth firstWeekDayInMonth]-1; //-1 because weekdays begin at 1, not 0
        int date = blockNr-firstWeekDay;
        [self selectDate:date];
        return;
    }
    markedDates = nil;
    
    CGRect rectArrowLeft = CGRectMake(0, 0, 50, 40);
    CGRect rectArrowRight = CGRectMake(self.frame.size.width-50, 0, 50, 40);
    
    //  1Touch either arrows or month in middle
    if (CGRectContainsPoint(rectArrowLeft, touchPoint)) {
        [self showPreviousMonth];
    } else if (CGRectContainsPoint(rectArrowRight, touchPoint)) {
        [self showNextMonth];
    } else if (CGRectContainsPoint(labelCurrentMonth.frame, touchPoint)) {
        //  1Detect touch in current month
        int currentMonthIndex = (int)[currentMonth month];
        int todayMonth = (int)[[NSDate date] month];
        [self reset];
        if ((todayMonth!=currentMonthIndex) && [self.delegate respondsToSelector:@selector(calendarView:currentMonth:targetHeight:animated:)])
            [self.delegate calendarView:self currentMonth:[currentMonth month] targetHeight:self.calendarHeight animated:NO];
    }
}

#pragma mark - Draw image for animation
- (UIImage *)drawCurrentState {
    float targetHeight = STCalendarViewTopBarHeight + [self numRows]*(STCalendarViewDayHeight+2)+1;
    
    UIGraphicsBeginImageContext(CGSizeMake(stCalendarViewWidth, targetHeight-STCalendarViewTopBarHeight));
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(c, 0, -STCalendarViewTopBarHeight);    // <-- shift everything up by 40px when drawing.
    [self.layer renderInContext:c];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

#pragma mark - Draw Interface
- (void)drawRect:(CGRect)rect {
    int firstWeekDay = (int)[currentMonth firstWeekDayInMonth]-1; //-1 because weekdays begin at 1, not 0
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM yyyy"];
    labelCurrentMonth.text = [formatter stringFromDate:currentMonth];
    [labelCurrentMonth sizeToFit];
    labelCurrentMonth.frameX = roundf(self.frame.size.width/2 - labelCurrentMonth.frameWidth/2);
    labelCurrentMonth.frameY = 10;
    [currentMonth firstWeekDayInMonth];
    
    CGContextClearRect(UIGraphicsGetCurrentContext(),rect);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //  Draw the top bar.
    [self drawTopBarWithContext:context];
    int numRows = [self numRows];
    CGContextSetAllowsAntialiasing(context, NO);
    [self drawGridContentWithContext:context andRows:numRows];
    
    //  Draw days
    CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:0.22 alpha:1].CGColor);
    
    int numBlocks = numRows*7;
    NSDate *previousMonth = [currentMonth offsetMonth:-1];
    int currentMonthNumDays = (int)[currentMonth numDaysInMonth];
    int prevMonthNumDays = (int)[previousMonth numDaysInMonth];
    
    int selectedDateBlock = ((int)[self.selectedDate day]-1) + firstWeekDay;
    
    //  Distinguish the current month is Previous or Next.
    BOOL isSelectedDatePreviousMonth = prepAnimationPreviousMonth;
    BOOL isSelectedDateNextMonth = prepAnimationNextMonth;
    
    if (self.selectedDate != nil) {
        isSelectedDatePreviousMonth = ([self.selectedDate year]==[currentMonth year] && [self.selectedDate month]<[currentMonth month]) || [self.selectedDate year] < [currentMonth year];
        
        if (!isSelectedDatePreviousMonth) {
            isSelectedDateNextMonth = ([self.selectedDate year]==[currentMonth year] && [self.selectedDate month]>[currentMonth month]) || [self.selectedDate year] > [currentMonth year];
        }
    }
    if (isSelectedDatePreviousMonth) {
        int lastPositionPreviousMonth = firstWeekDay - 1;
        selectedDateBlock = lastPositionPreviousMonth - (int)([self.selectedDate numDaysInMonth]-[self.selectedDate day]);
    } else if (isSelectedDateNextMonth) {
        selectedDateBlock = (int)[currentMonth numDaysInMonth] + (firstWeekDay-1) + (int)[self.selectedDate day];
    }
    NSDate *todayDate = [NSDate date];
    int todayBlock = -1;
    if ([todayDate month] == [currentMonth month] && [todayDate year] == [currentMonth year]) {
        todayBlock = (int)[todayDate day] + firstWeekDay - 1;
    }
    //  Draw Mark Dates
    if (markedDates)
        [self drawMarkForDateWithContext:context andFirstWeekDay:firstWeekDay];
    //  Draw the text and status for all grids, or called dates.
    for (int i = 0; i < numBlocks; i++) {
        int targetDate = i;
        int targetColumn = i%7;
        int targetRow = i/7;
        int targetX = targetColumn * (STCalendarViewDayWidth+2);
        int targetY = STCalendarViewTopBarHeight + targetRow * (STCalendarViewDayHeight+2);
        NSString *hex;
        //  Draw selected date.
        if (self.selectedDate && i == selectedDateBlock) {
            //  Set the selected date's color.
            [self drawShapeWithContext:context
                              andFrame:CGRectMake(targetX, targetY, STCalendarViewDayWidth+2, STCalendarViewDayHeight+2)
                              andColor:[UIColor colorWithRed:0.186 green:0.76 blue:0.49 alpha:1]
                               isRound:NO];
        }
        
        //  Draw the date text for each grid.
        if (i < firstWeekDay) {
            //  Previous Month.
            targetDate = (prevMonthNumDays-firstWeekDay)+(i+1);
            hex = (isSelectedDatePreviousMonth) ? @"0x383838" : @"aaaaaa";
        } else if (i >= (firstWeekDay+currentMonthNumDays)) {
            //  Next Month.
            targetDate = (i+1) - (firstWeekDay+currentMonthNumDays);
            hex = (isSelectedDateNextMonth) ? @"0x383838" : @"aaaaaa";
        } else {
            //  Current Month.
            targetDate = (i-firstWeekDay)+1;
            hex = (isSelectedDatePreviousMonth || isSelectedDateNextMonth) ? @"0xaaaaaa" : @"0x383838";
            if ([markedDates containsObject:[NSNumber numberWithInt:targetDate]] || [self.selectedDate day] == targetDate) {
                hex = @"0xFFFFFF";
            }
        }
        NSString *date = [NSString stringWithFormat:@"%i",targetDate];
        [self drawTextWithStr:date andFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]
                     andFrame:CGRectMake(targetX+2, targetY+10, STCalendarViewDayWidth, STCalendarViewDayHeight)
                     andColor:[UIColor colorWithHexString:hex]];
        
        //  Draw today's mark line.
        if (todayBlock == i) {
            BOOL isContainedToday = [markedDates containsObject:[NSNumber numberWithUnsignedInteger:[todayDate day]]];
            if (todayBlock==selectedDateBlock || isContainedToday) {
                [self drawLineWithContext:context andTargetX:targetX andTargetY:targetY+STCalendarViewDayHeight andColorStr:@"0xFFFFFF"];
            } else {
                [self drawLineWithContext:context andTargetX:targetX andTargetY:targetY+STCalendarViewDayHeight andColorStr:@"0x383838"];
            }
        }
    }
    if (markedEvents) {
        [self drawMarkForEventsWithContext:context andFirstWeekDay:firstWeekDay];
    }
}

/**
 *  Draw the date text on the grid.
 *
 *  @param str   Date text.
 *  @param font  Font of the text.
 *  @param frame Size of the text.
 *  @param color Color of the text.
 */
- (void)drawTextWithStr:(NSString *)str andFont:(UIFont *)font andFrame:(CGRect)frame andColor:(UIColor *)color{
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByClipping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSFontAttributeName:font,
                                 NSParagraphStyleAttributeName:paragraphStyle,
                                 NSForegroundColorAttributeName:color};
    [str drawInRect:frame withAttributes:attributes];
}

/**
 *  Draw a shape with specified frame and color.
 *
 *  @param context Context of the View.
 *  @param frame   Framw of the shape.
 *  @param color   Color of the shape.
 */
- (void)drawShapeWithContext:(CGContextRef)context andFrame:(CGRect)frame andColor:(UIColor *)color isRound:(BOOL)isRound {
    CGRect rectangleGrid = frame;
    if (isRound)
        CGContextAddArc(context, rectangleGrid.origin.x, rectangleGrid.origin.y, rectangleGrid.size.width/2, 0, 2*M_PI, 0);
    else
        CGContextAddRect(context, rectangleGrid);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillPath(context);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
}

/**
 *  Draw line on the specified position.
 *  It is based on the Draw Shape Function.
 *
 *  @param context  Context of the View.
 *  @param targetX  The X coordinate of the position.
 *  @param targetY  The Y coordinate of the position.
 *  @param colorStr The hex string of the color of the Line.
 */
- (void)drawLineWithContext:(CGContextRef)context andTargetX:(int)targetX andTargetY:(int)targetY andColorStr:(NSString *)colorStr {
    [self drawShapeWithContext:context
                      andFrame:CGRectMake(targetX+5, targetY-2, STCalendarViewDayWidth-8, 2)
                      andColor:[UIColor colorWithHexString:colorStr]
                       isRound:NO];
}

- (void)drawMarkForEventsWithContext:(CGContextRef)context andFirstWeekDay:(int)firstWeekDay {
    for (int i = 0; i < [markedEvents count]; i++) {
        id markedDateObj = [markedEvents objectAtIndex:i];
        if ([markedDateObj isKindOfClass:[NSDate class]]) {
            NSDate *date = (NSDate *)markedDateObj;
            if ([date month] == [currentMonth month] && [date year] == [currentMonth year]) {
                int targetDate = (int)[date day];
                int targetBlock = firstWeekDay + (targetDate-1);
                int targetColumn = targetBlock%7;
                int targetRow = targetBlock/7;
                int targetX = targetColumn * (STCalendarViewDayWidth+2);
                int targetY = STCalendarViewTopBarHeight + targetRow * (STCalendarViewDayHeight+2);
                
                [self drawShapeWithContext:context
                                  andFrame:CGRectMake(targetX+STCalendarViewDayWidth/2+2, targetY+STCalendarViewDayWidth/2+10, 8, 8)
                                  andColor:[UIColor colorWithRed:1.f green:.843f blue:0.f alpha:1.f]
                                   isRound:YES];
            }
        } else {
            continue;
        }
    }
}

/**
 *  Draw Mark Dates with Lines
 *
 *  @param context           Context of the View.
 *  @param firstWeekDay      The first day of the week.
 *  @param selectedDateBlock Current Selected Date Block.
 *  @param todayBlock        Today Block.
 */
- (void)drawMarkForDateWithContext:(CGContextRef)context andFirstWeekDay:(int)firstWeekDay {
    for (int i = 0; i < [markedDates count]; i++) {
        id markedDateObj = [markedDates objectAtIndex:i];
        
        int targetDate;
        if ([markedDateObj isKindOfClass:[NSNumber class]]) {
            targetDate = [(NSNumber *)markedDateObj intValue];
        } else if ([markedDateObj isKindOfClass:[NSDate class]]) {
            NSDate *date = (NSDate *)markedDateObj;
            targetDate = (int)[date day];
        } else {
            continue;
        }
        int targetBlock = firstWeekDay + (targetDate-1);
        int targetColumn = targetBlock%7;
        int targetRow = targetBlock/7;
        int targetX = targetColumn * (STCalendarViewDayWidth+2);
        int targetY = STCalendarViewTopBarHeight + targetRow * (STCalendarViewDayHeight+2);
        
        [self drawShapeWithContext:context
                          andFrame:CGRectMake(targetX, targetY, STCalendarViewDayWidth+2, STCalendarViewDayHeight+2)
                          andColor:[UIColor colorWithRed:0.186 green:0.76 blue:0.49 alpha:1]
                           isRound:NO];
    }
}

#pragma mark - Draw Calendar UI.
/**
 *  Draw the Top Bar of the Calendar
 *
 *  @param context Context of the View.
 */
- (void)drawTopBarWithContext:(CGContextRef)context {
    [self drawShapeWithContext:context
                      andFrame:CGRectMake(0,0,self.frame.size.width,STCalendarViewTopBarHeight)
                      andColor:[UIColor whiteColor]
                       isRound:NO];
    //  Draw Arrows.
    [self drawArrowsWithContext:context];
    //  Weekdays.
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"EEE";
    //  Always assume gregorian with Monday first.
    NSMutableArray *weekdays = [[NSMutableArray alloc] initWithArray:[dateFormatter shortWeekdaySymbols]];
    [weekdays moveObjectFromIndex:0 toIndex:6];
    for (int i =0; i<[weekdays count]; i++) {
        NSString *weekdayValue = (NSString *)[weekdays objectAtIndex:i];
        [self drawTextWithStr:weekdayValue andFont:[UIFont fontWithName:@"HelveticaNeue" size:12]
                     andFrame:CGRectMake(i*(STCalendarViewDayWidth+2), 40, STCalendarViewDayWidth+2, 20)
                     andColor:[UIColor colorWithWhite:0.22 alpha:1]];
    }
}

/**
 *  Draw the arrows for switching month.
 *
 *  @param context Context of the View.
 */
- (void)drawArrowsWithContext:(CGContextRef)context {
    int arrowSize = 12;
    int xmargin = 20;
    int ymargin = 18;
    //  Arrow Left
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, xmargin+arrowSize/1.5, ymargin);
    CGContextAddLineToPoint(context,xmargin+arrowSize/1.5,ymargin+arrowSize);
    CGContextAddLineToPoint(context,xmargin,ymargin+arrowSize/2);
    CGContextAddLineToPoint(context,xmargin+arrowSize/1.5, ymargin);
    
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillPath(context);
    
    //  Arrow right
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, self.frame.size.width-(xmargin+arrowSize/1.5), ymargin);
    CGContextAddLineToPoint(context,self.frame.size.width-xmargin,ymargin+arrowSize/2);
    CGContextAddLineToPoint(context,self.frame.size.width-(xmargin+arrowSize/1.5),ymargin+arrowSize);
    CGContextAddLineToPoint(context,self.frame.size.width-(xmargin+arrowSize/1.5), ymargin);
    
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillPath(context);
}

/**
 *  Draw Grid
 *
 *  @param context Context of the View.
 *  @param numRows Number of rows.
 */
- (void)drawGridContentWithContext:(CGContextRef)context andRows:(int)numRows {
    float gridHeight = numRows*(STCalendarViewDayHeight+2)+1;
    [self drawGridBGWithContext:context andGridHeight:gridHeight];
    [self drawWhiteLinesWithContext:context andGridHeight:gridHeight andRows:numRows];
    [self drawDarkLinesWithContext:context andGridHeight:gridHeight andRows:numRows];
}

/**
 *  Grid Background
 *  It's a sub of above drawGridContent function.
 *
 *  @param context    Context of the View.
 *  @param gridHeight Height of the grid.
 */
- (void)drawGridBGWithContext:(CGContextRef)context andGridHeight:(float)gridHeight {
    [self drawShapeWithContext:context
                      andFrame:CGRectMake(0,STCalendarViewTopBarHeight,self.frame.size.width,gridHeight)
                      andColor:[UIColor colorWithWhite:0.953 alpha:1]
                       isRound:NO];
}

/**
 *  Grid White Lines
 *  It's a sub of above drawGridContent function.
 *
 *  @param context    Context of the View.
 *  @param gridHeight Height of the grid.
 *  @param numRows    Number of Rows.
 */
- (void)drawWhiteLinesWithContext:(CGContextRef)context andGridHeight:(float)gridHeight andRows:(int)numRows {
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, STCalendarViewTopBarHeight+1);
    CGContextAddLineToPoint(context, stCalendarViewWidth, STCalendarViewTopBarHeight+1);
    for (int i = 1; i<7; i++) {
        CGContextMoveToPoint(context, i*(STCalendarViewDayWidth+1)+i*1-1, STCalendarViewTopBarHeight);
        CGContextAddLineToPoint(context, i*(STCalendarViewDayWidth+1)+i*1-1, STCalendarViewTopBarHeight+gridHeight);
        
        if (i>numRows-1) continue;
        //  Rows
        CGContextMoveToPoint(context, 0, STCalendarViewTopBarHeight+i*(STCalendarViewDayHeight+1)+i*1+1);
        CGContextAddLineToPoint(context, stCalendarViewWidth, STCalendarViewTopBarHeight+i*(STCalendarViewDayHeight+1)+i*1+1);
    }
    CGContextStrokePath(context);
}

/**
 *  Grid Dark Lines
 *  It's a sub of above drawGridContent function.
 *
 *  @param context    Context of the View.
 *  @param gridHeight Height of the grid.
 *  @param numRows    Number of Rows.
 */
- (void)drawDarkLinesWithContext:(CGContextRef)context andGridHeight:(float)gridHeight andRows:(int)numRows {
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"0xcfd4d8"].CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, STCalendarViewTopBarHeight);
    CGContextAddLineToPoint(context, stCalendarViewWidth, STCalendarViewTopBarHeight);
    for (int i = 1; i<7; i++) {
        //  Columns
        CGContextMoveToPoint(context, i*(STCalendarViewDayWidth+1)+i*1, STCalendarViewTopBarHeight);
        CGContextAddLineToPoint(context, i*(STCalendarViewDayWidth+1)+i*1, STCalendarViewTopBarHeight+gridHeight);
        
        if (i>numRows-1) continue;
        //  Rows
        CGContextMoveToPoint(context, 0, STCalendarViewTopBarHeight+i*(STCalendarViewDayHeight+1)+i*1);
        CGContextAddLineToPoint(context, stCalendarViewWidth, STCalendarViewTopBarHeight+i*(STCalendarViewDayHeight+1)+i*1);
    }
    CGContextMoveToPoint(context, 0, gridHeight+STCalendarViewTopBarHeight);
    CGContextAddLineToPoint(context, stCalendarViewWidth, gridHeight+STCalendarViewTopBarHeight);
    
    CGContextStrokePath(context);
    CGContextSetAllowsAntialiasing(context, YES);
}

@end
