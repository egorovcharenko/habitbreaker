//
//  InpirationVC.h
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 03.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"

@interface InspirationVC : BaseVC <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *pages;
@property (weak, nonatomic) IBOutlet UIScrollView  *scrollCanvas;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
- (IBAction)onPageControlChangeValue:(id)sender;

@end
