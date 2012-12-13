//
//  App.h
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 21.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    White,
    Yellow,
    OrangeGreen,
    OrangeWhite,
    OrangeRed,
    Orange,
    BlueGree,
    BlueWhite,
    BlueRed,
    Blue,
    PurpleGreen,
    PurpleWhite,
    PurpleRed,
    Purple,
    BrownWhite,
    Brown,
    Black1,
    Black2,
    Black3,
    Black4,
    Black5,
    Black6,
    Black7,
    Black8,
    Black9,
    Black10,
    End
} Level;


@class Goal;

@interface App : NSObject

@property (nonatomic, readonly)BOOL           isFirstLaunch;

- (NSArray*)goals;

- (void)addGoal:(Goal*)goal;

+ (instancetype)sharedApp;

- (BOOL)isFirstLaunch;
- (void)scheduleReminderWithGoal:(Goal*)goal andAlert:(NSString*)alert;
- (void)rescheduleReminder;
- (void)cancelReminderWithGoal:(Goal*)goal;
- (Level)currentLevel;
- (NSUInteger)numOfWins;

- (NSInteger)howMuchToPay;
- (void)synchronize;

- (BOOL)canEnterProgress;

- (void)didEnterOnPaidScreen;
- (void)didLeaveOnPaidScreen;
- (BOOL)isOnPaidScreen;

@end
