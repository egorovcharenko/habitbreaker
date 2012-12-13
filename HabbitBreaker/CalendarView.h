//
//  CalendarView.h
//  HabbitBreaker
//
//  Created by serg on 11/29/12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarView : UIView

@property (nonatomic, assign) NSInteger monthStart; // number of the which is first in the month
@property (nonatomic, assign) NSInteger daysInMonth;

@property (nonatomic, strong) NSMutableArray *highlightDays;
@property (nonatomic, strong) NSMutableArray *highlightColors; // YES = green, NO = red
@property (nonatomic, strong) NSMutableArray *highlightPoints;

- (void)setMonthStart:(NSInteger)newValue;

@end
