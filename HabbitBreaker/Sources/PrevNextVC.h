//
//  PrevNextVC.h
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 09.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"

@class Goal;

@interface PrevNextVC : BaseVC

@property (weak,   nonatomic) IBOutlet UIBarButtonItem *barButtonNext;
@property (strong, nonatomic) Goal                     *goal;
@property(nonatomic, unsafe_unretained)BOOL            isVisible;

- (BOOL)checkFilledData;

@end
