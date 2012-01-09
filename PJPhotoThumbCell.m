//
//  ETPhotoThumbCell.m
//  EverTrue
//
//  Created by PJ Gray on 12/15/11.
//  Copyright (c) 2011 EverTrue. All rights reserved.
//

#import "PJPhotoThumbCell.h"

@implementation PJPhotoThumbCell
@synthesize image0;
@synthesize image1;
@synthesize image2;
@synthesize image3;
@synthesize imageOffset;
@synthesize delegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}


- (IBAction)image0Tapped:(id)sender {
    if (delegate && image0)
        [delegate didSelectImageWithIndex:imageOffset];
}
- (IBAction)image1Tapped:(id)sender {
    if (delegate && image1)
        [delegate didSelectImageWithIndex:imageOffset+1];
}
- (IBAction)image2Tapped:(id)sender {
    if (delegate && image2)
        [delegate didSelectImageWithIndex:imageOffset+2];
}
- (IBAction)image3Tapped:(id)sender {
    if (delegate && image3)
        [delegate didSelectImageWithIndex:imageOffset+3];
}


@end
