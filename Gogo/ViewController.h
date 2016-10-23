//
//  ViewController.h
//  Demo
//
//  Created by Trung Đức on 8/27/16.
//  Copyright © 2016 Trung Đức. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailImageView.h"
#import "Utils.h"
#import "HeaderCell.h"
#import "TextCell.h"
#import "CollectionCell.h"
#import "DetailCell.h"
#import "BottomCell.h"
#import "SliceImageCell.h"
#import "TextContent.h"
#import "Timeline.h"
#import "ImageGroup.h"
@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource >

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *arrayImage;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;
@property (weak, nonatomic) IBOutlet UIButton *btnFollow;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberFollow;
@property NSString *idPost;
@property NSMutableArray *arrayComment;
@property Timeline *detailPost;
@end

