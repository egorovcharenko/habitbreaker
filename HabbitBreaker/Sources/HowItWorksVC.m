//
//  HowItWorksVC.m
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 03.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import "HowItWorksVC.h"

#import "LocalyticsSession.h"

@interface HowItWorksVC ()

@end

@implementation HowItWorksVC

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
    
    CGSize contentSize = self.scrollCanvas.contentSize;
        
    for (UIView *view in self.scrollCanvas.subviews) {
        contentSize.width  = MAX(contentSize.width, view.frame.origin.x + view.frame.size.width);
    }
    self.scrollCanvas.contentSize  = contentSize;
    
    self.pageControl.numberOfPages = self.pages.count;
    
    // localytics
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:@"How it works: screen opened"];
    [[LocalyticsSession sharedLocalyticsSession] tagScreen:@"How it works"];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.pageControl.currentPage =
        scrollView.contentOffset.x / scrollView.contentSize.width *
        scrollView.contentSize.width / scrollView.frame.size.width +
        0.5;
}
#pragma mark -

- (IBAction)onPageControlChangeValue:(UIPageControl*)sender {
    [self.scrollCanvas setContentOffset:
     CGPointMake(self.scrollCanvas.frame.size.width * sender.currentPage, 0)
                               animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
