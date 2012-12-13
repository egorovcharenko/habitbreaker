//
//  PrevNextVC.m
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 09.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import "PrevNextVC.h"
#import "CancellingPushSegue.h"

@interface PrevNextVC ()

- (IBAction)backClick:(id)sender;

@end

@implementation PrevNextVC

@synthesize isVisible = _isVisible;

- (BOOL)checkFilledData {
    [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"Method %@ is not implemented", NSStringFromSelector(_cmd)] userInfo:nil];
    return NO;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.isVisible = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
}

- (void)prepareForSegue:(CancellingPushSegue *)segue sender:(id)sender {
    if ( ! self.checkFilledData) {
        segue.cancelled = YES;
    }
    [segue.destinationViewController setGoal:self.goal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backClick:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end