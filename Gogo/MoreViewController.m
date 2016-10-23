//
//  MoreViewController.m
//  Gogo
//
//  Created by Thuong on 8/28/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "MoreViewController.h"
#import "MyProfileController.h"
#import "ExpandableTableView.h"
#import "MoreTableViewCell2.h"
#import "AFNetworking.h"
#import "SingleObject.h"
#import "LoginViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Object.h"
#import "Classfieds.h"
#import "UITableView+DragLoad.h"
#import "LoginViewController.h"
#import "HeaderView.h"
#import "CustomIOSAlertView.h"
#import "AddClassfied.h"
#define HEADER_VIEW_HEIGHT 28
@interface MoreViewController ()<AddClassfiedDelegate,CustomIOSAlertViewDelegate>{
    CustomIOSAlertView *alertView;
}
@property (strong, nonatomic) NSArray *cells;
@property (weak, nonatomic) IBOutlet ExpandableTableView *tableView;
@property (nonatomic, strong) NSArray *headers;
@property int dem;
@property NSMutableArray *results;
@property BOOL isHiden;
@end
int pageClassfied;
@implementation MoreViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _dem = 0;
    _isHiden = false;
    pageClassfied = 2;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self getData];
    [self getClassifieds];
    // Do any additional setup after loading the view.
    [self initSearchBar];
    self.cells = @[@"Cell 1", @"Cell 2", @"Cell 3", @"Cell 4", @"Cell 5", @"Cell 6", @"Cell 7", @"Cell 8"];
    self.headers = @[@"Rao vặt"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 200;
    self.tableView.allHeadersInitiallyCollapsed = YES;
    self.tableView.initiallyExpandedSection = 0;
//    [[self tableView] setBounces:NO];
    [self.tableView.layer removeAllAnimations];
    self.results = [[NSMutableArray alloc]init];
    UITapGestureRecognizer *tapGestureRecognizerUsername = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(usernameTapped)];
    tapGestureRecognizerUsername.numberOfTapsRequired = 1;
    [self.vUser addGestureRecognizer:tapGestureRecognizerUsername];
    self.vUser.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGestureRecognizerLogout = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logoutTapped)];
    tapGestureRecognizerLogout.numberOfTapsRequired = 1;
    [self.vLogout addGestureRecognizer:tapGestureRecognizerLogout];
    self.vLogout.userInteractionEnabled = YES;
    [_tableView setDragDelegate:self refreshDatePermanentKey:@"FriendList"];
    _tableView.showRefreshView = YES;
    [self setFont];
    alertView.closeOnTouchUpOutside = YES;
}
-(void)setFont{
    [_lblUserName setFont: [_lblUserName.font fontWithSize:[Utils fontSizeBig]]];
    [_lblFollowing setFont: [_lblFollowing.font fontWithSize:[Utils fontSizeBig]]];
    [_lblFollower setFont: [_lblFollower.font fontWithSize:[Utils fontSizeBig]]];
    [_lblLogout setFont: [_lblLogout.font fontWithSize:[Utils fontSizeBig]]];
    [_btnRaoVat.titleLabel setFont: [_btnRaoVat.titleLabel.font fontWithSize:[Utils fontSizeBig]]];
}
#pragma mark - tapGesture tapped
-(void)usernameTapped{
    MyProfileController *vc = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:@"MyProfileController"];
    vc.myProfile = self.myProfile;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)logoutTapped{
    NSString *typeLogin = [[NSUserDefaults standardUserDefaults]
                        stringForKey:@"typeLogin"];
    if([typeLogin  isEqual: @"facebook"]){
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logOut];
        [FBSDKAccessToken setCurrentAccessToken:nil];
    }
    else if([typeLogin  isEqual: @"google"]){
        [[GPPSignIn sharedInstance] signOut];
    }
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"access_token"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"typeLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    LoginViewController *vc = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)getData{
    NSString *userID = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"userID"];
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http:210.245.95.50:6996/api/user/%@" , userID]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        SingleObject *object = [MTLJSONAdapter modelOfClass:[SingleObject class]
                                   fromJSONDictionary:responseObject
                                                error:nil];
        NSLog(@"%@" , object);
        if(object.code == 1){
            _myProfile =  [MTLJSONAdapter modelOfClass:[Profile class]
                                    fromJSONDictionary:responseObject
                                                 error:nil];
            NSLog(@"%@" , object.result);
            NSLog(@"%@" , _myProfile);
            NSString *linkAvatar = [NSString stringWithFormat:@"%@" , self.myProfile.avatar];

            [self.imgAvatar sd_setImageWithURL:[NSURL URLWithString:[linkAvatar stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                              placeholderImage:[UIImage imageNamed:@"1"]];
            self.lblUserName.text = self.myProfile.name;

        }
        else NSLog(@"%@" ,object.message);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
-(void)getClassifieds{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"http:210.245.95.50:6996/api/classified?page=1"];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        Object *object = [MTLJSONAdapter modelOfClass:[Object class]
                                   fromJSONDictionary:responseObject
                                                error:nil];
        if(object.code == 1){
            self.results = [MTLJSONAdapter modelsOfClass:[Classfieds class] fromJSONArray:object.result error:nil];
            [self.tableView finishRefresh];
            [self.tableView reloadData];
        }
        else NSLog(@"%@" , object.message);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}
- (void)initSearchBar {
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.showsCancelButton = false;
    self.searchBar.placeholder = @"Tìm kiếm thông tin địa điểm";
    self.searchBar.delegate = self;
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.navigationItem.titleView = self.searchBar;
}
-(void)viewDidLayoutSubviews{
    self.imgAvatar.layer.cornerRadius = self.imgAvatar.frame.size.height /2 ;
    self.imgAvatar.layer.masksToBounds = YES;
    [self.imgAvatar layoutIfNeeded];
    [[self.vFollowing layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[self.vFollowing layer] setBorderWidth:0.3f];
    [[self.vUser layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[self.vUser layer] setBorderWidth:0.3f];
    [[self.vFollower layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[self.vFollower layer] setBorderWidth:0.3f];
    [[self.vLogout layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[self.vLogout layer] setBorderWidth:0.3f];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickBtnUser:(id)sender {
    MyProfileController *vc = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:@"MyProfileController"];
    vc.myProfile = self.myProfile;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MoreTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreTableViewCell2"];
    Classfieds *classFied = self.results[indexPath.row];
    NSString *linkAvatar = [NSString stringWithFormat:@"%@" , classFied.authorAvatar];
    [cell.imgAvatar sd_setImageWithURL:[NSURL URLWithString:[linkAvatar stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                      placeholderImage:[UIImage imageNamed:@"1"]];
    cell.lblTitle.text = classFied.title;
    cell.lblContent.text = classFied.content;
    NSDate *date = [NSDate date];
    double timestamp1 = [[NSDate date] timeIntervalSince1970];
    int64_t timeInMilisInt64 = (int64_t)(timestamp1*1000);
    NSString *nameAuthor = [NSString stringWithFormat:@"%@", classFied.authorName];
    long long time =  timeInMilisInt64 - [classFied.created longLongValue];
    cell.lblPoster.text = [NSString stringWithFormat:@"Được đăng bởi %@ %lld ngày trước" ,nameAuthor ,time/86400000];
    cell.lblLocation.text = [NSString stringWithFormat:@"%@" , classFied.location];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"section-%ld, row-%ld", (long)indexPath.section, (long)indexPath.row);
}
#pragma mark - Drag delegate methods

- (void)dragTableDidTriggerRefresh:(UITableView *)tableView
{
    [self getClassifieds];
    pageClassfied = 2;
}

- (void)dragTableRefreshCanceled:(UITableView *)tableView
{
    //cancel refresh request(generally network request) here
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishRefresh) object:nil];
}

- (void)dragTableDidTriggerLoadMore:(UITableView *)tableView
{
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
    NSString *url = [NSString stringWithFormat:@"http:210.245.95.50:6996/api/classified?page=%d" , pageClassfied];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        Object *object = [MTLJSONAdapter modelOfClass:[Object class]
                                   fromJSONDictionary:responseObject
                                                error:nil];
        if(object.code == 1){
            NSArray *array = [MTLJSONAdapter modelsOfClass:[Classfieds class] fromJSONArray:object.result error:nil];
            for(Classfieds *noti in array){
                [self.results addObject:noti];
            }
            pageClassfied++;
            [self.tableView finishLoadMore];
            [self.tableView reloadData];
        }
        else NSLog(@"%@" , object.message);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (void)dragTableLoadMoreCanceled:(UITableView *)tableView
{
    //cancel load more request(generally network request) here
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishLoadMore) object:nil];
}


- (IBAction)clickBtnRaoVat:(id)sender {
    if(_isHiden == NO){
        self.tableView.hidden = YES;
        self.isHiden = YES;
    }else{
        self.tableView.hidden = NO;
        self.isHiden = NO;
    }
}

- (IBAction)clickBtnAdd:(id)sender {
    AddClassfied *detailView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([AddClassfied class]) owner:nil options:nil] objectAtIndex:0];
    detailView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * 723/928 + 40);
    detailView.delegate = self;
    
    alertView = [[CustomIOSAlertView alloc] init];
    
    [alertView setContainerView:detailView];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:nil]];
    [alertView setTintColor:[UIColor whiteColor]];
    [alertView setBackgroundColor:[UIColor colorWithRed:31 green:137 blue:255 alpha:1]];
    [alertView setDelegate:self];
    
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView1, int buttonIndex) {
    NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView1 tag]);
        [alertView1 close];
    }];
    alertView.parentView.userInteractionEnabled = YES;
    [alertView setUseMotionEffects:true];
    [alertView show];
    [alertView bringSubviewToFront:self.view];

}
-(void)clickBtnDangtin:(NSString *)title Content:(NSString *)content Location:(NSString *)location{
    NSLog(@"%@  %@  %@" , title , content , location);
    [alertView close];
    NSDictionary *params = @{
                             @"title":title,
                             @"content":content,
                             @"location":location
                             };
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [manager POST:@"http://210.245.95.50:6996/api/classified" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}
@end
