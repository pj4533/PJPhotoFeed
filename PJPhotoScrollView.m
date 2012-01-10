//
//  PJPhotoScrollView.m
//  LOCPix
//
//  Created by PJ Gray on 1/9/12.
//  Copyright (c) 2012 EverTrue. All rights reserved.
//

#import "PJPhotoScrollView.h"

@implementation PJPhotoScrollView

@synthesize imageView;


#pragma mark -
#pragma mark Override layoutSubviews to center content

- (void)layoutSubviews 
{
    [super layoutSubviews];
    
    // center the image as it becomes smaller than the size of the screen
    
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = imageView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    imageView.frame = frameToCenter;
    
}

#pragma mark -
#pragma mark UIScrollView delegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}



@end
