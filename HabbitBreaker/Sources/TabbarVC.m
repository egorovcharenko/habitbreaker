//
//  TabbarVC.m
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 02.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import "TabbarVC.h"

#import "HomeVC.h"
#import "InputProgressVC.h"
#import "HowItWorksVC.h"
#import "InspirationVC.h"
#import "App.h"
#import "Goal.h"
#import "BaseVC.h"

@interface TabbarVC () {
    UIView *blackView;
    UIActivityIndicatorView *activity;
}

@end

@implementation TabbarVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    if ([App sharedApp].isFirstLaunch) {
        [self setSelectedIndex:2]; // It is the "HowItWorksVC"
    }
    else
        if ([[App sharedApp] isOnPaidScreen]) {
            BaseVC *baseVc = [[BaseVC alloc] init];
            UIViewController *vc = [baseVc viewControllerFromStoryBoardID:@"InputProgressFailVC"];
            [self.navigationController pushViewController:vc animated:NO];
        }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showActivityIndicator)
                                                 name:@"paymentRequestSended"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(removeActivityIndicator)
                                                 name:@"paymentTransactionEnded"
                                               object:nil];
}

- (void)showActivityIndicator {
    if (!blackView) {
        blackView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        blackView.backgroundColor = [UIColor blackColor];
        blackView.alpha = 0.8;
        
        activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activity.center = blackView.center;
        [activity startAnimating];
        
        [blackView addSubview:activity];
    }
    UIWindow *wind = [[UIApplication sharedApplication].windows lastObject];
    [wind addSubview:blackView];
}

- (void)removeActivityIndicator {
    [activity removeFromSuperview], [blackView removeFromSuperview];
    activity = nil, blackView = nil;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {

    // do not show InputProgressVC while goal is not seted
    if ([viewController isKindOfClass:[InputProgressVC class]]) {
        Goal *goal = [[App sharedApp].goals lastObject];
        if (!goal.goalName.length) {
            [self showNoAccessToInputProgressAlert];
            return NO;
        }
        
        if (![App sharedApp].canEnterProgress) {
            [[[UIAlertView alloc] initWithTitle:@"Information"
                                        message:@"You have already entered progress today. It is not possible to enter it more than once per day. You can enter it tomorrow starting midnight."
                                       delegate:nil
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil] show];
            return NO;
        }
    }
    return YES;
}

- (void)showNoAccessToInputProgressAlert {
    [[[UIAlertView alloc] initWithTitle:@"Please choose your goal first"
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil] show];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
