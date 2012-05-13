//
//  ETSocialThumbFeedVC.h
//  EverTrue
//
//  Created by PJ Gray on 1/5/12.
//  Copyright (c) 2012 EverTrue. All rights reserved.
//

#import "PJSocialFeedVC.h"

@interface PJSocialThumbFeedVC : PJSocialFeedVC <UIScrollViewDelegate> {
    CGFloat _thumbnailWidth;
}

@property NSInteger total;
@property NSInteger page;
@property NSInteger perPage;
@property UIViewContentMode thumbnailContentMode;
@property CGFloat thumbnailWidth;
@property CGFloat thumbnailHeight;

@end
