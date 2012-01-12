//
//  PJPhotoVC.m
//  EverTrue
//
//  Created by PJ Gray on 12/15/11.
//  Copyright (c) 2011 EverTrue. All rights reserved.
//

#import "PJPhotoVC.h"
//#import "LPFacebook.h"
#import "PJPhotoScrollView.h"
#import "PJImageView.h"

@implementation PJPhotoVC
@synthesize photoDescription;
@synthesize photoScrollView;
@synthesize showingInfo;
@synthesize feedData;
@synthesize index;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void) fadeOutUI {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5f];
    photoDescription.alpha = 0.0f;        
    [self.navigationController.navigationBar setAlpha:0.0f];
    [UIApplication sharedApplication].statusBarHidden = YES;        
    [UIView commitAnimations];
    
    showingInfo = NO;
//    [_fadeOutTimer invalidate];
}

- (void) fadeInUI {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5f];
    photoDescription.alpha = 1.0f;
    [self.navigationController.navigationBar setAlpha:1.0f];        
    [UIApplication sharedApplication].statusBarHidden = NO;        
    [UIView commitAnimations];
    
    
    // this is a hack to handle a weird situation when coming back into the app with no status bar on a fullscreen view
    CGRect navBarFrame = self.navigationController.navigationBar.frame;
    self.navigationController.navigationBar.frame = CGRectMake(0.0, 20.0, navBarFrame.size.width, navBarFrame.size.height);

    
    showingInfo = YES;
}

- (void) setCaptionForIndex:(NSInteger) index {
    NSLog(@"ERROR");
    abort();
}

- (void) loadImageWithIndex:(NSInteger) imageIndex intoArrayIndex:(NSInteger) arrayIndex {
    
    CGFloat width = photoScrollView.frame.size.width;
    CGFloat height = photoScrollView.frame.size.height;

    // then create the new object
    PJImageView* imageView = [[PJImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, height)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds = YES;
    imageView.backgroundColor = [UIColor blackColor];
    [self loadImageWithIndex:imageIndex intoView:imageView];

    PJPhotoScrollView* onePhotoScrollView = [[PJPhotoScrollView alloc] initWithFrame:CGRectMake(width * arrayIndex, 0.0f, width, height)];
    onePhotoScrollView.tag = 1;
    onePhotoScrollView.imageView = imageView;
    onePhotoScrollView.minimumZoomScale = 1.0f;
    onePhotoScrollView.maximumZoomScale = 10.0f;
    onePhotoScrollView.delegate = onePhotoScrollView;
    [onePhotoScrollView addSubview:imageView];
    [photoScrollView addSubview:onePhotoScrollView];
    
    [imagesLoaded insertObject:imageView atIndex:arrayIndex];

    photoScrollView.contentSize = CGSizeMake(width * [imagesLoaded count], height);    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.wantsFullScreenLayout = YES;
    
//    _fadeOutTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(fadeOutUI) userInfo:nil repeats:NO];

    _translucent = self.navigationController.navigationBar.translucent;
    _opaque = self.navigationController.navigationBar.opaque;
    _tintColor = self.navigationController.navigationBar.tintColor;
    _backgroundColor = self.navigationController.navigationBar.backgroundColor;
        
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.opaque = YES;
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackTranslucent];

    showingInfo = YES;
    
    imagesLoaded = [[NSMutableArray alloc] initWithCapacity:3];
    
    CGFloat width = photoScrollView.frame.size.width;
    if ((index-1) >= 0) {
        [self loadImageWithIndex:index-1 intoArrayIndex:0];
        [self loadImageWithIndex:index intoArrayIndex:1];
        _currentArrayIndexShowing = 1;
    } else {
        [self loadImageWithIndex:index intoArrayIndex:0];
        _currentArrayIndexShowing = 0;
    }

    if ((index+1) < [self.feedData count]) {
        [self loadImageWithIndex:index+1 intoArrayIndex:[imagesLoaded count]];
    }

    [self setCaptionForIndex:index];
    
    
    photoScrollView.contentSize = CGSizeMake(width * [imagesLoaded count], photoScrollView.frame.size.height);
    photoScrollView.contentOffset = CGPointMake(width * _currentArrayIndexShowing, 0.0f);
    
}

//- (void) sharePhotoToFacebook {
//    for (UIView* subview in photoScrollView.subviews) {
//        if (subview.tag == 1) {
//            if (photoScrollView.contentOffset.x == subview.frame.origin.x) {
//                UIImageView* imgView = (UIImageView*) subview;
//                NSData* photoData = UIImagePNGRepresentation(imgView.image);
//                [[LPFacebook shared] sharePhotoWithData:photoData];
//            }
//        }
//    }                
//}
//
//- (void) facebookDidSharePhotoWithId:(NSString *)photoId {
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Shared!"
//                                                    message:@"Photo shared on Facebook."
//                                                   delegate:nil
//                                          cancelButtonTitle:@"OK" 
//                                          otherButtonTitles:nil];
//    [alert show];
//}
//
//- (void) facebookDidLogin {
//    [self sharePhotoToFacebook];
//}

- (void) viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.opaque = YES;
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackTranslucent];
}

