//
//  DGCalc.h
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 16.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DGDayTile.h"


@class DGCalendar;


@protocol DGCalendarDelegate <NSObject>

@optional

- (void)      calendar:(DGCalendar*)calendar clickedOnTile         :(DGDayTile*)tile;
- (DGDayTile*)calendar:(DGCalendar*)calendar tileForDate           :(NSDateComponents*)date;

@end

@interface DGCalendar : UIView

@property(nonatomic, strong) NSDate *operatingNSDate;


@property(nonatomic, weak)   IBOutlet id<DGCalendarDelegate>        delegate;
@property(nonatomic, strong) IBOutlet UIButton                      *goPreviousMonth;
@property(nonatomic, strong) IBOutlet UIButton                      *goNextMonth;

@property(nonatomic, weak)   IBOutlet UILabel                       *currentDateLbl;

@property(nonatomic, strong) IBOutlet UIScrollView                  *daysCanvas;

@property(nonatomic, strong) IBOutlet UIView                        *monday;
@property(nonatomic, strong) IBOutlet UIView                        *tuesday;
@property(nonatomic, strong) IBOutlet UIView                        *wednesday;
@property(nonatomic, strong) IBOutlet UIView                        *thursday;
@property(nonatomic, strong) IBOutlet UIView                        *friday;
@property(nonatomic, strong) IBOutlet UIView                        *saturday;
@property(nonatomic, strong) IBOutlet UIView                        *sunday;

- (void)setCurrentDate:(NSDate*)date;
- (void)bringToCurrentMonth;
- (void)rebuildCalendarGrid;


@end
