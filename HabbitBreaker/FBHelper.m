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
#import "Facebook.h"

@interface FBHelper ()
@property(nonatomic, strong)NSMutableDictionary *callbacks;
@end

@implementation FBHelper

+ (instancetype)sharedInstance {
    static FBHelper *_sharedInstance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [FBHelper new];
    });
    
    return _sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFacebookSuccess) name:kNotificationFbLoginSuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutFacebookSuccess) name:kNotificationFbLogoutSuccess object:nil];
        self.callbacks = [NSMutableDictionary new];
    }
    return self;
}

#pragma mark - Notification Methods

- (Facebook*)facebook {
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    return appDelegate.facebook;
}

- (void)loginFacebookSuccess {
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Login success!" delegate:self //cancelButtonTitle:@"OK" otherButtonTitles:nil];
    // [alert show];
}

- (void)logoutFacebookSuccess {
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Logout success!" delegate:self //cancelButtonTitle:@"OK" otherButtonTitles:nil];
    // [alert show];
}

#pragma mark - Main View Actions

- (void)login {    
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSArray *permissions = [NSArray arrayWithObjects:
                            @"read_stream",
                            @"publish_stream",
                            @"offline_access",
                            nil];
    
    [appDelegate.facebook authorize:permissions];
    NSLog(@"%@", appDelegate.facebook);
}

- (void)logout {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.facebook logout];
}

- (void)postText:(NSString*)message {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    Facebook *facebook = appDelegate.facebook;
    facebook.sessionDelegate = self;
    
    if ( ! facebook.isSessionValid) {
        [self.callbacks setObject:[(^(){
            [self postText:message];
        }) copy] forKey:@"fbDidLogin"];
        
        
        [self login];
    } else {
        NSMutableDictionary *params = @{@"message": message}.mutableCopy;
        
        [facebook requestWithGraphPath:@"/me/feed"
                             andParams:params
                         andHttpMethod:@"POST"
                           andDelegate:self];
    }
}

#pragma mark - FBRequest Methods


#pragma mark - FBConnect delegate

- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self.facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[self.facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationFbLoginSuccess object:nil];
    
    [[self.callbacks objectForKey:@"fbDidLogin"] invoke];
    [self.callbacks removeObjectForKey:@"fbDidLogin"];
    
    NSLog(@"login success!");
}

- (void)fbDidLogout {
    // Remove saved authorization information if it exists
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]) {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationFbLogoutSuccess object:nil];
    NSLog(@"logout success!");
}

- (void)fbDidNotLogin:(BOOL)cancelled {
    
}

- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt {
    
}

- (void)fbSessionInvalidated {
    
}


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
