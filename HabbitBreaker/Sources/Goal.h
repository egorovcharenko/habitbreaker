//
//  Habbit.h
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 05.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Result.h"
#import "App.h"


@interface Goal : NSObject <NSCoding>

@property(nonatomic, strong)NSString        *goalName;
@property(nonatomic, strong)NSString        *lifeBenefits;
@property(nonatomic, strong)NSString        *healthBenefits;
@property(nonatomic, strong)NSString        *financeBenefits;
@property(nonatomic, strong)NSString        *otherBenefits;
@property(nonatomic, strong)NSString        *successCriteria;
@property(nonatomic, strong)NSString        *failCriteria;
@property(nonatomic, strong)NSMutableArray  *progressHistory;

- (Level)currentLevel;
- (NSInteger)levelToPoints:(Level)level;
- (void)registerEvent:(Result*)result;
- (NSInteger)points;
- (NSInteger)currentFailLevel;
- (NSInteger)successPoints;
- (void)start;
- (void)invalidate;

@end
