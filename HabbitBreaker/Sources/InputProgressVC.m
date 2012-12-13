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

@interface InputProgressVC ()

@end

@implementation InputProgressVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    self.gaveInLbl.text   = [[App sharedApp].goals.lastObject failCriteria];
    self.resistedLbl.text = [[App sharedApp].goals.lastObject successCriteria];
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

@end