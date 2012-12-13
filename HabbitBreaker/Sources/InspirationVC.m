//
//  InpirationVC.m
//  HabbitBreaker
//
//  Created by Dmitriy Gubanov on 03.10.12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import "InspirationVC.h"

@interface InspirationVC ()

@end

@implementation InspirationVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollCanvas.pagingEnabled = YES;
    
    CGSize contentSize = self.scrollCanvas.contentSize;
    
    for (UIView *view in self.scrollCanvas.subviews) {
        contentSize.width  = MAX(contentSize.width, view.frame.origin.x + view.frame.size.width);
    }
    self.scrollCanvas.contentSize  = contentSize;
    
    self.pageControl.numberOfPages = self.pages.count;
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

- (void)viewDidUnload {
    [self setScrollCanvas:nil];
    [self setPages:nil];
    [super viewDidUnload];
}
@end