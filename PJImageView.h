//
//  PJImageView.h
//  LOCPix
//
//  Created by PJ Gray on 1/10/12.
//  Copyright (c) 2012 EverTrue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface PJImageView : UIImageView

@property (strong, nonatomic) NSString* url;
@property CGFloat zoomScale;
@property (strong, nonatomic) MBProgressHUD* progressHud;

@end
