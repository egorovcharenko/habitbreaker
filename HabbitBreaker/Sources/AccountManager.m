//
//  LWAccountManager.m
//  LocaWIFI
//
//  Created by Dmitriy Gubanov on 03.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AccountManager.h"
#import <Accounts/ACAccount.h>
#import <Accounts/ACAccountStore.h>
#import <Accounts/ACAccountType.h>
#import <Twitter/Twitter.h>
#import "AppDelegate.h"

@interface AccountManager()
#pragma mark Private properties
@property(nonatomic, copy) LWFailHandler      twitterFailHandler;
@property(nonatomic, copy) LWSuccessHandler   twitterSuccessHandler;
@property(nonatomic, copy) LWFailHandler      facebookFailHandler;
@property(nonatomic, copy) LWSuccessHandler   facebookSuccessHandler;
@property(nonatomic, strong) Facebook         *facebook;
#pragma mark Private methods
- (void)save;
@end



@implementation AccountManager

#pragma mark Synthesize

@synthesize delegate                = _delegate;
@synthesize facebook                = _facebook;
@synthesize twitterFailHandler      = _twitterFailHandler;
@synthesize twitterSuccessHandler   = _twitterSuccessHandler;
@synthesize facebookFailHandler     = _facebookFailHandler;
@synthesize facebookSuccessHandler  = _facebookSuccessHandler;
@synthesize isLoggedIn              = _isLoggedIn;

#pragma mark NSCoding

/*- (id)initWithCoder:(NSCoder *)aDecoder {
    self.user = [aDecoder decodeObjectForKey:@"user"];
    _isLoggedIn  = [aDecoder decodeBoolForKey:@"isLoggedIn"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.user forKey:@"user"];
    [aCoder encodeBool:self.isLoggedIn forKey:@"isLoggedIn"];
}*/

#pragma mark Initialization

- (id)init {
   // NSData *myselfData = [[NSUserDefaults standardUserDefaults] valueForKey:NSStringFromClass([self class])];
    AccountManager *storedManager = nil;//[NSKeyedUnarchiver unarchiveObjectWithData:myselfData];
    
    if(storedManager != nil) {
        self = storedManager;
    }
    else {
        self = [super init];
    }
    if(self) {
        __unsafe_unretained AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        appDelegate.facebook.sessionDelegate   = self;
        self.facebook = appDelegate.facebook;
    }
    
    return self;
}

#pragma mark FBSessionDelegate
- (void)fbDidLogin {
    if(self.facebookSuccessHandler != nil) {        
        //self.facebookSuccessHandler(self.user);
    }
    
    self.isLoggedIn = YES;
    
    [self.delegate didLoginWithLoginWay:LWLoginViaFacebook];
}

- (void)didReceiveObject:(NSObject*)object {
    
}


- (void)fbDidNotLogin:(BOOL)cancelled {
    NSLog(@"%d", cancelled);
    if(self.facebookFailHandler != nil) {
        self.facebookFailHandler(LWUserDeniedAccessToFacebook);
    }
}

- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt {
    
}

- (void)fbDidLogout {
    self.isLoggedIn = NO;
}

- (void)fbSessionInvalidated {
    
}


#pragma mark Login

- (void)loginWithLogin:(NSString*)login password:(NSString*)password completitionHandler:(LWSuccessHandler)handler {
    
}

- (void)loginViaFacebookWithCompletionHandler:(LWSuccessHandler)successHandler failHandler:(LWFailHandler)failHandler {
    self.facebookSuccessHandler = successHandler;
    self.facebookFailHandler    = failHandler;
    
    NSArray *defaultPermissions = [[NSArray alloc] initWithObjects:nil];
    [self.facebook authorize:defaultPermissions];
}

- (NSString*)firstStep {
    /*NSString *urlString = [NSString stringWithFormat:@"OAuth oauth_nonce="xq2maKtilFhVTC1MSxVC4cQIJLd53O6w97YmrdOGSk8",
                           
                           oauth_signature_method="HMAC-SHA1",
                           
                           oauth_timestamp="1322697052",
                           
                           oauth_consumer_key="JP3PyvG67rXRsnayOJOcQ",
                           
                           oauth_token="5mgkU82W0PTA0DLgSIA5vFK6c08i8dXzrbLnX06vl38", 
                           
                           oauth_signature="aOM%2FwW2kAowAeHBRvw7faH245p0%3D", 
                           
                           oauth_version="1.0"];
    NSURL *url = [NSURL URLWithString:@""];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:requestOperation];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *response = [[NSString alloc] initWithData:responseObject encoding:NSStringEncodingConversionAllowLossy];
        [self secondStep:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [requestOperation start];*/
}

- (NSString*)secondStep:(NSString*)resultOfStep1 {
    
}

- (void)loginViaTwitterWithCompletionHandler:(LWSuccessHandler )successHandler failHandler:(LWFailHandler)failHandler {    
    
    
    ACAccountStore *store = [[ACAccountStore alloc] init]; // Long-lived
    ACAccountType *twitterType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    NSDictionary *options = @{
    
    };
    [store requestAccessToAccountsWithType:twitterType options:options completion:^(BOOL granted, NSError *error) {
        NSLog(@"%@", error);
        if(granted == 0) {
            failHandler(LWUserDeniedAccessToTwitter);
        }
    }];
    
    // Filtering
    NSArray *twitterAccounts = [store.accounts filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [[evaluatedObject accountType].identifier isEqual:ACAccountTypeIdentifierTwitter];
    }]];
    //--------------
    
    if([twitterAccounts count] > 0) {
        ACAccount *account = [twitterAccounts lastObject];
        successHandler();
    }
    else {
        failHandler(LWThereAreNoTwitterAccounts);
    }
    
    self.isLoggedIn = YES;
    [self.delegate didLoginWithLoginWay:LWLoginViaFacebook];
    
}

#pragma mark -

#pragma mark Setters
- (void)setIsLoggedIn:(BOOL)newValue {
    _isLoggedIn = newValue;
    [self save];
}
#pragma mark Getters
- (BOOL)isLoggedIn {
    return _isLoggedIn;
}
#pragma Saving state
- (void)save {
   // [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self] forKey:NSStringFromClass([self class])];
   // [[NSUserDefaults standardUserDefaults] synchronize];
}

@end