//
//  AppDelegate.h
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 02.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@class App;

@interface AppDelegate : UIResponder <UIApplicationDelegate, FBSessionDelegate>

@property (strong, nonatomic) UIWindow  *window;
@property (strong, nonatomic) App       *app;
@property (strong, nonatomic) Facebook  *facebook;

@end
//com.kendalinvestmentslimited.habitbreaker