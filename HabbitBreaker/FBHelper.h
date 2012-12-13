//
//  ViewController.h
//  FB_TUTORIAL
//
//  Created by Alexander on 10/26/12.
//  Copyright (c) 2012 Alexander. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBRequest.h"

@interface FBHelper : NSObject <FBRequestDelegate>

- (void)login;
- (void)logout;
- (void)postText:(NSString*)message;

@end
