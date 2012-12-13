//
//  BaseVC.m
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 09.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import "BaseVC.h"
#import "UIView+LWAutoFont.h"
#import "UIView+LWLocalizable.h"

@interface BaseVC ()

@end

@implementation BaseVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{    
    [super viewDidLoad];
    
    [UIView registerFont:@"Myriad Pro"       as:@"MB"];
    [UIView registerFont:@"Myriad Pro Light" as:@"MSB"];
    
    [self.view setActualFonts];
    
    [self.view localize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)gotoViewControllerWithName:(NSString *)aViewControllerName {                                           
    UIViewController *targetViewController = [self viewControllerFromStoryBoardID:aViewControllerName];
    [self.tabBarController updateViewControllersWithViewController:targetViewController];
}

- (UIViewController *)viewControllerFromStoryBoardID:(NSString *)aViewControllerStoryBoardID {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"3.5" bundle:nil];
    UIViewController *viewController = [storyBoard instantiateViewControllerWithIdentifier:aViewControllerStoryBoardID];
    return viewController;
}

@end

@implementation UITabBarController (SmartTabBarController)

- (void)updateViewControllersWithViewController:(UIViewController *)aViewController {
    
    NSMutableArray *newViewControllers = [self.viewControllers mutableCopy];
    NSInteger currentViewControllerIndex = [self.viewControllers indexOfObject:self.selectedViewController];
    
    [newViewControllers replaceObjectAtIndex:currentViewControllerIndex withObject:aViewController];
    self.viewControllers = newViewControllers;
}

@end
