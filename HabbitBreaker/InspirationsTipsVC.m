//
//  InspirationsTipsVC.m
//  HabbitBreaker
//
//  Created by serg on 11/18/12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import "InspirationsTipsVC.h"

#import "LocalyticsSession.h"

@implementation InspirationsTipsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:@"http://habitbreaker.humantouch.ru/tips.html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self._webView loadRequest:request];
    
    // localytics
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"Inspiration: tips screen opened"];
    [[LocalyticsSession sharedLocalyticsSession] tagScreen:@"Inspiration: tips"];
}

- (void)viewDidUnload {
    [self set_webView:nil];
    [super viewDidUnload];
}

- (IBAction)gotoExamples:(id)sender {
    [self gotoViewControllerWithName:@"InspirationVC"];
}

- (IBAction)gotoStories:(id)sender {
    [self gotoViewControllerWithName:@"InspirationsStorieVC"];
}

@end
