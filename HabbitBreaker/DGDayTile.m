//
//  DGTile.m
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 16.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import "DGDayTile.h"

@implementation DGDayTile

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        self.day    = [aDecoder decodeObjectForKey:@"day"];
        self.score  = [aDecoder decodeObjectForKey:@"score"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:self.day   forKey:@"day"];
    [aCoder encodeObject:self.score forKey:@"score"];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
