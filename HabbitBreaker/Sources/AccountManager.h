//
//  LWAccountManager.h
//  LocaWIFI
//
//  Created by Dmitriy Gubanov on 03.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Facebook.h"


typedef enum {
    LWThereAreNoTwitterAccounts,
    LWUserDeniedAccessToTwitter,
    LWUserDeniedAccessToFacebook
}LWAccountError;

typedef enum {
    LWLoginViaTwitter,
    LWLoginViaFacebook,
    LWLoginViaEmail
}LWLoginWay;


typedef void(^LWSuccessHandler)();
typedef void(^LWFailHandler)(LWAccountError status);



@protocol LWAccountManagerDelegate <NSObject>
- (void)didLoginWithLoginWay:(LWLoginWay)loginWay;
@end



@interface AccountManager : NSObject <FBSessionDelegate, NSCoding>

@property(nonatomic, weak)              id<LWAccountManagerDelegate>    delegate;
@property(nonatomic, unsafe_unretained) BOOL                            isLoggedIn;

- (void)loginViaFacebookWithCompletionHandler:(LWSuccessHandler)handler failHandler:(LWFailHandler)failHandler;
- (void)loginViaTwitterWithCompletionHandler:(LWSuccessHandler)handler failHandler:(LWFailHandler)failHandler;

@end

