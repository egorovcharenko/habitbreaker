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
#import "Purchases.h"

#import "LocalyticsSession.h"

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
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hi!" message:@"You should enter you progress now. Remember - you promised!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    });
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // should be called for add payment observer
    [Purchases sharedPurchases];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.facebook = [[Facebook alloc] initWithAppId:kFBApiSecret andDelegate:self];
    [self.facebook performSelector:NSSelectorFromString(@"retain")];
    self.app = [App sharedApp];
    
    UIStoryboard *storyboard = nil;
    storyboard = [UIStoryboard storyboardWithName:@"3.5" bundle:nil];
    
    
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
    
    // Override point for customization after application launch.
    [[LocalyticsSession sharedLocalyticsSession] startSession:@"0bb920f6d4de9cdc6a6bd4f-8dfde63a-5cb3-11e2-3b45-004b50a28849"];

//    NSLog(@"%@", ([self.app isOnPaidScreen] ? @"on paid" : @"any where"));
    return YES;
}

#pragma mark - FBConnect open from URL Scheme

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [self.facebook handleOpenURL:url];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[LocalyticsSession sharedLocalyticsSession] close];
    [[LocalyticsSession sharedLocalyticsSession] upload];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[LocalyticsSession sharedLocalyticsSession] resume];
    [[LocalyticsSession sharedLocalyticsSession] upload];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Close Localytics Session
    [[LocalyticsSession sharedLocalyticsSession] close];
    [[LocalyticsSession sharedLocalyticsSession] upload];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[LocalyticsSession sharedLocalyticsSession] close];
    [[LocalyticsSession sharedLocalyticsSession] upload];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[LocalyticsSession sharedLocalyticsSession] resume];
    [[LocalyticsSession sharedLocalyticsSession] upload];
}
@end
