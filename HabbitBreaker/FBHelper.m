//
//  ViewController.m
//  FB_TUTORIAL
//
//  Created by Alexander on 10/26/12.
//  Copyright (c) 2012 Alexander. All rights reserved.
//

#import "FBHelper.h"
#import "AppDelegate.h"
#import "Constants.h"

@interface FBHelper ()

@end

@implementation FBHelper

- (id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFacebookSuccess) name:kNotificationFbLoginSuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutFacebookSuccess) name:kNotificationFbLogoutSuccess object:nil];
    }
    return self;
}

#pragma mark - Notification Methods

- (void)loginFacebookSuccess {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Login success!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert show];
}

- (void)logoutFacebookSuccess {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Logout success!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert show];
}

#pragma mark - Main View Actions

- (void)login {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![appDelegate.facebook isSessionValid]) {
        NSArray *permissions = [NSArray arrayWithObjects:
                                @"read_stream",
                                @"publish_stream",
                                @"offline_access",
                                nil];
        [appDelegate.facebook authorize:permissions];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
                                                        message:@"You are already siggned!"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    }    
}

- (void)logout {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.facebook logout];
}

- (void)postText:(NSString*)message {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];    
    if (![appDelegate.facebook isSessionValid]){
        UIAlertView  *alertView = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                             message:@"Please login to Facebook!"
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        [alertView show];
    } else {
        NSMutableDictionary *params = [NSMutableDictionary  dictionaryWithObjectsAndKeys:
                                       [NSString stringWithFormat:  @"My message from iOS!"],
                                                                    message,
                                                                    nil];
        [appDelegate.facebook requestWithGraphPath:@"/me/feed"
                                         andParams:params
                                     andHttpMethod:@"POST"
                                       andDelegate:self];
    }
}

#pragma mark - FBRequest Methods

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"%@", [error localizedDescription]);
    NSLog(@"Err details: %@", [error description]);
}

- (void) request: (FBRequest *)request didReceiveResponse: (NSURLResponse *)response {
    NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
    if (statusCode == 200) {
        NSString *url = [[response URL] absoluteString];
        if ([url rangeOfString: @"me/feed"].location != NSNotFound) {
            NSLog(@"Request Params: %@", [request params]);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Facebook" message: @"Message successfully posted on Facebook." delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
            [alert show];
        }
    }
    else if (statusCode == 400) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Facebook" message: @"Duplicate message" delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil];
        [alert show];
    }
}

@end
