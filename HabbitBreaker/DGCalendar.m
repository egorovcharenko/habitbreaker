//
//  DGCalc.m
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 16.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import "DGCalendar.h"
#import "DGDayTile.h"

#define GENERATED_CONCRETE_DAY_TILE 748

@interface DGCalendar ()

@property(nonatomic, unsafe_unretained)CGRect  baseFrame;
@property(nonatomic, strong) NSDateComponents  *showingMonthDate;
@property(nonatomic, getter = operatingDate) NSDateComponents  *operatingDate;

- (NSDateComponents*)componentsFromDate:(NSDate*)date;
- (NSDate*)dateFromComponents:(NSDateComponents*)components;

@end



@implementation DGCalendar



- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        int64_t delayInSeconds = 0.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            self.operatingNSDate = [NSDate date];
            
            self.baseFrame = self.daysCanvas.frame;
            
            [self.goNextMonth     addTarget:self action:@selector(onNextMonth:) forControlEvents:UIControlEventTouchUpInside];
            [self.goPreviousMonth addTarget:self action:@selector(onPrevMonth:) forControlEvents:UIControlEventTouchUpInside];
            
            self.showingMonthDate = self.operatingDate.copy;
                        
            [self rebuildCalendarGrid];
        });
        
    }
    
    return self;
}

- (NSDateComponents*)operatingDate {
    id calendar = [NSCalendar currentCalendar];
    NSDateComponents *date = [calendar components:NSYearCalendarUnit | NSWeekdayCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self.operatingNSDate];
    [date setLeapMonth:YES];
    
    return date;
}

- (void)recalcDate:(NSDateComponents**)date {
    *date = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSWeekdayCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[[NSCalendar currentCalendar] dateFromComponents:*date]];
}

- (void)onNextMonth:(id)sender {
    NSDateComponents *components = self.showingMonthDate;
    components.month++;
    components.day = 1;
    [self recalcDate:&components];
    self.showingMonthDate = components;
    [self rebuildCalendarGrid];
}

- (void)onPrevMonth:(id)sender {
    NSDateComponents *components = self.showingMonthDate;
    components.month--;
    components.day = 1;
    [self recalcDate:&components];
    self.showingMonthDate = components;
    [self rebuildCalendarGrid];
}

- (CGRect)frameForTileWithIndex:(NSUInteger)index {
    NSUInteger weakInMonth = 5;
    NSUInteger daysInWeak  = 7;
    
    CGRect retFrame;
    retFrame.size   = CGSizeMake(self.baseFrame.size.width / daysInWeak, self.baseFrame.size.height / weakInMonth);
    retFrame.origin = CGPointMake(index % daysInWeak * retFrame.size.width,
                                  index / daysInWeak * retFrame.size.height);
    
    return retFrame;
}

- (void)addDay:(DGDayTile*)day withIndex:(NSUInteger)index {
    day.frame = [self frameForTileWithIndex:index];
    [self.daysCanvas addSubview:day];
}

- (DGDayTile*)daytileWithDate:(NSDateComponents*)date {
    NSInteger tag       = [self.delegate calendar:self taggedTileTypeForDate:date];
    DGDayTile *template = [[self.tiles filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject tag] == tag;
    }]] lastObject];
    
    NSData *viewData    = [NSKeyedArchiver archivedDataWithRootObject:template];
    DGDayTile *day      = [NSKeyedUnarchiver unarchiveObjectWithData:viewData];
    
    day.day.text = [NSString stringWithFormat:@"%d", date.day];
    
    day.tag = GENERATED_CONCRETE_DAY_TILE;
    
    if ([self.delegate respondsToSelector:@selector(calendar:customizeTile:withDate:)]) {
        [self.delegate calendar:self customizeTile:day withDate:date];
    }
    
    return day;
}

- (void)incrementDayDate:(NSDateComponents**)date {
    ++(*date).day;
    [self recalcDate:date];
}

- (void)rebuildCalendarGrid {
    [self.daysCanvas.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSArray *oldDays = self.daysCanvas.subviews;
    
    NSDateComponents *date = self.showingMonthDate.copy;
    date.day     = 1;
    [self recalcDate:&date];
    
    NSDateComponents *dateToShow = date.copy;
    
    
    NSInteger calendarDay = 0;
    NSInteger numOfDaysInMonth  = [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self.showingMonthDate.date].length;
    
    for (int i = 2; i < date.weekday; ++i) {
        dateToShow.day--;
        [self recalcDate:&dateToShow];
    }
    while (calendarDay < (date.weekday - 2) % 7) { // Adding previous month's days
        DGDayTile *day      = [self daytileWithDate:dateToShow];
        
        [self addDay:day withIndex:calendarDay];
                
        dateToShow.day++;
        [self recalcDate:&dateToShow];
        ++calendarDay;
    }
    
    while (numOfDaysInMonth--) {               // Adding current month's days
        DGDayTile *day      = [self daytileWithDate:dateToShow];
        
        [self addDay:day withIndex:calendarDay];
        
        dateToShow.day++;
        [self recalcDate:&dateToShow];
        ++calendarDay;
    }
    
    while (calendarDay % 5 != 0) { // Adding next month's days
        DGDayTile *day      = [self daytileWithDate:dateToShow];
        
        [self addDay:day withIndex:calendarDay];
        
        dateToShow.day++;
        [self recalcDate:&dateToShow];
        ++calendarDay;
    }
    
    if (calendarDay <= 35) { // Shrinking calendar by vertical when there are only 5 rows
        if (self.daysCanvas.frame.size.height / 5 - [self frameForTileWithIndex:0].size.height > 0.1) {
            
            CGRect newCalendarFrame = self.frame;
            CGRect newCanvasFrame   = self.daysCanvas.frame;
            newCalendarFrame.size.height -= [self frameForTileWithIndex:0].size.height;
            newCanvasFrame.size.height   -= [self frameForTileWithIndex:0].size.height;
            
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                [self setFrame:newCalendarFrame];
                [self.daysCanvas setFrame:newCanvasFrame];
            } completion:nil];
        }
    }
    else {
        if ([self frameForTileWithIndex:0].size.height - self.daysCanvas.frame.size.height / 6 > 0.1) { // Extending calendar by vertical when there are more than 5 rows
            CGRect newCalendarFrame = self.frame;
            CGRect newCanvasFrame   = self.daysCanvas.frame;
            newCalendarFrame.size.height += [self frameForTileWithIndex:0].size.height;
            newCanvasFrame.size.height   += [self frameForTileWithIndex:0].size.height;
            
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                [self setFrame:newCalendarFrame];
                [self.daysCanvas setFrame:newCanvasFrame];
            } completion:nil];
        }
    }
    
    [oldDays makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSString *month = nil;
    switch (self.showingMonthDate.month) {
        case 1:
            month = @"January";
            break;
        case 2:
            month = @"February";
            break;
        case 3:
            month = @"March";
            break;
        case 4:
            month = @"April";
            break;
        case 5:
            month = @"May";
            break;
        case 6:
            month = @"June";
            break;
        case 7:
            month = @"July";
            break;
        case 8:
            month = @"August";
            break;
        case 9:
            month = @"September";
            break;
        case 10:
            month = @"October";
            break;
        case 11:
            month = @"November";
            break;
        case 12:
            month = @"December";
            break;
    }
    self.currentDateLbl.text = [NSString stringWithFormat:@"%@ %d", month, self.showingMonthDate.year];
}

- (void)setCurrentDate:(NSDate *)date {
    
}

- (void)bringToCurrentMonth {
    
}

@end
