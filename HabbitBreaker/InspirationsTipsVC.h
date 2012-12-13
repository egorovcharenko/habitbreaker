//
//  InspirationsTipsVC.h
//  HabbitBreaker
//
//  Created by serg on 11/18/12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"

@interface InspirationsTipsVC : BaseVC

@property (weak, nonatomic) IBOutlet UIWebView *_webView;

- (IBAction)gotoExamples:(id)sender;
- (IBAction)gotoStories:(id)sender;

@end
