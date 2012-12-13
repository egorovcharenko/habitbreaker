//
//  Purchases.m
//  HabbitBreaker
//
//  Created by serg on 11/24/12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import "Purchases.h"

//#define kProductIdentifier @"com.kendalinvestmentslimited.habitbreaker"
#define kProductIdentifier @"com.humantouch.habitbreaker."

@interface Purchases() {

}

@end

@implementation Purchases

- (id)init
{
    self = [super init];
    if (self) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

+ (Purchases *)sharedPurchases
{
    static Purchases *sharedPurchases = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        sharedPurchases = [[self alloc] init];
    });
    return sharedPurchases;
}

- (void)addPaymentWithProduct:(SKProduct *)aProduct
{
    SKPayment *payment = [SKPayment paymentWithProduct:aProduct];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    SKPaymentTransaction *transaction = [transactions lastObject];

    switch (transaction.transactionState)
    {
        case SKPaymentTransactionStatePurchased:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"purchased" object:nil];
            break;
            
        case SKPaymentTransactionStatePurchasing:
            return;
            break;
            
        case SKPaymentTransactionStateFailed:
            [self showErrorFromTransaction:transaction];
            break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"paymentTransactionEnded" object:nil];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)showErrorFromTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled) {
        [[[UIAlertView alloc] initWithTitle:@"Payment failed:"
                                   message:transaction.error.localizedDescription
                                  delegate:nil
                         cancelButtonTitle:@"Ok"
                         otherButtonTitles:nil] show];
    }
}


- (void)requestProductWithIndex:(NSInteger)aIndex
{
    NSString *productName = [NSString stringWithFormat:@"%@%d", kProductIdentifier, aIndex];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:productName]];
    request.delegate = self;
    [request start];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"paymentRequestSended" object:nil];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSLog(@"Invalid identifiers : %@", response.invalidProductIdentifiers);
    if (response.products.count > 1) {
        NSLog(@"some thing wrong");
    }
    [self addPaymentWithProduct:[response.products lastObject]];
}


@end
