//
//  UIView+LWAutoFont.m
//  LocaWIFI
//
//  Created by Dmitriy Gubanov on 21.08.12.
//
//

#import "UIView+LWAutoFont.h"
#import <objc/message.h>

@implementation UIView (LWAutoFont)

@dynamic defaultFont;

/*- (void)setDefaultFont:(NSString *)defaultFont
{
	objc_setAssociatedObject(self, @"defaultFont", defaultFont, OBJC_ASSOCIATION_COPY);
}*/

- (NSString*)defaultFont
{
    return @"MV Boli";
	return objc_getAssociatedObject(self, @"defaultFont");
}


- (NSString*)fontNameForString:(NSString*)string {
    NSArray *components = [string componentsSeparatedByString:@"<F/>"];
    if(components.count > 1)
        return [components objectAtIndex:0];
    else
        return nil;
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
        if(fontName == nil) {
            fontName = self.defaultFont;
        }
        
        UIFont *oldFont      = selfBtn.titleLabel.font;
        UIFont *newFont      = [UIFont fontWithName:fontName size:oldFont.pointSize];
        
        [selfBtn.titleLabel setFont:newFont];
        
        [selfBtn setTitle:[self clearNameForString:title] forState:UIControlStateNormal];
    }
    
    else if([self isKindOfClass:[UILabel class]])
    {
        UILabel *selfLbl = (UILabel*)self;
        NSString *title      = [selfLbl text];
        NSString *fontName   = [self fontNameForString:title];
        if(fontName == nil) {
            fontName = self.defaultFont;
        }
        
        UIFont *oldFont      = selfLbl.font;
        UIFont *newFont      = [UIFont fontWithName:fontName size:oldFont.pointSize];
        
        [selfLbl setFont:newFont];
        
        [selfLbl setText:[self clearNameForString:title]];
    }
    else if([self isKindOfClass:[UITextField class]])
    {
        UITextField *selfTxFd = (UITextField*)self;
        
        NSString *text = [selfTxFd text];
        [selfTxFd setText:text];
        
        NSString *placeholder = [selfTxFd placeholder];
        [selfTxFd setPlaceholder:placeholder];
    }
    else if([self isKindOfClass:[UITextView class]])
    {
        UITextView *selfTxVw = (UITextView*)self;
        NSString *text = [selfTxVw text];
        [selfTxVw setText:text];
    }
    
    [self.subviews makeObjectsPerformSelector:_cmd];
}

@end
