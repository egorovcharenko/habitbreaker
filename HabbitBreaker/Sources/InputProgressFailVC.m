//
//  InputProgressFail.m
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 03.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import "InputProgressFailVC.h"
#import "App.h"
#import "Goal.h"
#import "Result.h"

@interface InputProgressFailVC ()
@property(nonatomic, strong)NSString *confirmationFormat;
@end

@implementation InputProgressFailVC

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.confirmationFormat = self.confirmationLbl.text;
    
    self.confirmationLbl.text = [NSString stringWithFormat:self.confirmationFormat, [[App sharedApp] howMuchToPay]];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onPay:(id)sender {
    Result *result = [Result new];
    result.result = Fail;
    
    [[App sharedApp].goals.lastObject registerEvent:result];
    [[App sharedApp] synchronize];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setConfirmationLbl:nil];
    [super viewDidUnload];
}
@end
