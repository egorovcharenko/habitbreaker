//
//  HowItWorksVC.h
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 03.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"

@interface HowItWorksVC : BaseVC <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView  *scrollCanvas;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *pages;
- (IBAction)onPageControlChangeValue:(id)sender;

@end
