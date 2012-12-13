//
//  UIView+LWLocalizable.m
//  LocaWIFI
//
//  Created by Dmitriy Gubanov on 13.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIView+LWLocalizable.h"

@implementation UIView (LWLocalizable)

- (void)localize {
    
    if([self isKindOfClass:[UIButton class]])
    {
        UIButton *selfBtn = (UIButton*)self;
        
        NSString *normalTitle = NSLocalizedString([selfBtn titleForState:UIControlStateNormal], nil);
        NSString *highlightedTitle = NSLocalizedString([selfBtn titleForState:UIControlStateHighlighted], nil);
        NSString *disabledTitle = NSLocalizedString([selfBtn titleForState:UIControlStateDisabled], nil);
        NSString *selectedTitle = NSLocalizedString([selfBtn titleForState:UIControlStateSelected], nil);
        
        [selfBtn setTitle:normalTitle forState:UIControlStateNormal];
        [selfBtn setTitle:highlightedTitle forState:UIControlStateHighlighted];
        [selfBtn setTitle:disabledTitle forState:UIControlStateDisabled];
        [selfBtn setTitle:selectedTitle forState:UIControlStateSelected];
        
    }
    
    else if([self isKindOfClass:[UILabel class]])
    {
        UILabel *selfLbl = (UILabel*)self;
        NSString *text = NSLocalizedString([selfLbl text], nil);
        [selfLbl setText:text];
    }
    else if([self isKindOfClass:[UITextField class]])
    {
        UITextField *selfTxFd = (UITextField*)self;
        
        NSString *text = NSLocalizedString([selfTxFd text], nil);
        [selfTxFd setText:text];
        
        NSString *placeholder = NSLocalizedString([selfTxFd placeholder], nil);
        [selfTxFd setPlaceholder:placeholder];                                     
    }
    else if([self isKindOfClass:[UITextView class]])
    {
        UITextView *selfTxVw = (UITextView*)self;
        NSString *text = NSLocalizedString([selfTxVw text], nil);
        [selfTxVw setText:text];
    }
    
    [self.subviews makeObjectsPerformSelector:_cmd];
}

@end
