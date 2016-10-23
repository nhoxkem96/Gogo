//
//  HomeViewController.h
//  Gogo
//
//  Created by Thuong on 8/24/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailImageView.h"
#import "Utils.h"
#import "Timeline.h"
#import "Object.h"
#import "MyProfileController.h"
@interface HomeViewController : UIViewController<UITableViewDelegate ,UITableViewDataSource , UISearchBarDelegate,UISearchDisplayDelegate  , UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *homeTableview;
@property(strong,nonatomic) NSArray *arr;
@property(strong,nonatomic) Timeline *timeline;
@property(strong,nonatomic) Object *object;
@property(nonatomic,retain) NSMutableArray *results;
@property(strong,nonatomic) UIRefreshControl *refreshControl;
-(void)getData;
@end
