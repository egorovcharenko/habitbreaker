//
//  HomeVC.h
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 02.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
#import "FBConnect.h"

struct DateInfo {
    NSInteger year;
    NSInteger month;
    NSInteger daysInMonth;
    NSInteger monthStart;
};

@interface HomeVC : BaseVC <FBDialogDelegate>

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapToProgressRecognizer;
@property (weak, nonatomic) IBOutlet UIImageView *beltImage;
@property (weak, nonatomic) IBOutlet UILabel *goalNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
- (IBAction)showPreviosMonth:(id)sender;
- (IBAction)showNextMonth:(id)sender;

@end
