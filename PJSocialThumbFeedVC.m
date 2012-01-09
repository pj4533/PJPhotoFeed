//
//  ETSocialThumbFeedVC.m
//  EverTrue
//
//  Created by PJ Gray on 1/5/12.
//  Copyright (c) 2012 EverTrue. All rights reserved.
//

#import "PJSocialThumbFeedVC.h"
#import "PJPhotoThumbCell.h"

@implementation PJSocialThumbFeedVC

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.feedTableView.separatorStyle = UITableViewCellSeparatorStyleNone; 
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([_feedData count]) {
        return (NSInteger) (ceil([_feedData count]/4.0f));
    } else
        return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 79;  // dynamic?
}


- (void) loadImageWithURL:(NSURL*) url intoImageView:(UIImageView*) asyncImageView {
    NSLog(@"SHOULD NEVER BE CALLED");
    abort();
}

- (NSURL*) getUrlForIndex:(NSInteger) index {
    NSLog(@"SHOULD NEVER BE CALLED");
    abort();
}

- (void) loadImagesForCell:(PJPhotoThumbCell*) cell atIndexPath:(NSIndexPath*) indexPath {
    int imageOffset = [indexPath row] * 4;
    cell.imageOffset = imageOffset;
    cell.delegate = self;
    
    
    [self loadImageWithURL:[self getUrlForIndex:imageOffset] intoImageView:cell.image0];
    imageOffset++;    
    if (imageOffset < [_feedData count]) {
        [self loadImageWithURL:[self getUrlForIndex:imageOffset] intoImageView:cell.image1];
        imageOffset++;    
        if (imageOffset < [_feedData count]) {
            [self loadImageWithURL:[self getUrlForIndex:imageOffset] intoImageView:cell.image2];
            imageOffset++;    
            if (imageOffset < [_feedData count]) {
                [self loadImageWithURL:[self getUrlForIndex:imageOffset] intoImageView:cell.image3];
            } 
        } 
    } 
    
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSArray* visibleIndexPaths = [self.feedTableView indexPathsForVisibleRows];
    for (NSIndexPath* indexPath in visibleIndexPaths) {
        PJPhotoThumbCell* cell = (PJPhotoThumbCell*) [self.feedTableView cellForRowAtIndexPath:indexPath];
        
        [self loadImagesForCell:cell atIndexPath:indexPath];
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PJPhotoThumbCell *cell = (PJPhotoThumbCell*) [tableView dequeueReusableCellWithIdentifier:@"customCell"];
	
    if (cell == nil) {
		
        NSArray* nibObjects = [[NSBundle mainBundle] loadNibNamed:@"ETPhotoThumbCell" owner:nil options:nil];
        for (id currentObject in nibObjects) {
            if ([currentObject isKindOfClass:[PJPhotoThumbCell class]]) {
                cell = (PJPhotoThumbCell*) currentObject;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
    }
    
    if (![self.feedTableView isDecelerating]) {
        [self loadImagesForCell:cell atIndexPath:indexPath];
    }
    
    return cell;
}

- (void) didSelectImageWithIndex:(NSInteger)index {
    NSLog(@"SHOULD NEVER BE CALLED");
    abort();    
}

@end
