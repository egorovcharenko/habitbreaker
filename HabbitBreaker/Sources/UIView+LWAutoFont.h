//
//  UIView+LWAutoFont.h
//  LocaWIFI
//
//  Created by Dmitriy Gubanov on 21.08.12.
//
//

#import <UIKit/UIKit.h>

@interface UIView (LWAutoFont)

@property(nonatomic, readonly) NSString     *defaultFont;
@property(nonatomic, readonly) NSDictionary *fontAliases;

- (void)setActualFonts;
+ (void)registerFont:(NSString*)font as:(NSString *)alias;

@end