- (void) viewWillDisappear:(BOOL)animated {
//    [_fadeOutTimer invalidate];
    
    self.navigationController.navigationBar.translucent = _translucent;
    self.navigationController.navigationBar.opaque = _opaque;
    self.navigationController.navigationBar.tintColor = _tintColor;
    self.navigationController.navigationBar.backgroundColor = _backgroundColor;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidUnload
{
    [self setPhotoDescription:nil];
    [self setPhotoScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    _rotating = YES;
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {

    UIInterfaceOrientation interfaceOrientation = self.interfaceOrientation;
    
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        
        CGFloat contentOffsetX = _currentArrayIndexShowing * 480.0f;        
        photoScrollView.contentSize = CGSizeMake(480.0f * [imagesLoaded count], 320.0f);
        photoScrollView.contentOffset = CGPointMake(contentOffsetX, 0.0f);

        int i = 0;
        for (PJPhotoScrollView* view in photoScrollView.subviews) {
            if (view.tag == 1) {
                view.zoomScale = 1.0f;
                view.frame = CGRectMake(i * 480.0f, 0.0f, 480.0f, 320.0f);
                view.contentSize = CGSizeMake(480.0f, 320.0f);
                view.imageView.frame = CGRectMake(0.0f, 0.0f, 480.0f, 320.0f);
            }
            i++;
        }
    } else if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        CGFloat contentOffsetX = _currentArrayIndexShowing * 320.0f;        
        photoScrollView.contentSize = CGSizeMake(320.0f * [imagesLoaded count], 480.0f);
        photoScrollView.contentOffset = CGPointMake(contentOffsetX, 0.0f);
        
        int i = 0;
        for (PJPhotoScrollView* view in photoScrollView.subviews) {
            if (view.tag == 1) {
                view.zoomScale = 1.0f;
                view.frame = CGRectMake(i * 320.0f, 0.0f, 320.0f, 480.0f);
                view.contentSize = CGSizeMake(320.0f, 480.0f);
                view.imageView.frame = CGRectMake(0.0f, 0.0f, 320.0f, 480.0f);
            }
            i++;
        }

    }

    [photoScrollView setNeedsLayout];
    
}

// autorotate not loading right initialling (need to scroll to reset)
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    _rotating = NO;
    [self fadeInUI];
    return YES;
}

- (IBAction)tapped:(id)sender {
    
    if (showingInfo) {
        [self fadeOutUI];
    }
    else {
        [self fadeInUI];
    }
}

- (void) loadImageWithIndex:(NSInteger) index intoView:(PJImageView*) imageView {
    NSLog(@"ERROR SHOULD NEVER GET CALLED");
    abort();
}


- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_rotating)
        return;

//    [self fadeOutUI];
    
    CGFloat width = scrollView.frame.size.width;
    CGFloat height = scrollView.frame.size.height;
    
    if ((scrollView.contentOffset.x == (width*2)) && (_currentArrayIndexShowing != 2)) {
        index++;
        if ((index+1) < [self.feedData count]) {
            // this section should remove the leftmost view, move the center and right
            // ones to the left, and create a new one to the right.
            for (UIView* subview in scrollView.subviews) {
                if (subview.tag == 1) {
                    if (subview.frame.origin.x == 0.0f) {
                        [subview removeFromSuperview];
                        [imagesLoaded removeObjectAtIndex:0];
                    } else if (subview.frame.origin.x == width) {
                        subview.frame = CGRectMake(0.0f, 0.0f, width, height);
                    } else if (subview.frame.origin.x == (width*2)) {
                        subview.frame = CGRectMake(width, 0.0f, width, height);
                    }
                }
            }
            _currentArrayIndexShowing = 1;
            scrollView.contentOffset = CGPointMake(width, 0.0f);
            [self loadImageWithIndex:index+1 intoArrayIndex:2];
        } else {
            _currentArrayIndexShowing = 2;
        }

    } else if ((scrollView.contentOffset.x == 0.0f) && (_currentArrayIndexShowing != 0)){

        index--;
        if ((index-1) >= 0) {
            // this section should remove the rightmost view, move the center and left
            // to the right and create a new one to the left
            for (UIView* subview in scrollView.subviews) {
                if (subview.tag == 1) {
                    if (subview.frame.origin.x == 0.0f) {
                        subview.frame = CGRectMake(width, 0.0f, width, height);
                    } else if (subview.frame.origin.x == width) {
                        subview.frame = CGRectMake(width*2, 0.0f, width, height);
                    } else if (subview.frame.origin.x == (width*2)) {
                        [subview removeFromSuperview];
                        [imagesLoaded removeObjectAtIndex:2];
                    }
                }
            }
            _currentArrayIndexShowing = 1;
            scrollView.contentOffset = CGPointMake(width, 0.0f);
            [self loadImageWithIndex:index-1 intoArrayIndex:0];
        } else {
            _currentArrayIndexShowing = 0;
        }
    } else if (scrollView.contentOffset.x == width) {
        if (_currentArrayIndexShowing != 1) {

            if (_currentArrayIndexShowing == 0) {
                index++;
                scrollView.contentOffset = CGPointMake(width, 0.0f);
                if (index+1 < [self.feedData count])
                    [self loadImageWithIndex:index+1 intoArrayIndex:2];
            } else {
                index--;
            }

            _currentArrayIndexShowing = 1;
        }

    }

    [self setCaptionForIndex:index];
}

- (PJImageView*) currentlyDisplayedImageView {

    PJImageView* imgView = [imagesLoaded objectAtIndex:_currentArrayIndexShowing];
    
    return imgView;
}

@end
