//
//  ETSocialFeedVC.h
//  EverTrue
//
//  Created by PJ Gray on 12/15/11.
//  Copyright (c) 2011 EverTrue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface PJSocialFeedVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate> {
    MBProgressHUD* _progressHud;
    NSArray* _feedData;
}
@property (strong, nonatomic) IBOutlet UITableView *feedTableView;
@property (nonatomic, strong) NSString* feedName;

@end
