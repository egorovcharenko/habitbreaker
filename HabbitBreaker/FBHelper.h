//
//  ViewController.h
//  FB_TUTORIAL
//
//  Created by Alexander on 10/26/12.
//  Copyright (c) 2012 Alexander. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"

@interface FBHelper : NSObject <FBSessionDelegate, FBRequestDelegate>

- (void)login;
- (void)logout;
- (void)postText:(NSString*)message;
+ (instancetype)sharedInstance;

@end
