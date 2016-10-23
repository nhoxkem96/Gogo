
//
//  MyProfileController.m
//  Gogo
//
//  Created by Thuong on 9/8/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "MyProfileController.h"
#import "AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Object.h"
#import "ImageGroup.h"
#import "ViewController.h"
@interface MyProfileController ()<MyProfileTableViewCellDelegate>
@property NSMutableArray *results;
@property Object *object;
@property UserTimeline *timeline;
@end
@implementation MyProfileController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getTimelineUser];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.lblUserName.text = _myProfile.name;
    self.lblNumberFollower.text = [NSString stringWithFormat:@"%ld" , (long)_myProfile.number_follower];
    self.lblNumberFollowing.text = [NSString stringWithFormat: @"%ld" , (long)_myProfile.number_following];
    NSString *linkAvatar = [NSString stringWithFormat:@"%@" , _myProfile.avatar];
    NSString *linkBanner = [NSString stringWithFormat:@"%@" , _myProfile.banner];
    [self.imgAvatar sd_setImageWithURL:[NSURL URLWithString:[linkAvatar stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                      placeholderImage:[UIImage imageNamed:@"1"]];
    [self.imgCover sd_setImageWithURL:[NSURL URLWithString:[linkBanner stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                      placeholderImage:[UIImage imageNamed:@"1"]];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 300;
    self.imgAvatar.layer.cornerRadius = self.imgAvatar.frame.size.height /2 ;
    self.imgAvatar.layer.masksToBounds = YES;
    [self.imgAvatar layoutIfNeeded];
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                                         initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self setFont];
}
-(void)setFont{
    
    [_lblUserName setFont: [_lblUserName.font fontWithSize:[Utils fontSizeBig]]];
    [_lblDescription setFont: [_lblDescription.font fontWithSize:[Utils fontSizeNormal]]];
    [_lblNumberFollower setFont: [_lblNumberFollower.font fontWithSize:[Utils fontSizeNormal]]];
    [_lblNumberFollower setFont: [_lblNumberFollower.font fontWithSize:[Utils fontSizeNormal]]];
}
-(void)getTimelineUser{
    NSString *userID = [[NSUserDefaults standardUserDefaults]
                        stringForKey:@"userID"];

    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http:210.245.95.50:6996/api/user/%@/timeline" , userID]];
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        self.object = [MTLJSONAdapter modelOfClass:[Object class]
                                fromJSONDictionary:responseObject
                                             error:nil];
        if(self.object.code == 1){
            self.results  =  [MTLJSONAdapter modelsOfClass:[UserTimeline class] fromJSONArray:self.object.result error:nil];
            [self heightHeader:_myProfile.name description:@"Hi , I am an lifestyle and landscape photographer , freelance designer and programer."];
            [self.tableView reloadData];
        }
        else NSLog(@"%@" ,self.object.message);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyProfileTableViewCell"];
    UserTimeline *currentTime = self.results[indexPath.section];
    self.timeline = currentTime;
    NSString *linkAvatar = [NSString stringWithFormat:@"%@" , currentTime.authorAvatar];
    [cell.imgAvatar sd_setImageWithURL:[NSURL URLWithString:[linkAvatar stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                      placeholderImage:[UIImage imageNamed:@"1"]];
    cell.lblUserName.text = currentTime.authorName;
    cell.lblLocation.text = currentTime.location;
    
    
    
    cell.lblNumberLike.text = [NSString stringWithFormat:@"%ld" , (long)currentTime.number_likes];
    cell.lblNumberComment.text = [NSString stringWithFormat:@"%ld" , (long)currentTime.number_comment];
    NSDate *date = [NSDate date];
    long long time =  [@(floor([date timeIntervalSince1970] * 1000)) longLongValue] - [currentTime.created longLongValue];
    cell.lblTime.text = [NSString stringWithFormat:@"%lld ngày trước" , time/86400000];
    if(currentTime.is_like){
        [cell.btnLike setImage:[UIImage imageNamed:@"liked"] forState:UIControlStateNormal];
    }else [cell.btnLike setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    cell.contentView.userInteractionEnabled = true;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ImageGroup *group = [MTLJSONAdapter modelOfClass:[ImageGroup class]
                                  fromJSONDictionary:currentTime.image_groups[0]
                                               error:nil];
    [self updateCell:cell title:currentTime.title content:group.title];
    [cell setNeedsLayout];
    cell.delegate = self;
    cell.cellIndex = indexPath.row;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.results.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}
-(float)updateCell:(MyProfileTableViewCell *)cell title:(NSString*)title content:(NSString*)content{
    UILabel* lblTitle = cell.lblTitle;
    UILabel* lblContent = cell.lblContent;
    lblTitle.lineBreakMode = NSLineBreakByWordWrapping;
    lblTitle.numberOfLines = 0;
    lblContent.lineBreakMode = NSLineBreakByWordWrapping;
    lblContent.numberOfLines = 0;
    lblTitle.text = title;
    lblContent.text = content;
    [lblTitle sizeToFit];
//    if ([lblContent.text length] > 150) {
//        // User cannot type more than 15 characters
//        lblContent.text = [lblContent.text substringToIndex:150];
//    }
    float cellHeight = -1;
    cell.vStatus.frame = CGRectMake(cell.vStatus.frame.origin.x, cell.vStatus.frame.origin.y, cell.vStatus.frame.size.width, cell.lblTitle.frame.size.height + cell.lblContent.frame.size.height + 25);
    return cellHeight;
}
-(void)heightHeader:(NSString *)name description:(NSString*) des{
    UILabel* lblUsername = self.lblUserName;
    UILabel* lblDescription = self.lblDescription;
    lblUsername.lineBreakMode = NSLineBreakByWordWrapping;
    lblUsername.numberOfLines = 0;
    lblDescription.lineBreakMode = NSLineBreakByWordWrapping;
    lblDescription.numberOfLines = 0;
    lblUsername.text = name;
    lblDescription.text = des;
    [lblUsername sizeToFit];
    [lblDescription sizeToFit];
    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * 122 / 320 + self.imgAvatar.frame.size.height / 2 + self.lblUserName.frame.size.height + self.lblDescription.frame.size.height + 28);
}

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}
-(void)viewDidLayoutSubviews{
    self.imgAvatar.layer.cornerRadius = self.imgAvatar.frame.size.height /2 ;
    self.imgAvatar.layer.masksToBounds = YES;
    [self.imgAvatar layoutIfNeeded];
}
#pragma mark - Navigation
-(void)clickBtnComment:(NSInteger)cellIndex{
    ViewController *vc = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:@"ViewController"];
    UserTimeline *timeline = self.results[cellIndex];
    vc.idPost = timeline.iD;
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)contentTapped:(NSInteger)cellIndex{
    ViewController *vc = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:@"ViewController"];
    UserTimeline *timeline = self.results[cellIndex];
    vc.idPost = timeline.iD;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)clickBtnLike:(NSInteger)cellIndex id:(id)sender{
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    UserTimeline *timeline = self.results[cellIndex];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:cellIndex];
    MyProfileTableViewCell *cell = (MyProfileTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if(timeline.is_like == NO){
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
        NSString *url = [NSString stringWithFormat:@"http:210.245.95.50:6996/api/post/%@/like",timeline.iD];
        [manager POST:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        [cell.btnLike setImage:[UIImage imageNamed:@"liked"] forState:UIControlStateNormal];
        timeline.is_like = YES;
        cell.lblNumberLike.text = [NSString stringWithFormat:@"%ld" , timeline.number_likes + 1];
        timeline.number_likes ++;
        self.results[cellIndex] = timeline;
    }
    else{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
        NSString *url = [NSString stringWithFormat:@"http:210.245.95.50:6996/api/post/%@/unlike",timeline.iD];
        [manager DELETE:url parameters:nil success:^(NSURLSessionTask *task , id responseObject){
            NSLog(@"%@" , responseObject);
        }failure:^(NSURLSessionTask *operation, NSError *error){
            NSLog(@"%@" , error);
        }];
        [cell.btnLike setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        timeline.is_like = NO;
        cell.lblNumberLike.text = [NSString stringWithFormat:@"%ld" , timeline.number_likes - 1];
        timeline.number_likes --;
        self.results[cellIndex] = timeline;
    }
}
@end
