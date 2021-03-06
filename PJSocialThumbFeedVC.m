//
//  ETSocialThumbFeedVC.m
//  EverTrue
//
//  Created by PJ Gray on 1/5/12.
//  Copyright (c) 2012 EverTrue. All rights reserved.
//

#import "PJSocialThumbFeedVC.h"

@implementation PJSocialThumbFeedVC

@synthesize total;
@synthesize page;
@synthesize perPage;
@synthesize thumbnailContentMode;
@synthesize thumbnailWidth;
@synthesize thumbnailHeight;

#pragma mark - View lifecycle

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.thumbnailContentMode = UIViewContentModeCenter;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            thumbnailWidth = 75.0;
        else {
            if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
                thumbnailWidth = 250;//185;
            else
                thumbnailWidth = 250;//165;
        }
        thumbnailHeight = thumbnailWidth;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.feedTableView.backgroundColor = [UIColor blackColor];
    self.feedTableView.separatorStyle = UITableViewCellSeparatorStyleNone; 
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.feedTableView reloadData];
}

- (void) viewWillAppear:(BOOL)animated {
    [self.feedTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([_feedData count]) {
        int numberAcross = (int) floor(tableView.frame.size.width / thumbnailWidth);

        NSInteger numRows = (NSInteger) (ceil( (double) [_feedData count]/ (double) numberAcross));

        return numRows;
    } else
        return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return thumbnailHeight + 4;  // dynamic?
}


- (void) loadImageWithURL:(NSURL*) url intoImageView:(UIImageView*) asyncImageView cachedOnly:(BOOL)cachedOnly {
    NSLog(@"SHOULD NEVER BE CALLED");
    abort();
}

- (NSURL*) getUrlForIndex:(NSInteger) index {
    NSLog(@"SHOULD NEVER BE CALLED");
    abort();
}

- (void) loadPlaceholderImagesForCell:(UITableViewCell*) cell atIndexPath:(NSIndexPath*) indexPath {
    for (UIView* view in cell.subviews) {
        [view removeFromSuperview];
    }
    
    int numberAcross = (int) floor(cell.frame.size.width / thumbnailWidth);
    for (int i = 0; i < numberAcross; i++) {        
        NSInteger imageOffset = ([indexPath row] * numberAcross) + i;
        if (imageOffset < [_feedData count]) {
            CGRect frameRect = CGRectMake((thumbnailWidth * i) + 4.0 + (4.0 * i), 2, thumbnailWidth, thumbnailHeight);
            UIImageView* imageView = [[UIImageView alloc] initWithFrame:frameRect];
            imageView.contentMode = self.thumbnailContentMode;
            imageView.backgroundColor = [UIColor blackColor];
            imageView.image = [UIImage imageNamed:@"loading_placeholder"];
            [cell addSubview:imageView];            
        }
    }    
}

- (void) loadImagesForCell:(UITableViewCell*) cell atIndexPath:(NSIndexPath*) indexPath cachedOnly:(BOOL)cachedOnly {
//    for (UIView* view in cell.subviews) {
//        [view removeFromSuperview];
//    }

    int numberAcross = (int) floor(cell.frame.size.width / thumbnailWidth);
    for (int i = 0; i < numberAcross; i++) {        
        NSInteger imageOffset = ([indexPath row] * numberAcross) + i;
        if (imageOffset < [_feedData count]) {
            // create UIImageView,  create UIButton   use tag for index?
            CGRect frameRect = CGRectMake((thumbnailWidth * i) + 4.0 + (4.0 * i), 2, thumbnailWidth, thumbnailHeight);
            UIImageView* imageView = [[UIImageView alloc] initWithFrame:frameRect];
            imageView.backgroundColor = [UIColor blackColor];
            imageView.contentMode = self.thumbnailContentMode;
            imageView.clipsToBounds = YES;
            imageView.tag = imageOffset;
            [self loadImageWithURL:[self getUrlForIndex:imageOffset] intoImageView:imageView cachedOnly:cachedOnly];
            [cell addSubview:imageView];
            
            UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = imageOffset;
            button.frame = frameRect;
            [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];        
            [cell addSubview:button];
        }
    }
}

- (void) didSelectImageWithIndex:(NSInteger)index {
    NSLog(@"SHOULD NEVER BE CALLED");
    abort();    
}

- (void) buttonPressed:(id) sender {
    UIButton* button = (UIButton*) sender;
    [self didSelectImageWithIndex:button.tag];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor blackColor];
    }

    // right now just moves over right most cell cause of settings in nib
    cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, tableView.frame.size.width, 79.0);
    
    if (![self.feedTableView isDecelerating]) {
        [self loadImagesForCell:cell atIndexPath:indexPath cachedOnly:NO];
    } else {
        [self loadImagesForCell:cell atIndexPath:indexPath cachedOnly:YES];        
    }

    return cell;
}

@end
