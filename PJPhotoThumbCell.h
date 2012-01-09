//
//  ETPhotoThumbCell.h
//  EverTrue
//
//  Created by PJ Gray on 12/15/11.
//  Copyright (c) 2011 EverTrue. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PJPhotoThumbCellDelegate <NSObject>
- (void) didSelectImageWithIndex:(NSInteger) index;
@end

@interface PJPhotoThumbCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *image0;
@property (strong, nonatomic) IBOutlet UIImageView *image1;
@property (strong, nonatomic) IBOutlet UIImageView *image2;
@property (strong, nonatomic) IBOutlet UIImageView *image3;
@property (strong, nonatomic) id delegate;
@property int imageOffset;

- (IBAction)image0Tapped:(id)sender;
- (IBAction)image1Tapped:(id)sender;
- (IBAction)image2Tapped:(id)sender;
- (IBAction)image3Tapped:(id)sender;

@end

