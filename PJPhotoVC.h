//
//  ETPhotoVC.h
//  EverTrue
//
//  Created by PJ Gray on 12/15/11.
//  Copyright (c) 2011 EverTrue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "PJImageView.h"

@interface PJPhotoVC : UIViewController <UIScrollViewDelegate> {  //,LPFacebookDelegate> {
    MBProgressHUD* _progressHud;

    NSMutableArray* imagesLoaded;
    
    BOOL _translucent;
    BOOL _opaque;
    UIColor* _tintColor;
    UIColor* _backgroundColor;
    
    // this is the index in the 3 slot array of left center right image
    NSInteger _currentArrayIndexShowing;
    
    BOOL _rotating;
    
    // doesn't seem right I need to keep track of this...
    UIInterfaceOrientation _internalOrientation;
}

@property (strong, nonatomic) NSArray* feedData;

// this is the index into the full list of images
@property NSInteger index;

@property (strong, nonatomic) IBOutlet UIScrollView *photoScrollView;
@property (strong, nonatomic) IBOutlet UILabel *photoDescription;
@property BOOL showingInfo;

- (IBAction)tapped:(id)sender;
- (IBAction)doubleTapped:(id)sender;


- (void) loadImageWithIndex:(NSInteger) index intoView:(PJImageView*) imageView;
- (PJImageView*) currentlyDisplayedImageView;

- (void) fadeOutUI;
- (void) fadeInUI;

@end
