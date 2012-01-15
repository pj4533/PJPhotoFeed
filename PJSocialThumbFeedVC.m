//
//  ETSocialThumbFeedVC.m
//  EverTrue
//
//  Created by PJ Gray on 1/5/12.
//  Copyright (c) 2012 EverTrue. All rights reserved.
//

#import "PJSocialThumbFeedVC.h"

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
        int numberAcross = (int) floor(tableView.frame.size.width / 75.0);

        NSInteger numRows = (NSInteger) (ceil( (double) [_feedData count]/ (double) numberAcross));

        return numRows;
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

- (void) loadPlaceholderImagesForCell:(UITableViewCell*) cell atIndexPath:(NSIndexPath*) indexPath {
    for (UIView* view in cell.subviews) {
        [view removeFromSuperview];
    }
    
    int numberAcross = (int) floor(cell.frame.size.width / 75.0);
    for (int i = 0; i < numberAcross; i++) {        
        NSInteger imageOffset = ([indexPath row] * numberAcross) + i;
        if (imageOffset < [_feedData count]) {
            CGRect frameRect = CGRectMake((75.0 * i) + 4.0 + (4.0 * i), 2, 75.0, 75.0);
            UIImageView* imageView = [[UIImageView alloc] initWithFrame:frameRect];
            imageView.image = [UIImage imageNamed:@"thumbnail_placeholder"];
            [cell addSubview:imageView];            
        }
    }    
}

- (void) loadImagesForCell:(UITableViewCell*) cell atIndexPath:(NSIndexPath*) indexPath {
    for (UIView* view in cell.subviews) {
        [view removeFromSuperview];
    }

    int numberAcross = (int) floor(cell.frame.size.width / 75.0);
    for (int i = 0; i < numberAcross; i++) {        
        NSInteger imageOffset = ([indexPath row] * numberAcross) + i;
        if (imageOffset < [_feedData count]) {
            // create UIImageView,  create UIButton   use tag for index?
            CGRect frameRect = CGRectMake((75.0 * i) + 4.0 + (4.0 * i), 2, 75.0, 75.0);
            UIImageView* imageView = [[UIImageView alloc] initWithFrame:frameRect];
            imageView.tag = imageOffset;
            [self loadImageWithURL:[self getUrlForIndex:imageOffset] intoImageView:imageView];
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

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSArray* visibleIndexPaths = [self.feedTableView indexPathsForVisibleRows];
    for (NSIndexPath* indexPath in visibleIndexPaths) {
        UITableViewCell* cell = [self.feedTableView cellForRowAtIndexPath:indexPath];
        [self loadImagesForCell:cell atIndexPath:indexPath];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    // right now just moves over right most cell cause of settings in nib
    cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, tableView.frame.size.width, 79.0);
    
    if (![self.feedTableView isDecelerating]) {
        [self loadImagesForCell:cell atIndexPath:indexPath];        
    } else {
        [self loadPlaceholderImagesForCell:cell atIndexPath:indexPath];
    }
    
    return cell;
}

@end
