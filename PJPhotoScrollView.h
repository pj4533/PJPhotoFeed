//
//  PJPhotoScrollView.h
//  LOCPix
//
//  Created by PJ Gray on 1/9/12.
//  Copyright (c) 2012 EverTrue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PJImageView.h"

@interface PJPhotoScrollView : UIScrollView <UIScrollViewDelegate>


@property (strong, nonatomic) PJImageView* imageView;

@end
