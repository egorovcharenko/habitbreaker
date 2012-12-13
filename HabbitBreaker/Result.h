//
//  Result.h
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 25.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    Success,
    Fail,
    NewLevel
} ResultType;

@interface Result : NSObject <NSCoding>

@property(nonatomic, unsafe_unretained)ResultType result;
@property(nonatomic, unsafe_unretained)NSInteger  points;
@property(nonatomic, strong)           NSString   *comment;
@property(nonatomic, strong)           NSDate     *date;

@end
