//
//  CancellingPushSegue.h
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 11.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CancellingPushSegue : UIStoryboardSegue

@property (unsafe_unretained, nonatomic) BOOL cancelled;

@end
