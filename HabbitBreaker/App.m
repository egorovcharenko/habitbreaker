//
//  App.m
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 21.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import "App.h"
#import "Result.h"
#import "Goal.h"

#import "EnumeratingStorage.h"

static NSString *kGoals = @"goals";
static NSString *kIsOnPaidScreen = @"isOnPaidScreen";

@interface App ()
@property(nonatomic, unsafe_unretained)BOOL     isFirstLaunch;
@property(nonatomic, strong)NSMutableArray      *goals;
@property(nonatomic, strong)EnumeratingStorage  *permanentStorage;
@property(nonatomic, strong)NSString            *alertMessage;
@end



@implementation App


- (NSUInteger)numOfWins {
    return [[self.goals.lastObject progressHistory] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        Result *result = (Result*)evaluatedObject;
        return result.result == Success;
    }]].count;
}

- (Level)currentLevel {
    return [self.goals.lastObject currentLevel];
}

- (NSArray*)goals {
    if (_goals == nil) {
        _goals = [[self.permanentStorage objectForKey:kGoals] mutableCopy];
    }
    
    return _goals;
}

@synthesize goals = _goals;

- (void)addGoal:(Goal*)goal {
    if (self.goals == nil) {
        _goals = [NSMutableArray new];
    }
    
    [_goals removeAllObjects]; // Currently there is only one habit in app
    [_goals addObject:goal];
    
    [self.permanentStorage setObject:self.goals forKey:kGoals];
    [self.permanentStorage synchronize];
}

+ (instancetype)sharedApp {
    static App *app  = nil;
    
    if (app == nil) {
        app = [[App alloc] init];
    }
    
    return app;
}

- (id)init {
    self = [super init];
    if (self != nil) {        
        self.permanentStorage = [EnumeratingStorage new];
        
        static NSString *notFirstLaunchKey = @"isNotFirstLaunch";
        
        NSNumber *isNotFirstLaunch = [self.permanentStorage objectForKey:notFirstLaunchKey];
        if (isNotFirstLaunch.boolValue) {
            self.isFirstLaunch = NO;
        } else {
            isNotFirstLaunch = [NSNumber numberWithBool:YES];
            [self.permanentStorage setObject:isNotFirstLaunch forKey:notFirstLaunchKey];
            
            self.isFirstLaunch = YES;
        }
        
        [self.permanentStorage synchronize];
        
        self.goals = [[self.permanentStorage objectForKey:kGoals] mutableCopy];
        
        if (self.goals == nil) {
            self.goals = [NSMutableArray new];
        }
    }
    
    return self;
}

- (void)synchronize {
    [self.permanentStorage setObject:self.goals forKey:kGoals];
    [self.permanentStorage synchronize];
}

- (void)scheduleReminderWithGoal:(Goal *)goal andFireDate:(NSDate*)fireDate {
    UILocalNotification* alarm = [self.permanentStorage objectForKey:[NSString stringWithFormat:@"%@", goal]];
    if (alarm == nil) {
        alarm = [UILocalNotification new];
        
        alarm.fireDate = fireDate;
        alarm.timeZone = [NSTimeZone defaultTimeZone];
        alarm.repeatInterval = NSDayCalendarUnit;
        
        alarm.alertBody = self.alertMessage;
        UIApplication *app = [UIApplication sharedApplication];
        [app scheduleLocalNotification:alarm];
        
        [self.permanentStorage setObject:alarm forKey:[NSString stringWithFormat:@"%@", goal]];
    }
}

- (void)scheduleReminderWithGoal:(Goal*)goal andAlert:(NSString*)alert {
    self.alertMessage = alert;
    
    NSDate           *currentDate = [NSDate date];
    NSDateComponents *components  = [[NSCalendar currentCalendar] components:~NSTimeZoneCalendarUnit fromDate:currentDate];
    
    components.hour     = 21;
    components.minute   = 0;
    components.second   = 0;
    
    NSDate *scheduledDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    [self scheduleReminderWithGoal:goal andFireDate:scheduledDate];
}

- (void)cancelReminderWithGoal:(Goal*)goal {
    NSString *key = [NSString stringWithFormat:@"%@", goal];
    UILocalNotification *note = [self.permanentStorage objectForKey:key];
    if (note != nil ) {
        [[UIApplication sharedApplication] cancelLocalNotification:note];
    }
}

- (void)rescheduleReminder {
    NSDate           *currentDate = [NSDate date];
    NSDateComponents *components  = [[NSCalendar currentCalendar] components:~NSTimeZoneCalendarUnit fromDate:currentDate];
    
   // [components setLeapMonth:YES];
    components.hour     = 21;
    components.minute   = 0;
    components.second   = 0;
    components.day++;
    
    NSDate *scheduledDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    [self cancelReminderWithGoal:self.goals.lastObject];
    [self scheduleReminderWithGoal:self.goals.lastObject andFireDate:scheduledDate];
}

- (NSInteger)howMuchToPay {
    return MIN(-[self.goals.lastObject currentFailLevel] + 1, 20); // 20 is maximum price
}

- (BOOL)canEnterProgress {
    Result *result = [self.goals.lastObject progressHistory].lastObject;
    
    if (result == nil) {
        return YES;
    }
    
    NSDateComponents *currentDate = [[NSCalendar currentCalendar]components:~NSTimeZoneCalendarUnit fromDate:[NSDate date]];
    NSDateComponents *resultsDate = [[NSCalendar currentCalendar]components:~NSTimeZoneCalendarUnit fromDate:[result date]];
    
    return ! (
        currentDate.day   == resultsDate.day &&
        currentDate.month == resultsDate.month &&
        currentDate.year  == currentDate.year);
}

- (void)didEnterOnPaidScreen {
    [self.permanentStorage setObject:@YES forKey:kIsOnPaidScreen];
    [self.permanentStorage synchronize];
}

- (void)didLeaveOnPaidScreen {
    [self.permanentStorage setObject:@NO forKey:kIsOnPaidScreen];
    [self.permanentStorage synchronize];
}

- (BOOL)isOnPaidScreen {
    NSNumber *isOnPaid = [self.permanentStorage objectForKey:kIsOnPaidScreen];
    return isOnPaid.boolValue;
}

@end
