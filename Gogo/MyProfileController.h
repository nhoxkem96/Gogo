//
//  MyProfileController.h
//  Gogo
//
//  Created by Thuong on 9/8/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyProfileTableViewCell.h"
#import "Profile.h"
@interface MyProfileController : UIViewController<UITableViewDataSource , UITableViewDelegate , UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgCover;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UIView *vDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberFollowing;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberFollower;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property  Profile *myProfile;
@end
