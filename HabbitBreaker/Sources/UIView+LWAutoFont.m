//
//  UIView+LWAutoFont.m
//  LocaWIFI
//
//  Created by Dmitriy Gubanov on 21.08.12.
//
//

#import "UIView+LWAutoFont.h"
#import <objc/message.h>

static NSMutableDictionary *fontAliases;


@implementation UIView (LWAutoFont)

@dynamic defaultFont;

+ (NSMutableDictionary*)fontAliases {
    if (fontAliases == nil) {
        fontAliases = [NSMutableDictionary new];
    }
    return fontAliases;
}

- (NSMutableDictionary*)fontAliases {
    return [self.class fontAliases];
}

+ (void)registerFont:(NSString*)font as:(NSString *)alias {
    [[self fontAliases] setValue:font forKey:alias];
}

- (NSString*)defaultFont
{
    return @"Myriad Pro";
	return objc_getAssociatedObject(self, @"defaultFont");
}


- (NSString*)fontNameForString:(NSString*)string {
    NSString *retFont = nil;
    
    NSArray *components = [string componentsSeparatedByString:@"<F/>"];
    if(components.count > 1) {
        NSString *fontName      = [components objectAtIndex:0];
        NSString *maybeFontName = [self.fontAliases valueForKey:fontName];
        if (maybeFontName != nil)
            retFont = maybeFontName;
        else
            retFont = fontName;
    }
    else
        retFont = self.defaultFont;
    
    return retFont;
}

- (NSString*)clearNameForString:(NSString*)string {
    NSArray *components = [string componentsSeparatedByString:@"<F/>"];
    if(components.count > 1)
        return [components objectAtIndex:1];
    else
        return [components objectAtIndex:0];
}

- (void)setActualFonts {
    
    if([self isKindOfClass:[UIButton class]])
    {
        UIButton *selfBtn = (UIButton*)self;
        
        NSString *title      = [selfBtn titleForState:UIControlStateNormal];
        NSString *fontName   = [self fontNameForString:title];
        
        UIFont *oldFont      = selfBtn.titleLabel.font;
        UIFont *newFont      = [UIFont fontWithName:fontName size:oldFont.pointSize];
        
        [selfBtn.titleLabel setFont:newFont];
        
        [selfBtn setTitle:[self clearNameForString:title] forState:UIControlStateNormal];
    }
    
    else if([self isKindOfClass:[UILabel class]])
    {
        UILabel *selfLbl     = (UILabel*)self;
        NSString *title      = [selfLbl text];
        NSString *fontName   = [self fontNameForString:title];
        
        UIFont *oldFont      = selfLbl.font;
        UIFont *newFont      = [UIFont fontWithName:fontName size:oldFont.pointSize];
        
        [selfLbl setFont:newFont];
        
        [selfLbl setText:[self clearNameForString:title]];
    }
    else if([self isKindOfClass:[UITextField class]])
    {
        UITextField *selfTxFd = (UITextField*)self;
        NSString *text       = [selfTxFd text];
        
        NSString *fontName   = [self fontNameForString:text];
        NSString *clearText  = [self clearNameForString:text];
        
        [selfTxFd setText:clearText];
        
        UIFont *oldFont      = selfTxFd.font;
        UIFont *newFont      = [UIFont fontWithName:fontName size:oldFont.pointSize];
        
        [selfTxFd setFont:newFont];
    }
    else if([self isKindOfClass:[UITextView class]])
    {
        UITextView *selfTxVw = (UITextView*)self;
        NSString *text = [selfTxVw text];
        
        NSString *fontName   = [self fontNameForString:text];
        NSString *clearText  = [self clearNameForString:text];
        
        [selfTxVw setText:clearText];
        
        UIFont *oldFont      = selfTxVw.font;
        UIFont *newFont      = [UIFont fontWithName:fontName size:oldFont.pointSize];
        
        [selfTxVw setFont:newFont];
    }
    
    [self.subviews makeObjectsPerformSelector:_cmd];
}

@end
