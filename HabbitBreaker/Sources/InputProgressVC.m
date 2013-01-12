//
//  InputProgressSuccess.m
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 03.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import "InputProgressVC.h"
#import "App.h"
#import "Goal.h"
#import "CancellingPushSegue.h"
#import "InputProgressFailVC.h"
#import "InputProgressSuccessVC.h"

#import "LocalyticsSession.h"

@interface InputProgressVC () {
    UIViewController *forwardViewController; // bad code (sorry)
}

@end

@implementation InputProgressVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    self.gaveInLbl.text   = [[App sharedApp].goals.lastObject failCriteria];
    self.resistedLbl.text = [[App sharedApp].goals.lastObject successCriteria];
    
    // localytics
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Input progress: screen opened"];
    [[LocalyticsSession sharedLocalyticsSession] tagScreen:@"Input progress"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {

    [self setGaveInLbl:nil];
    [self setResistedLbl:nil];
    [super viewDidUnload];
}

- (IBAction)gotoFailVC:(id)sender {
    [self showAlertWithButtonText:@"I gave in today"];
    forwardViewController = [self viewControllerFromStoryBoardID:@"InputProgressFailVC"];
}

- (IBAction)gotoSuccessVC:(id)sender {
    [self showAlertWithButtonText:@"I resisted"];
    forwardViewController = [self viewControllerFromStoryBoardID:@"InputProgressSuccessVC"];
}

- (void)showAlertWithButtonText:(NSString *)aText {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm"
                                                    message:@"Are you sure?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel" otherButtonTitles:aText, nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.navigationController pushViewController:forwardViewController animated:YES];
    }
    forwardViewController = nil;
}

@end