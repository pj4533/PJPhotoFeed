//
//  ETPhotoVC.h
//  EverTrue
//
//  Created by PJ Gray on 12/15/11.
//  Copyright (c) 2011 EverTrue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
//#import "LPFacebook.h"

@interface PJPhotoVC : UIViewController <UIScrollViewDelegate,UIActionSheetDelegate> {  //,LPFacebookDelegate> {
    MBProgressHUD* _progressHud;

    NSMutableArray* imagesLoaded;
    
    BOOL _translucent;
    BOOL _opaque;
    UIColor* _tintColor;
    UIColor* _backgroundColor;
    
    NSTimer* _fadeOutTimer;
    
    // this is the index in the 3 slot array of left center right image
    NSInteger _currentArrayIndexShowing;
    
    BOOL _rotating;
}

@property (strong, nonatomic) NSArray* feedData;

// this is the index into the full list of images
@property NSInteger index;

@property (strong, nonatomic) IBOutlet UIScrollView *photoScrollView;
@property (strong, nonatomic) IBOutlet UILabel *photoDescription;
@property BOOL showingInfo;

- (IBAction)tapped:(id)sender;


- (void) loadImageWithIndex:(NSInteger) index intoView:(UIImageView*) imageView;

@end
