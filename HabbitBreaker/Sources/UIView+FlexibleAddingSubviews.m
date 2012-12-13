//
//  UIView+FlexibleAddingSubviews.m
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 09.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import "UIView+FlexibleAddingSubviews.h"


RelativePosition makePosition(double percentsX, double percentsY) {
    RelativePosition relpos = {.percentX = percentsX, .percentY = percentsY};
    return relpos;
}


@implementation UIView (FlexibleAddingSubviews)

- (void)addSubview:(UIView *)view forPosition:(RelativePosition)position andFloating:(Floating)floating {
    CGSize  selfSize = self.frame.size;
    CGSize  viewSize = view.frame.size;
    CGPoint newViewOrigin;
        
    switch (floating) {
        case FloatingTopLeft:
            newViewOrigin = CGPointMake(selfSize.width * position.percentX / 100, selfSize.height * position.percentY / 100);
            break;
        case FloatingTopRight:
            break;
        case FloatingBottomLeft:
            break;
        case FloatingBottomRight:
            break;
    }
    
    CGRect newViewFrame;
    newViewFrame.origin = newViewOrigin;
    newViewFrame.size   = viewSize;
        
    [view setFrame:newViewFrame];
    
    [self addSubview:view];
}

@end
