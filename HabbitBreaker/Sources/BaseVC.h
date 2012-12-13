//
//  BaseVC.h
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 09.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+FlexibleAddingSubviews.h"

@interface BaseVC : UIViewController

- (void)gotoViewControllerWithName:(NSString *)aViewControllerName;
- (UIViewController *)viewControllerFromStoryBoardID:(NSString *)aViewControllerStoryBoardID;

@end

@interface UITabBarController (SmartTabBarController)

- (void)updateViewControllersWithViewController:(UIViewController *)aViewController;

@end