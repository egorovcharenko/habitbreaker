//
//  UIView+LWAutoFont.h
//  LocaWIFI
//
//  Created by Dmitriy Gubanov on 21.08.12.
//
//

#import <UIKit/UIKit.h>

@interface UIView (LWAutoFont)

@property(nonatomic, readonly) NSString *defaultFont;

- (void)setActualFonts;

@end
