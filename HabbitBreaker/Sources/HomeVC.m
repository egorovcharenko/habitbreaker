//
//  HomeVC.m
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 02.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import "HomeVC.h"
#import "DGCalendar.h"
#import "App.h"
#import "AccountManager.h"
#import "Goal.h"
#import <QuartzCore/QuartzCore.h>

#import <Twitter/Twitter.h>
#import "FBHelper.h"

@interface HomeVC ()
@property(nonatomic, strong)AccountManager *accManager;
@property(nonatomic, strong)NSString       *emptyGoalReplacement;
@end

@implementation HomeVC

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.emptyGoalReplacement = @"Tap here to enter your goal";
    }
    return self;
}

- (UIImage*)imageForNumOfWins:(NSUInteger)numOfWins {
    return [UIImage imageNamed:[NSString stringWithFormat:@"Belt_%d.png", numOfWins]];
}

- (void)viewWillAppear:(BOOL)animated {
    self.beltImage.image = [self imageForNumOfWins:[[App sharedApp].goals.lastObject points]];
        
    [self.calendar rebuildCalendarGrid];
    
    if ([[App sharedApp].goals.lastObject goalName] != nil) {
        self.goalNameLbl.text = [[App sharedApp].goals.lastObject goalName];
    } else {
        self.goalNameLbl.text = self.emptyGoalReplacement;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([App sharedApp].isFirstLaunch) {
        [self performSegueWithIdentifier:@"SegueToGoalEdit" sender:self];
    }
    
    FBHelper *helper = [FBHelper new];
    [helper login];
    [helper postText:@"Heeheh"];
    
   /* if ([TWTweetComposeViewController canSendTweet]) {
        TWTweetComposeViewController *tweetVC = [TWTweetComposeViewController new];
        [tweetVC setInitialText:@""];
        
        [self presentViewController:tweetVC animated:YES completion:nil];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Unable to Tweet" message:@"Please ensure you have at least one Twitter account setup and have internet connectivity" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }
    */
    /*self.accManager = [[AccountManager alloc] init];
    [self.accManager loginViaFacebookWithCompletionHandler:^{
        NSLog(@"Hi");
    } failHandler:^(LWAccountError status) {
        NSLog(@"Hi");
    }];
    */
    self.calendar.currentDate = [NSDate date];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setCalendar:nil];
    [self setTapToProgressRecognizer:nil];
    [self setBeltImage:nil];
    [self setGoalNameLbl:nil];
    [super viewDidUnload];
}

#pragma mark DGCalendarDelegate

- (NSInteger)calendar:(DGCalendar*)calendar taggedTileTypeForDate :(NSDateComponents*)date {
    Result *thisDateResult = nil;
    
    for (Result *res in [[App sharedApp].goals.lastObject progressHistory]) {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:res.date];
        if (components.day   == date.day &&
            components.month == date.month &&
            components.year  == components.year) {
            
            thisDateResult = res;
            break;
        }
    }
    
    NSInteger retval;
    if (thisDateResult != nil) {
        switch (thisDateResult.result) {
            case Success:
                retval = 1;
                break;
            case NewLevel:
                retval = 1;
                break;
            case Fail:
                retval = 3;
                break;
            default:
                retval = 2;
        }
    } else {
        retval = 2;
    }
    
    return retval;
}

- (void)calendar:(DGCalendar *)calendar customizeTile:(DGDayTile*)dayTile withDate:(NSDateComponents *)date {
    Result *thisDateResult = nil;
    
    for (Result *res in [[App sharedApp].goals.lastObject progressHistory]) {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:res.date];
        if (components.day   == date.day &&
            components.month == date.month &&
            components.year  == components.year) {
            
            thisDateResult = res;
            break;
        }
    }
    
    if (thisDateResult != nil) {
        switch (thisDateResult.result) {
            case Success:
                dayTile.score.text = [NSString stringWithFormat:@"+%d", thisDateResult.points];
                break;
            case NewLevel:
                dayTile.score.text = [NSString stringWithFormat:@"+%d", thisDateResult.points];
                break;
            case Fail:
                dayTile.score.text = [NSString stringWithFormat:@"%d", thisDateResult.points];
                break;
        }
    }
}

#pragma mark -

@end
