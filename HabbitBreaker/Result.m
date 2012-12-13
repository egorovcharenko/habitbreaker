//
//  Result.m
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 25.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import "Result.h"

@implementation Result

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.comment   forKey:@"comment"];
    [aCoder encodeObject:self.date      forKey:@"date"];
    [aCoder encodeInteger:self.points   forKey:@"points"];
    [aCoder encodeBytes:(uint8_t*)&_result length:sizeof(self.result) forKey:@"result"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self != nil) {
        self.points  = [aDecoder decodeIntegerForKey:@"points"];
        self.comment = [aDecoder decodeObjectForKey:@"comment"];
        self.date    = [aDecoder decodeObjectForKey:@"date"];
        self.result  = *((ResultType*)[aDecoder decodeBytesForKey:@"result" returnedLength:nil]);
    }
    
    return self;
}

@end
