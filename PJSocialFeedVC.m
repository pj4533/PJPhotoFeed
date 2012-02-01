//
//  ETSocialFeedVC.m
//  EverTrue
//
//  Created by PJ Gray on 12/15/11.
//  Copyright (c) 2011 EverTrue. All rights reserved.
//

#import "PJSocialFeedVC.h"
#import "PJSocialFeedCell.h"

@implementation PJSocialFeedVC
@synthesize feedTableView = _feedTableView;
@synthesize feedName;

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

- (void) fetchFeed {
    NSLog(@"SHOULD NEVER GET CALLED");
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_feedData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

// this also depends on setting up the cell in interface builder properly with the right size adjustments
- (CGFloat)tableView:(UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *)indexPath    {
    CGSize cellSize;
    NSUInteger row = [indexPath row];
    NSDictionary* feedItem = [_feedData objectAtIndex:row];
    
    cellSize = [[feedItem objectForKey:@"Description"] sizeWithFont:[UIFont fontWithName:@"Helvetica" size:13.0f] constrainedToSize:CGSizeMake(250.0f, 132.0f) lineBreakMode:UILineBreakModeWordWrap];
    
    // hard coding 26 here to account for top and bottom of cell.  If we ever change this font, this will need to change also.
    CGFloat height = (cellSize.height + 45);
    
    return ((height > 88.0f) ? height : 88.0f);
}

@end
