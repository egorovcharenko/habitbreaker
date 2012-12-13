//
//  CancellingPushSegue.m
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 11.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import "CancellingPushSegue.h"

@implementation CancellingPushSegue

- (void)perform {
    if (self.cancelled == NO) {
        [[self.sourceViewController navigationController] pushViewController:self.destinationViewController animated:YES];
    }
}

@end
