//
//  PJPhotoVC.m
//  EverTrue
//
//  Created by PJ Gray on 12/15/11.
//  Copyright (c) 2011 EverTrue. All rights reserved.
//

#import "PJPhotoVC.h"
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

    PJPhotoScrollView* onePhotoScrollView = [[PJPhotoScrollView alloc] initWithFrame:CGRectMake(width * arrayIndex, 0.0f, width, height)];
    onePhotoScrollView.tag = 1;
    onePhotoScrollView.minimumZoomScale = 1.0f;
    onePhotoScrollView.maximumZoomScale = 10.0f;
    onePhotoScrollView.delegate = onePhotoScrollView;
    [photoScrollView addSubview:onePhotoScrollView];
    
    [imagesLoaded insertObject:onePhotoScrollView atIndex:arrayIndex];

    photoScrollView.contentSize = CGSizeMake(width * [imagesLoaded count], height);    

    [self loadImageWithIndex:imageIndex intoView:onePhotoScrollView.imageView];
    
}

- (void) updateViewToOrientation:(UIInterfaceOrientation) interfaceOrientation withDuration:(NSTimeInterval) duration {
    CGFloat longSide;
    CGFloat shortSide;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        longSide = 480.0f;
        shortSide = 320.0f;
    } else {
        longSide = 1024.0f;
        shortSide = 768.0f;
    }
    
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        
        CGFloat contentOffsetX = _currentArrayIndexShowing * longSide;        
        photoScrollView.contentSize = CGSizeMake(longSide * [imagesLoaded count], shortSide);        
        photoScrollView.contentOffset = CGPointMake(contentOffsetX, 0.0f);
        
        int i = 0;
        for (PJPhotoScrollView* view in imagesLoaded) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:duration];
            view.zoomScale = 1.0f;
            view.frame = CGRectMake(i * longSide, 0.0f, longSide, shortSide);
            view.contentSize = CGSizeMake(longSide, shortSide);
            view.imageView.frame = CGRectMake(0.0f, 0.0f, longSide, shortSide);
            [UIView commitAnimations];
            
            i++;            
        }
    } else if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        NSLog(@"here");
        CGFloat contentOffsetX = _currentArrayIndexShowing * shortSide;        
        photoScrollView.contentSize = CGSizeMake(shortSide * [imagesLoaded count], longSide);
        photoScrollView.contentOffset = CGPointMake(contentOffsetX, 0.0f);
        
        int i = 0;
        for (PJPhotoScrollView* view in imagesLoaded) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:duration];
            view.zoomScale = 1.0f;
            view.frame = CGRectMake(i * shortSide, 0.0f, shortSide, longSide);
            view.contentSize = CGSizeMake(shortSide, longSide);
            view.imageView.frame = CGRectMake(0.0f, 0.0f, shortSide, longSide);
            [UIView commitAnimations];
            i++;
        }
    }
    
    [photoScrollView setNeedsLayout];
    _internalOrientation = interfaceOrientation;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.wantsFullScreenLayout = YES;
    
    _internalOrientation = UIInterfaceOrientationPortrait;//self.interfaceOrientation;        

    UITapGestureRecognizer* doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapped:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    [self.photoScrollView addGestureRecognizer:doubleTapGesture];

    UITapGestureRecognizer* singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    [self.photoScrollView addGestureRecognizer:singleTapGesture];
    
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
    
    
    // this is a hack, but works to make sure it updates from the nib properly
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        [self updateViewToOrientation:self.interfaceOrientation withDuration:0.1f];
}

- (void) viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.opaque = YES;
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackTranslucent];
    
    if (_internalOrientation != self.interfaceOrientation) {
        [self updateViewToOrientation:self.interfaceOrientation withDuration:0.1f];
    }    
}

- (void) viewWillDisappear:(BOOL)animated {    
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
    
    UIInterfaceOrientation interfaceOrientation = toInterfaceOrientation;
    
    [self updateViewToOrientation:interfaceOrientation withDuration:duration];
}


- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    _rotating = NO;
}

// autorotate not loading right initialling (need to scroll to reset)
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
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

- (IBAction)doubleTapped:(id)sender {

    UIGestureRecognizer* theTap = (UIGestureRecognizer*) sender;
    
    PJPhotoScrollView* thisScrollView = [imagesLoaded objectAtIndex:_currentArrayIndexShowing];
    
    if (thisScrollView.zoomScale == 1.0f) {
        CGPoint centerPoint = [theTap locationInView:[imagesLoaded objectAtIndex:_currentArrayIndexShowing]];
        
        CGRect toZoom;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            toZoom = CGRectMake(centerPoint.x - 50.0f, centerPoint.y - 50.0f, 100.0f, 100.0f);
        else
            toZoom = CGRectMake(centerPoint.x - 50.0f, centerPoint.y - 50.0f, 200.0f, 200.0f);

        [thisScrollView zoomToRect:toZoom animated:YES];
    } else {
        [thisScrollView setZoomScale:1.0f animated:YES];
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
    
    
    // possibly i don't need this....can't I just use the imagesLoaded array to get this scroll view not use
    // a for loop
    if ((scrollView.contentOffset.x == (width*2)) && (_currentArrayIndexShowing != 2)) {
        index++;
        if ((index+1) < [self.feedData count]) {
            // this section should remove the leftmost view, move the center and right
            // ones to the left, and create a new one to the right.
            PJPhotoScrollView* right = [imagesLoaded objectAtIndex:2];
            right.frame = CGRectMake(width, 0.0f, width, height);
            
            PJPhotoScrollView* middle = [imagesLoaded objectAtIndex:1];
            middle.frame = CGRectMake(0.0f, 0.0f, width, height);
            
            PJPhotoScrollView* left = [imagesLoaded objectAtIndex:0];
            [left removeFromSuperview];
            [imagesLoaded removeObjectAtIndex:0];
            
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
            PJPhotoScrollView* left = [imagesLoaded objectAtIndex:0];
            left.frame = CGRectMake(width, 0.0f, width, height);
            
            PJPhotoScrollView* middle = [imagesLoaded objectAtIndex:1];
            middle.frame = CGRectMake(width*2, 0.0f, width, height);
            
            if ([imagesLoaded count] == 3) {
                PJPhotoScrollView* right = [imagesLoaded objectAtIndex:2];
                [right removeFromSuperview];
                [imagesLoaded removeObjectAtIndex:2];
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
                if (index+1 < [self.feedData count]) {
                    [self loadImageWithIndex:index+1 intoArrayIndex:2];
                }
            } else {
                index--;
            }

            _currentArrayIndexShowing = 1;
        }

    }

    [self setCaptionForIndex:index];
}

- (PJImageView*) currentlyDisplayedImageView {

    PJPhotoScrollView* currentScrollView = [imagesLoaded objectAtIndex:_currentArrayIndexShowing];
    PJImageView* imgView = currentScrollView.imageView;
    
    return imgView;
}

@end
