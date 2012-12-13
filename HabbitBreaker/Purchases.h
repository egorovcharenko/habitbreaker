//
//  Purchases.h
//  HabbitBreaker
//
//  Created by serg on 11/24/12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface Purchases : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>

+ (Purchases *)sharedPurchases;
- (void)requestProductWithIndex:(NSInteger)aIndex;

@end
