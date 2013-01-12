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
#import "Purchases.h"

#import "LocalyticsSession.h"


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
    
    if (self.navigationController.viewControllers.count > 1) {
        UIButton *previousBtnView = [UIButton buttonWithType:UIButtonTypeCustom];
        [previousBtnView addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
        [previousBtnView setBackgroundImage:[UIImage imageNamed:@"GE_Back_Button.png"] forState:UIControlStateNormal];
        [previousBtnView setFrame:CGRectMake(0, 0, 70, 30)];
        
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:previousBtnView];
        [self.navigationItem setLeftBarButtonItem:backButton];
        
        self.navigationItem.hidesBackButton = YES;
    }
    
    self.confirmationFormat = self.confirmationLbl.text;
    
    self.confirmationLbl.text = [NSString stringWithFormat:self.confirmationFormat, [[App sharedApp] howMuchToPay]];

    // localytics
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                [NSString stringWithFormat:@"%d", [[App sharedApp] howMuchToPay]], @"Payment",
                                nil];
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Input progress: fail screen opened:" attributes:dictionary];
    [[LocalyticsSession sharedLocalyticsSession] tagScreen:@"Input progress: fail"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveResultAndLeave)
                                                 name:@"purchased"
                                               object:nil];
    
    [[App sharedApp] didEnterOnPaidScreen];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    
    [[App sharedApp] didLeaveOnPaidScreen];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onPay:(id)sender {
    // localytics
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Input progress: fail penalty payment process was started"];

    [[Purchases sharedPurchases] requestProductWithIndex:[[App sharedApp] howMuchToPay]];
//    [self saveResultAndLeave];
}

- (void)saveResultAndLeave {
    // localytics
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Input progress: fail penalty was successfuly paid"];

    // saving
    Result *result = [Result new];
    result.result = Fail;
    
    [[App sharedApp].goals.lastObject registerEvent:result];
    [[App sharedApp] synchronize];
    
    // leaving
    UIViewController *vc = [self viewControllerFromStoryBoardID:@"ShareFailVC"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidUnload {
    [self setConfirmationLbl:nil];
    [super viewDidUnload];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end