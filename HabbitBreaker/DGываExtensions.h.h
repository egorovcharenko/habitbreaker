//
//  NSDate+DGExtensions.h
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 17.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DGExtensions)

- (NSUInteger)second;
- (NSUInteger)minute;
- (NSUInteger)hour;
- (NSUInteger)day;
- (NSUInteger)month;
- (NSUInteger)year;
- (NSUInteger)weakday;

@end
