//
//  HomeVC.m
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 02.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import "HomeVC.h"
#import "App.h"
#import "AccountManager.h"
#import "Goal.h"
#import <QuartzCore/QuartzCore.h>
#import "CalendarView.h"
#import <Twitter/Twitter.h>
#import "Result.h"
#import "AppDelegate.h"

#import "LocalyticsSession.h"

#define CALV_VIEW_HEIGHT 180.0

@interface HomeVC () {
    struct DateInfo dateInfo;
    NSArray *months;
    NSCalendar *gregorian;
}

@property (nonatomic, strong) AccountManager *accManager;
@property (nonatomic, strong) NSString *emptyGoalReplacement;
@property (nonatomic, weak) CalendarView *calView;

@end

@implementation HomeVC

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        self.emptyGoalReplacement = @"Tap here to enter your goal";
        
        NSDate *now = [NSDate date];
        gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        gregorian.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        comps.year = [gregorian ordinalityOfUnit:NSYearCalendarUnit inUnit:NSEraCalendarUnit forDate:now];
        comps.month = [gregorian ordinalityOfUnit:NSMonthCalendarUnit inUnit:NSYearCalendarUnit forDate:now];
        comps.day = 1;
        
        [self dateInfoForDate:[gregorian dateFromComponents:comps]];
        
        months = @[@"", @"January", @"February",
                   @"March", @"April", @"May",
                   @"June", @"July", @"August",
                   @"September", @"October", @"November",
                   @"December"];
        
        [[App sharedApp] synchronize];
    }
    return self;
}

- (UIImage*)imageForNumOfWins:(NSUInteger)numOfWins {
    numOfWins = MIN(numOfWins, 100);
    return [UIImage imageNamed:[NSString stringWithFormat:@"Belt_%d.png", numOfWins]];
}

- (void)viewWillAppear:(BOOL)animated {
    self.beltImage.image = [self imageForNumOfWins:[[App sharedApp].goals.lastObject points]];
    
    if ([[App sharedApp].goals.lastObject goalName] != nil) {
        self.goalNameLbl.text = [[App sharedApp].goals.lastObject goalName];
    } else {
        self.goalNameLbl.text = self.emptyGoalReplacement;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateUI];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    float calView_y = CGRectGetHeight(self.view.frame)- 35.0 - CALV_VIEW_HEIGHT;
    CalendarView *tempCalView = [[CalendarView alloc] initWithFrame:CGRectMake(0.0, calView_y, 320.0, 180.0)];
    self.calView = tempCalView;
    [self.view addSubview:self.calView];
    [self.view bringSubviewToFront:self.calView];
    
    [self updateUI];
    
    [self printDateInfo];
    
    if ([App sharedApp].isFirstLaunch) {
        // localytics
        [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Home: first launch screen opened"];
        [[LocalyticsSession sharedLocalyticsSession] tagScreen:@"Home, first launch"];
        
        [self performSegueWithIdentifier:@"SegueToGoalEdit" sender:self];
    } else {
        // localytics
        [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Home: screen opened"];
        [[LocalyticsSession sharedLocalyticsSession] tagScreen:@"Home"];
    }
}

- (void)updateMonthLabel
{
    self.monthLabel.text = [NSString stringWithFormat:@"%@ %d", months[dateInfo.month], dateInfo.year];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setTapToProgressRecognizer:nil];
    [self setBeltImage:nil];
    [self setGoalNameLbl:nil];
    [self setCalView:nil];
    [self setMonthLabel:nil];
    [super viewDidUnload];
}

- (void)dateInfoForDate:(NSDate *)aDate
{
    NSRange days = [gregorian rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:aDate];
    NSDateComponents *comps = [gregorian components:(NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekdayCalendarUnit) fromDate:aDate];
    
    comps.day = 1;
    
    dateInfo.year = comps.year;
    dateInfo.month = comps.month;
    dateInfo.daysInMonth = days.length;
    dateInfo.monthStart = comps.weekday;
}

- (void)printDateInfo
{
//    NSLog(@"year:  %d", dateInfo.year);
//    NSLog(@"month: %d", dateInfo.month);
//    NSLog(@"days:  %d", dateInfo.daysInMonth);
//    NSLog(@"start: %d", dateInfo.monthStart);
}

- (void)updateDateInfo
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps.year = dateInfo.year;
    comps.month = dateInfo.month;
    comps.day = 1;
    NSDate *date = [gregorian dateFromComponents:comps];
    [self dateInfoForDate:date];
}

// sets values for calendarView
// 1. number of days in the month       => daysInMonth
// 2. day that starts the month         => monthStart
// 3. days that should be highlighted   => highlightDays
// 4. highlight colors                  => highlightColors
- (void)updateUI
{
    CalendarView *calendarView = self.calView;
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        Result *res = (Result *)evaluatedObject;
        NSDateComponents *comps = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:res.date];
        return (dateInfo.year == comps.year && dateInfo.month == comps.month);
    }];
    
    NSArray *currentMonthResults = [[[App sharedApp].goals.lastObject progressHistory] filteredArrayUsingPredicate:predicate];
    
    calendarView.highlightDays = [[NSMutableArray alloc] initWithCapacity:currentMonthResults.count];
    calendarView.highlightColors = [[NSMutableArray alloc] initWithCapacity:currentMonthResults.count];
    calendarView.highlightPoints = [[NSMutableArray alloc] initWithCapacity:currentMonthResults.count];
    
    for (Result *res in currentMonthResults) {
        NSDateComponents *comps = [gregorian components:NSDayCalendarUnit fromDate:res.date];
        NSInteger day = comps.day;
        [calendarView.highlightDays addObject:@(day)];
        BOOL color = (res.result != Fail ? YES : NO);
        [calendarView.highlightColors addObject:@(color)];
        
        NSString *pointsStr = [NSString stringWithFormat:@"%@%d", (color ? @"+" : @""), res.points];
        [calendarView.highlightPoints addObject:pointsStr];
    }
    
    calendarView.monthStart = dateInfo.monthStart;
    calendarView.daysInMonth = dateInfo.daysInMonth;
    [calendarView setNeedsDisplay];
    [self updateMonthLabel];
}

- (IBAction)showPreviosMonth:(id)sender
{
    dateInfo.month -= 1;
    if (dateInfo.month == 0) {
        dateInfo.month = 12;
        dateInfo.year -= 1;
    }
    [self updateDateInfo];
    [self updateUI];
}

- (IBAction)showNextMonth:(id)sender
{
    dateInfo.month += 1;
    if (dateInfo.month == 13) {
        dateInfo.month = 1;
        dateInfo.year += 1;
    }
    [self updateDateInfo];
    [self updateUI];
}
@end
