//
//  MoreViewController.h
//  Gogo
//
//  Created by Thuong on 8/28/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoreTableViewCell2.h"
#import "Utils.h"
#import "AdView.h"
#import "Profile.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GooglePlus/GooglePlus.h>

@interface MoreViewController : UIViewController <UISearchBarDelegate , UITableViewDelegate , UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *vAd;
@property (weak, nonatomic) IBOutlet UIView *vUser;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;

@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
- (IBAction)clickBtnUser:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *vFollowing;

@property AdView *vcAd;
@property (weak, nonatomic) IBOutlet UIView *vFollower;
@property Profile *myProfile;
@property (weak, nonatomic) IBOutlet UIView *vLogout;
@property (weak, nonatomic) IBOutlet UILabel *lblFollowing;
@property (weak, nonatomic) IBOutlet UILabel *lblFollower;
- (IBAction)clickBtnRaoVat:(id)sender;
- (IBAction)clickBtnAdd:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblLogout;
@property (weak, nonatomic) IBOutlet UIButton *btnRaoVat;
@property UISearchBar *searchBar;
@end
