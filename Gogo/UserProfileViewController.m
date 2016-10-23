//
//  UserProfileViewController.m
//  Gogo
//
//  Created by Thuong on 9/18/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "UserProfileViewController.h"
#import "AFNetworking.h"
#import "UserProfileTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Object.h"
#import "SingleObject.h"
#import "ImageGroup.h"
#import "ViewController.h"
#import "LoginViewController.h"
#import "Utils.h"
@interface UserProfileViewController ()<UserProfileTableViewCellDelegate>
@property NSMutableArray *results;
@property Object *object;
@property UserTimeline *timeline;
@end

@implementation UserProfileViewController
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self getData];
    [self setData];
    [self getTimelineUser];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    self.imgAvatarUser.layer.cornerRadius = self.imgAvatarUser.frame.size.height / 2;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationItem.backBarButtonItem setTitle:@" "];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 250;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 50; // for header
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                                         initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self setFont];
}
-(void)setFont{
    
    [_lblUsername setFont: [_lblUsername.font fontWithSize:[Utils fontSizeBig]]];
    [_lblDescription setFont: [_lblDescription.font fontWithSize:[Utils fontSizeNormal]]];
    [_lblNumberFollower setFont: [_lblNumberFollower.font fontWithSize:[Utils fontSizeNormal]]];
    [_lblNumberFollower setFont: [_lblNumberFollower.font fontWithSize:[Utils fontSizeNormal]]];
}
-(void)heightHeader:(NSString *)name description:(NSString*) des{
    UILabel* lblUsername = self.lblUsername;
    UILabel* lblDescription = self.lblDescription;
    lblUsername.lineBreakMode = NSLineBreakByWordWrapping;
    lblUsername.numberOfLines = 0;
    lblDescription.lineBreakMode = NSLineBreakByWordWrapping;
    lblUsername.text = name;
    lblDescription.text = des;
    [lblUsername sizeToFit];
    [lblDescription sizeToFit];
    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * 122 / 320 + self.imgAvatarUser.frame.size.height / 2 + self.lblUsername.frame.size.height + self.lblDescription.frame.size.height + 28);
}
-(void)setData{
    self.lblNumberFollower.text = [NSString stringWithFormat:@"%ld" , (long)_userProfile.number_follower];
    self.lblNumberFollowing.text = [NSString stringWithFormat: @"%ld" , (long)_userProfile.number_following];
    NSString *linkAvatar = [NSString stringWithFormat:@"%@" , _userProfile.avatar];
    NSString *linkBanner = [NSString stringWithFormat:@"%@" , _userProfile.banner];
    self.lblUsername.text = _userProfile.name;
    [self.imgAvatarUser sd_setImageWithURL:[NSURL URLWithString:[linkAvatar stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                          placeholderImage:[UIImage imageNamed:@"1"]];
    [self.imgBanner sd_setImageWithURL:[NSURL URLWithString:[linkBanner stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                      placeholderImage:[UIImage imageNamed:@"1"]];
    if(_userProfile.is_follow){
        
        [_btnFollow setTitle:@"Follow" forState:UIControlStateNormal];
    }else [_btnFollow setTitle:@"Unfollow" forState:UIControlStateNormal];
    [self.headerTableview setNeedsDisplay];
}
-(void)getTimelineUser{
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http:210.245.95.50:6996/api/user/%@/timeline" , self.userID]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        self.object = [MTLJSONAdapter modelOfClass:[Object class]
                                         fromJSONDictionary:responseObject
                                                      error:nil];
        if(self.object.code == 1){
            self.results  =  [MTLJSONAdapter modelsOfClass:[UserTimeline class] fromJSONArray:self.object.result error:nil];
            [self.tableView reloadData];
        }
        else NSLog(@"%@" ,self.object.message);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void)getData{
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http:210.245.95.50:6996/api/user/%@" , self.userID]];
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"%@" , responseObject);
        SingleObject *object = [MTLJSONAdapter modelOfClass:[SingleObject class]
                                         fromJSONDictionary:responseObject
                                                      error:nil];
        NSLog(@"%@" , object);
        if(object.code == 1){
            _userProfile =  [MTLJSONAdapter modelOfClass:[Profile class]
                                    fromJSONDictionary:responseObject
                                                 error:nil];
            NSLog(@"%@" , _userProfile);
            [self setData];
            [self heightHeader:_userProfile.name description:@"Hi , I am an lifestyle and landscape photographer , freelance designer and programer."];
            [self.tableView reloadData];
        }
        else NSLog(@"%@" ,object.message);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
-(void)viewDidLayoutSubviews{
    self.imgAvatarUser.layer.cornerRadius = self.imgAvatarUser.frame.size.height /2 ;
    self.imgAvatarUser.layer.masksToBounds = YES;
    [self.imgAvatarUser layoutIfNeeded];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserProfileTableViewCell"];
    UserTimeline *currentTime = self.results[indexPath.section];
    self.timeline = currentTime;
    NSString *linkAvatar = [NSString stringWithFormat:@"%@" , currentTime.authorAvatar];
    [cell.imgAvatar sd_setImageWithURL:[NSURL URLWithString:[linkAvatar stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                      placeholderImage:[UIImage imageNamed:@"1"]];
    cell.lblUsername.text = currentTime.authorName;
    cell.lblLocation.text = currentTime.location;
    NSDate *date = [NSDate date];
    
    cell.lblNumberLike.text = [NSString stringWithFormat:@"%ld" , (long)currentTime.number_likes];
    cell.lblNumberComment.text = [NSString stringWithFormat:@"%ld" , (long)currentTime.number_comment];
    long long time =  [@(floor([date timeIntervalSince1970] * 1000)) longLongValue] - [currentTime.created longLongValue];
    cell.lblTime.text = [NSString stringWithFormat:@"%lld ngày trước" , time/86400000];
    cell.contentView.userInteractionEnabled = true;
    if(currentTime.is_like){
        [cell.btnLike setImage:[UIImage imageNamed:@"liked"] forState:UIControlStateNormal];
    }else [cell.btnLike setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(currentTime.image_groups.count > 0){
        ImageGroup *group = [MTLJSONAdapter modelOfClass:[ImageGroup class]
                                      fromJSONDictionary:currentTime.image_groups[0]
                                                   error:nil];
        if(group.photos.count > 0){
            NSString *url = group.photos[0];
            NSString *match = @"upload/";
            NSString *pre;
            NSString *last;
            NSScanner *scanner = [NSScanner scannerWithString:url];
            [scanner scanUpToString:match intoString:&pre];
            [scanner scanString:match intoString:nil];
            last = [url substringFromIndex:scanner.scanLocation];
            NSMutableString *mu = [NSMutableString stringWithString:pre];
            [mu insertString:@"s" atIndex:4];
            NSString *newUrl = [NSString stringWithFormat:@"%@upload/w_%d,h_%d,c_fit/%@" ,mu ,(int)[UIScreen mainScreen].bounds.size.width,(int)[UIScreen mainScreen].bounds.size.width * 4 /7 , last];
            [cell.image sd_setImageWithURL:[NSURL URLWithString:newUrl]
                          placeholderImage:[UIImage imageNamed:@"1"]];

        }
        cell.lblTitle.text = currentTime.title;
        cell.lblContent.text = group.title;
        NSString * htmlString = group.title;
        NSString *stringToLoad = [NSString stringWithFormat:@"<html> \n"
                                  "<head> \n"
                                  "<style type=\"text/css\"> \n"
                                  "body {font-family: \"%@\"; font-size: %lu;}\n"
                                  "</style> \n"
                                  "</head> \n"
                                  "<body>%@</body> \n"
                                  "</html>", @"HelveticaNeue", (unsigned long)[Utils fontSizeNormal], htmlString];
        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[stringToLoad dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        
        cell.lblContent.attributedText = attrStr;
    }
    [cell setNeedsLayout];
    cell.cellIndex = indexPath.section;
    cell.delegate = self;
    return cell;
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

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (IBAction)clickBtnFollow:(id)sender {
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    if(self.userProfile.is_follow == NO){
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
        NSString *url = [NSString stringWithFormat:@"http:210.245.95.50:6996/api/user/%@/follow",self.userID];
        [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        [_btnFollow setTitle:@"Unfollow" forState:UIControlStateNormal];
//        [_btnFollow layer].cornerRadius = [self.btnFollow layer].frame.size.height / 100;
        self.userProfile.is_follow = YES;

    }
    else{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
        NSString *url = [NSString stringWithFormat:@"http:210.245.95.50:6996/api/user/%@/follow",self.userID];
        [manager DELETE:url parameters:nil success:^(NSURLSessionTask *task , id responseObject){
            NSLog(@"%@" , responseObject);
        }failure:^(NSURLSessionTask *operation, NSError *error){
            NSLog(@"%@" , error);
        }];
        [_btnFollow setTitle:@"Follow" forState:UIControlStateNormal];
//        [_btnFollow layer].cornerRadius = [self.btnFollow layer].frame.size.height / 100;
        self.userProfile.is_follow = NO;
    }
}
#pragma mark - user tableview cell delegate
-(void)clickBtnLike:(NSInteger)cellIndex id:(id)sender{
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    UserTimeline *timeline = self.results[cellIndex];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:cellIndex];
    UserProfileTableViewCell *cell = (UserProfileTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
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
@end
