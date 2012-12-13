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

@interface TabbarVC ()

@end

@implementation TabbarVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([App sharedApp].isFirstLaunch) {
        [self setSelectedIndex:2]; // It is the "HowItWorksVC"
    }
}
@end
