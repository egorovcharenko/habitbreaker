//
//  InspirationsStorieVC.m
//  HabbitBreaker
//
//  Created by serg on 11/18/12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import "InspirationsStorieVC.h"

#import "LocalyticsSession.h"

@implementation InspirationsStorieVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:@"http://habitbreaker.humantouch.ru/successstories.html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self._webView loadRequest:request];
    
    // localytics
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Inspiration: stories screen opened"];
    [[LocalyticsSession sharedLocalyticsSession] tagScreen:@"Inspiration: stories"];
}

- (void)viewDidUnload {
    [self set_webView:nil];
    [super viewDidUnload];
}

- (IBAction)gotoExamples:(id)sender {
    [self gotoViewControllerWithName:@"InspirationVC"];
}

- (IBAction)gotoTips:(id)sender {
    [self gotoViewControllerWithName:@"InspirationsTipsVC"];
}

@end
