//
//  InputProgressSuccess.m
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 03.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import "InputProgressSuccessVC.h"
#import "App.h"
#import "Goal.h"

#import "LocalyticsSession.h"

@interface InputProgressSuccessVC ()

@end

@implementation InputProgressSuccessVC


- (UIImage*)beltImageForNumOfWins:(NSUInteger)numOfWins {
    numOfWins = MIN(numOfWins, 100);
    return [UIImage imageNamed:[NSString stringWithFormat:@"Belt_%d.png", numOfWins]];
}

- (UIImage*)nextBeltImageForNumOfWins:(NSUInteger)numOfWins {
    return [UIImage imageNamed:[NSString stringWithFormat:@"Belt_%d_next.png", numOfWins]];
}

- (void)viewWillAppear:(BOOL)animated {
    Goal *goal = [App sharedApp].goals.lastObject;
    
    self.beltImage.image     = [self beltImageForNumOfWins:goal.points];
    Level nextLevel = goal.currentLevel + 1;
    NSInteger pointsOfNextLvl = [goal levelToPoints:nextLevel];
    
    self.nextBeltImage.image = [self nextBeltImageForNumOfWins:pointsOfNextLvl];
    
    NSString *format = self.howMuchToNextLevelLbl.text;
    NSInteger toNext = [goal levelToPoints:nextLevel] - goal.points;
    if ( ! (toNext >= 0 && toNext <= 100)) {
        toNext = 0;
    }
    self.howMuchToNextLevelLbl.text = [NSString stringWithFormat:format, toNext];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Result *result = [Result new];
    result.result = Success;
    [[App sharedApp].goals.lastObject registerEvent:result];
    [[App sharedApp] synchronize];
    
    UIButton *nextBtnView     = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtnView addTarget:self.barButtonNext.target action:self.barButtonNext.action forControlEvents:UIControlEventTouchUpInside];
    [nextBtnView setBackgroundImage:[UIImage imageNamed:@"GE_Next_Button.png"] forState:UIControlStateNormal];
    [nextBtnView setFrame:CGRectMake(0, 0, 70, 30)];
    self.barButtonNext.customView = nextBtnView;
    
    if (self.navigationController.viewControllers.count > 1) {
        UIButton *previousBtnView = [UIButton buttonWithType:UIButtonTypeCustom];
        [previousBtnView addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
        [previousBtnView setBackgroundImage:[UIImage imageNamed:@"GE_Back_Button.png"] forState:UIControlStateNormal];
        [previousBtnView setFrame:CGRectMake(0, 0, 70, 30)];
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:previousBtnView];
        [self.navigationItem setLeftBarButtonItem:backButton];
        
        self.navigationItem.hidesBackButton = YES;
    }
    
    NSString *format = self.actualPoints.text;
    self.actualPoints.text = [NSString stringWithFormat:format, [[App sharedApp].goals.lastObject points]];

    // localytics
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Input progress: success screen opened"];
    [[LocalyticsSession sharedLocalyticsSession] tagScreen:@"Input progress: success"];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setBeltImage:nil];
    [self setNextBeltImage:nil];
    [self setHowMuchToNextLevelLbl:nil];
    [self setActualPoints:nil];
    [super viewDidUnload];
}

@end
