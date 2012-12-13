//
//  DetailedProgressVC.m
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 03.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import "DetailedProgressVC.h"
#import "DetailedProgressCell.h"
#import "App.h"
#import "Goal.h"
//#import "Result.h"

@interface DetailedProgressVC ()

@end

@implementation DetailedProgressVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *previousBtnView = [UIButton buttonWithType:UIButtonTypeCustom];
    [previousBtnView addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [previousBtnView setBackgroundImage:[UIImage imageNamed:@"GE_Back_Button.png"] forState:UIControlStateNormal];
    [previousBtnView setFrame:CGRectMake(0, 0, 70, 30)];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:previousBtnView];
    [self.navigationItem setLeftBarButtonItem:backButton];
    
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[App sharedApp].goals.lastObject progressHistory].count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailedProgressCell *cell = nil;
    Result *result = [[[App sharedApp].goals.lastObject progressHistory] objectAtIndex:indexPath.row];
    switch (result.result) {
        case Fail:
            cell = [tableView dequeueReusableCellWithIdentifier:@"Fail"];
            cell.result.text  = [NSString stringWithFormat:@"-%d", -result.points];
            break;
        case Success:
            cell = [tableView dequeueReusableCellWithIdentifier:@"Success"];
            cell.result.text  = [NSString stringWithFormat:@"+%d", result.points];
            break;
        case NewLevel:
            cell = [tableView dequeueReusableCellWithIdentifier:@"NewLevel"];
            cell.result.text  = [NSString stringWithFormat:@"+%d", result.points];
            break;
    }
    
    cell.comment.text = result.comment;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"ddMMyy" options:0 locale:[[NSLocale alloc] initWithLocaleIdentifier:@"EN"]]];
    cell.date.text    = [formatter stringFromDate:result.date];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [self tableView:tableView cellForRowAtIndexPath:indexPath].frame.size.height;
    return height;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
