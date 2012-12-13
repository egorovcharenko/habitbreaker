//
//  HomeVC.h
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 02.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
#import "DGCalendar.h"


@interface HomeVC : BaseVC <DGCalendarDelegate>

@property (weak, nonatomic)   IBOutlet DGCalendar *calendar;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapToProgressRecognizer;
@property (weak, nonatomic)   IBOutlet UIImageView *beltImage;
@property (weak, nonatomic)   IBOutlet UILabel *goalNameLbl;

@end
