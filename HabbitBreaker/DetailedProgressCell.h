//
//  DetailedProgressCell.h
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 25.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailedProgressCell : UITableViewCell

@property(nonatomic, weak)IBOutlet UILabel *date;
@property(nonatomic, weak)IBOutlet UILabel *result;
@property(nonatomic, weak)IBOutlet UILabel *comment;

@end
