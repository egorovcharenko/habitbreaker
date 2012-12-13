//
//  Habbit.m
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 05.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import "Goal.h"
#import "App.h"

@interface Goal ()
@property(nonatomic, strong)NSArray *levels;
@end

@implementation Goal

@synthesize goalName;

@synthesize lifeBenefits;
@synthesize healthBenefits;
@synthesize financeBenefits;
@synthesize otherBenefits = _otherBenefits;

@synthesize successCriteria;
@synthesize failCriteria;
@synthesize levels;

- (void)setOtherBenefits:(NSString*)benefits {
    if (benefits != nil) {
        _otherBenefits = benefits;
    }
}

- (id)init {
    self = [super init];
    
    if (self != nil) {        
        self.progressHistory = [NSMutableArray new];
        self.levels          = @[
        @0,
        @1,
        @2,
        @3,
        @4,
        @5,
        @7,
        @8,
        @9,
        @10,
        @13,
        @15,
        @17,
        @19,
        @23,
        @25,
        @30,
        @35,
        @40,
        @45,
        @50,
        @55,
        @60,
        @65,
        @70,
        @100,
        ];
        
        self.otherBenefits   = @"";
        self.financeBenefits = @"";
        self.healthBenefits  = @"";
        self.lifeBenefits    = @"";
        
        self.goalName        = @"";
        
        self.successCriteria    = @"";
        self.failCriteria       = @"";
    }
    
    return self;
}

- (void)start {
    if ([App sharedApp].isFirstLaunch) {
        [[App sharedApp] scheduleReminderWithGoal:self andAlert:@"Enter your progress"];
    }
}

- (void)invalidate {
    [[App sharedApp] cancelReminderWithGoal:self];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self != nil) {
        self.goalName           = [aDecoder decodeObjectForKey:@"goalName"];
        self.lifeBenefits       = [aDecoder decodeObjectForKey:@"lifeBenefits"];
        self.healthBenefits     = [aDecoder decodeObjectForKey:@"healthBenefits"];
        self.financeBenefits    = [aDecoder decodeObjectForKey:@"financeBenefits"];
        self.otherBenefits      = [aDecoder decodeObjectForKey:@"otherBenefits"];
        self.successCriteria    = [aDecoder decodeObjectForKey:@"successCriteria"];
        self.failCriteria       = [aDecoder decodeObjectForKey:@"failCriteria"];
        self.progressHistory    = [aDecoder decodeObjectForKey:@"progressHistory"];
        self.levels             = [aDecoder decodeObjectForKey:@"levels"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder*)aCoder {
    [aCoder encodeObject:self.goalName          forKey:@"goalName"];
    [aCoder encodeObject:self.lifeBenefits      forKey:@"lifeBenefits"];
    [aCoder encodeObject:self.healthBenefits    forKey:@"healthBenefits"];
    [aCoder encodeObject:self.financeBenefits   forKey:@"financeBenefits"];
    [aCoder encodeObject:self.otherBenefits     forKey:@"otherBenefits"];
    [aCoder encodeObject:self.successCriteria   forKey:@"successCriteria"];
    [aCoder encodeObject:self.failCriteria      forKey:@"failCriteria"];
    [aCoder encodeObject:self.progressHistory   forKey:@"progressHistory"];
    [aCoder encodeObject:self.levels            forKey:@"levels"];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"%@, %@, %@, %@, %@, %@, %@, %@, %@",
            super.description,
            self.goalName,
            self.lifeBenefits,
            self.healthBenefits,
            self.financeBenefits,
            self.otherBenefits,
            self.successCriteria,
            self.failCriteria,
            self.progressHistory];
}

- (NSInteger)pointsOfAllFails:(NSUInteger)fails {
    NSInteger retval = 0;
    for (NSUInteger i = 1; i <= fails; ++i) {
        retval -= i;
    }
    
    return retval;
}

- (NSInteger)successPoints {
    return [self.progressHistory filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        Result *result = (Result*)evaluatedObject;
        return result.result == Success || result.result == NewLevel;
    }]].count;
}

- (NSInteger)failPoints {
    NSInteger points = [self.progressHistory filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        Result *result = (Result*)evaluatedObject;
        return result.result == Fail;
    }]].count;
    
    return [self pointsOfAllFails:points];
}

- (NSInteger)points {
    NSInteger retval = 0;
    
    for (Result *result in self.progressHistory) {
        if (retval + result.points < 0) {
            retval = 0;
        } else {
            retval += result.points;
        }
    }
    
    return retval;
}

- (NSUInteger)currentSuccessPoints {
    return 1;
}

- (NSInteger)currentFailLevel {
    NSInteger fails = 0;
    
    for (Result *result in self.progressHistory) {
        if (result.result == Fail) {
            fails++;
        }
    }

    return -fails;
}

- (void)registerEvent:(Result*)result {
    Level previousLevel = self.currentLevel;
    result.date = [NSDate date];
    
    switch (result.result) {
        case Success:
            result.points = self.currentSuccessPoints;
            break;
        case Fail:
            result.points = self.currentFailLevel - 1;
            break;
        default:
            break;
    }
    
    [self.progressHistory addObject:result];
    
    Level currentLevel = self.currentLevel;
    if (currentLevel > previousLevel) {
        result.result = NewLevel;
    }
    
    [[App sharedApp] rescheduleReminder];
}

- (NSInteger)levelToPoints:(Level)level {
    if (level >= self.levels.count) {
        return -1;
    } else {
        return [[self.levels objectAtIndex:level] integerValue];
    }
}

- (Level)pointToLevel:(NSInteger)points {
    __block Level retval = -1;
    
    __block NSInteger previousLevel = -1;
    [self.levels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj integerValue] > points) {
            retval = previousLevel;
            *stop = YES;
        }
        previousLevel++;
    }];
    
    return retval;
}

- (Level)currentLevel {
    NSInteger retLevel = [self.levels indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        NSInteger retval = [obj integerValue] <= self.points && (
                    self.levels.count - 1 == idx ||
                    [[self.levels objectAtIndex:idx + 1] integerValue] > self.points);
        
        return retval;
    }];
    
    if ( ! (retLevel >= 0 && retLevel < self.levels.count)) {
        retLevel = self.levels.count - 1;
    }
    
    return retLevel;
}

@end
