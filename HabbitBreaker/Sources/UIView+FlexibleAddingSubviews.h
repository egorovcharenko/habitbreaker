//
//  UIView+FlexibleAddingSubviews.h
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 09.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    FloatingTopLeft,
    FloatingTopRight,
    FloatingBottomLeft,
    FloatingBottomRight
} Floating;


typedef struct {
    double percentX;
    double percentY;
} RelativePosition;

RelativePosition makePosition(double percentX, double percentY);


@interface UIView (FlexibleAddingSubviews)

- (void)addSubview:(UIView *)view forPosition:(RelativePosition)position andFloating:(Floating)floating;

@end
