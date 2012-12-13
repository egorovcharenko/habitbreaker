//
//  AppDelegate.m
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 02.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import "AppDelegate.h"
#import "InputProgressVC.h"
#import "App.h"
#import "Facebook.h"

typedef enum {
    ResolutionIPhone35  = 480,
    ResolutionIPhone4   = 568,
    ResolutionIPad      = 1024
} DeviceResolution;

@implementation AppDelegate

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        UINavigationController *rootNavigationVC = (UINavigationController*)self.window.rootViewController;
        [rootNavigationVC popToRootViewControllerAnimated:NO];
        UITabBarController     *rootVC = rootNavigationVC.viewControllers.lastObject;
        [rootVC setSelectedIndex:1];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hi!" message:@"You should enter your progress" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    });
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.app = [App sharedApp];
    
    UIStoryboard *storyboard = nil;
//    switch ((NSInteger)UIScreen.mainScreen.bounds.size.height) {
//        case ResolutionIPhone35:
            storyboard = [UIStoryboard storyboardWithName:@"3.5" bundle:nil];
//            break;
//        case ResolutionIPhone4:
//            storyboard = [UIStoryboard storyboardWithName:@"4.0" bundle:nil];
//            break;
//        case ResolutionIPad:
//            [NSException exceptionWithName:@"There are no that storyboard" reason:@"iPad does not support" userInfo:nil];
//            break;
//    }
    
    
    [self.window setRootViewController:[storyboard instantiateInitialViewController]];
    [self.window makeKeyAndVisible];
    
    
    
    // Facebook configuration.
    self.facebook = [[Facebook alloc] initWithAppId:kFBAppID andDelegate:self];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        self.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        self.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    
    return YES;
}


#pragma mark - FBConnect open from URL Scheme

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [self.facebook handleOpenURL:url];
}

#pragma mark - FBConnect delegate

- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self.facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[self.facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationFbLoginSuccess object:nil];
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

@end
