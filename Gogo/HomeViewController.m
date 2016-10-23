//
//  HomeViewController.m
//  Gogo
//
//  Created by Thuong on 8/24/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableviewCell.h"
#import <TLYShyNavBar/TLYShyNavBarManager.h>
#import "LoginViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UITableView+DragLoad.h"
#import "UserProfileViewController.h"
#import "MWPhotoBrowser.h"
@interface HomeViewController ()<HomeTableviewCellDelegate, LoginViewControllerDelegate,MWPhotoBrowserDelegate>
@property int indexReload;
@property NSString *access_token;
@property LoginViewController *vc;
@property id numberNotiNotSeen;
@property NSMutableArray *photos;
@property NSMutableArray *thumbs;
@end
@implementation HomeViewController
-(instancetype)init {
    if ((self = [super init])) {
        self.results = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    _access_token = [[NSUserDefaults standardUserDefaults]
                     stringForKey:@"access_token"];
    
    [self initSearchBar];
    self.shyNavBarManager.scrollView = self.homeTableview;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.homeTableview.rowHeight = UITableViewAutomaticDimension;
//    [[self homeTableview] setBounces:NO];
    [self getData];
    [_homeTableview setDragDelegate:self refreshDatePermanentKey:@"FriendList"];
    _homeTableview.showRefreshView = YES;
    self.vc = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    self.vc.delegate = self;
    UITabBarController *tabBarController = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController ;
    [tabBarController setDelegate:self];
    
    
}
-(void)getData{
    NSString *string = [NSString stringWithFormat:@"access_token %@" , _access_token];
    if(_access_token.length > 1){
        
        NSURL *URL = [NSURL URLWithString:@"http:210.245.95.50:6996/api/timeline"];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
        [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            self.object = [MTLJSONAdapter modelOfClass:[Object class]
                                    fromJSONDictionary:responseObject
                                                 error:nil];
            if(self.object.code == 1){
                self.results = [MTLJSONAdapter modelsOfClass:[Timeline class] fromJSONArray:self.object.result error:nil];
                [self.homeTableview reloadData];
            }
            else NSLog(@"%@" , self.object.message);
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
    else {
        NSURL *URL = [NSURL URLWithString:@"http:210.245.95.50:6996/api/timeline"];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSLog(@"%@" ,responseObject);
            self.object = [MTLJSONAdapter modelOfClass:[Object class]
                                    fromJSONDictionary:responseObject
                                                 error:nil];
            if(self.object.code == 1){
                self.results = [MTLJSONAdapter modelsOfClass:[Timeline class] fromJSONArray:self.object.result error:nil];
                [self.homeTableview reloadData];
            }
            else NSLog(@"%@" , self.object.message);
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
    if(_access_token.length > 1){
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
        NSString *url = [NSString stringWithFormat:@"http:210.245.95.50:6996/api/notifications?page=1"];
        [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            _numberNotiNotSeen = [responseObject objectForKey:@"number_have_not_seen"];
            if([_numberNotiNotSeen integerValue] > 0 ){
                [[self.tabBarController.tabBar.items objectAtIndex:3] setBadgeValue:[NSString stringWithFormat:@"%@" , _numberNotiNotSeen]];
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }

}
- (void)initSearchBar {
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.showsCancelButton = false;
    searchBar.placeholder = @"Tìm kiếm thông tin địa điểm";
    searchBar.delegate = self;
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.navigationItem.titleView = searchBar;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Control datasource

- (void)finishRefresh
{
    [_homeTableview finishRefresh];
    [_homeTableview reloadData];
}

- (void)finishLoadMore
{
    [_homeTableview finishLoadMore];
    [_homeTableview reloadData];
}

#pragma mark - Drag delegate methods

- (void)dragTableDidTriggerRefresh:(UITableView *)tableView
{
    NSString *string = [NSString stringWithFormat:@"access_token %@" , _access_token];
    if(_access_token.length > 1){
        
        NSURL *URL = [NSURL URLWithString:@"http:210.245.95.50:6996/api/timeline"];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
        [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            self.object = [MTLJSONAdapter modelOfClass:[Object class]
                                    fromJSONDictionary:responseObject
                                                 error:nil];
            if(self.object.code == 1){
                self.results = [MTLJSONAdapter modelsOfClass:[Timeline class] fromJSONArray:self.object.result error:nil];
                [self.homeTableview reloadData];
            }
            else NSLog(@"%@" , self.object.message);
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
    else {
        NSURL *URL = [NSURL URLWithString:@"http:210.245.95.50:6996/api/timeline"];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSLog(@"%@" ,responseObject);
            self.object = [MTLJSONAdapter modelOfClass:[Object class]
                                    fromJSONDictionary:responseObject
                                                 error:nil];
            if(self.object.code == 1){
                self.results = [MTLJSONAdapter modelsOfClass:[Timeline class] fromJSONArray:self.object.result error:nil];
                [self.homeTableview reloadData];
            }
            else NSLog(@"%@" , self.object.message);
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
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
    //send load more request(generally network request) here
    NSLog(@"loadmore");
    NSString *loadMore = [NSString stringWithFormat:@"http:210.245.95.50:6996/api/timeline?last_time=%@" , self.timeline.time_created];
    NSLog(@"%@" , loadMore);
    NSURL *URL = [NSURL URLWithString:[loadMore stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if(_access_token.length > 1){
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
        [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            self.object = [MTLJSONAdapter modelOfClass:[Object class]
                                    fromJSONDictionary:responseObject
                                                 error:nil];
            if(self.object.code == 1){
                NSArray *more = [MTLJSONAdapter modelsOfClass:[Timeline class] fromJSONArray:self.object.result error:nil];
                for (Timeline *timeline in more) {
                    [self.results addObject:timeline];
                }
                [_homeTableview finishLoadMore];
                [self.homeTableview reloadData];
            }
            else NSLog(@"%@" , self.object.message);
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
    else{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            self.object = [MTLJSONAdapter modelOfClass:[Object class]
                                    fromJSONDictionary:responseObject
                                                 error:nil];
            if(self.object.code == 1){
                NSArray *more = [MTLJSONAdapter modelsOfClass:[Timeline class] fromJSONArray:self.object.result error:nil];
                for (Timeline *timeline in more) {
                    [self.results addObject:timeline];
                }
                [_homeTableview finishLoadMore];
                [self.homeTableview reloadData];
            }
            else NSLog(@"%@" , self.object.message);
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
    

//    [self performSelector:@selector(finishLoadMore) withObject:nil afterDelay:2];
}

- (void)dragTableLoadMoreCanceled:(UITableView *)tableView
{
    //cancel load more request(generally network request) here
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishLoadMore) object:nil];
}


#pragma  mark - tableview Cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeTableviewCell *cell = (HomeTableviewCell*)[tableView dequeueReusableCellWithIdentifier:@"HomeTableViewCell"];
    Timeline *currentTime = self.results[indexPath.section];
    self.timeline = currentTime;
    NSString *linkAvatar = [NSString stringWithFormat:@"%@" , currentTime.authorAvatar];
    [cell.imgAvatar sd_setImageWithURL:[NSURL URLWithString:[linkAvatar stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                      placeholderImage:[UIImage imageNamed:@"1"]];
    cell.lblUserName.text = currentTime.authorName;
    cell.lblLocation.text = currentTime.location;
    NSString * timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
    NSLog(@"%@", timestamp);
    NSDate *date = [NSDate date];
    double timestamp1 = [[NSDate date] timeIntervalSince1970];
    int64_t timeInMilisInt64 = (int64_t)(timestamp1*1000);
    cell.lblNumberLike.text = [NSString stringWithFormat:@"%ld" , (long)currentTime.number_like];
    cell.lblNumberComment.text = [NSString stringWithFormat:@"%ld" , (long)currentTime.number_comment];
    cell.lblNumberFollow.text = [NSString stringWithFormat:@"%@" , currentTime.number_follow];
    long long time =  timeInMilisInt64 - [currentTime.time_created longLongValue];
    cell.lblTime.text = [NSString stringWithFormat:@"%lld ngày trước" , time/86400000];
    cell.delegate = self;
    cell.cellIndex = indexPath.section;
    cell.contentView.userInteractionEnabled = true;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lblTitle.text = currentTime.title;
    cell.isLike = currentTime.is_like;
    cell.isFollow = currentTime.is_follow;
    
    if(cell.isFollow){
        [cell.btnFollow setTitle:@"Unfollow" forState:UIControlStateNormal];
        [cell.btnFollow setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [[cell.btnFollow layer] setBorderColor:[UIColor darkGrayColor].CGColor];
        [cell.btnFollow layer].cornerRadius = 3;
    }
    else{
        [cell.btnFollow setTitle:@"Follow" forState:UIControlStateNormal];
        [cell.btnFollow setTitleColor:[UIColor colorWithRed:74/255.0f green:138/255.0f blue:200/255.0f alpha:1] forState:UIControlStateNormal];
        [[cell.btnFollow layer] setBorderColor:[UIColor colorWithRed:74/255.0f green:138/255.0f blue:200/255.0f alpha:1].CGColor];
        [cell.btnFollow layer].cornerRadius = 3;
    }
    if(cell.isLike){
        [cell.btnLike setImage:[UIImage imageNamed:@"liked"] forState:UIControlStateNormal];
    }else [cell.btnLike setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    
    if(currentTime.image_groups.count > 0){
        ImageGroup *group = [MTLJSONAdapter modelOfClass:[ImageGroup class]
              fromJSONDictionary:currentTime.image_groups[0]
                           error:nil];
        NSMutableArray *photos = [[NSMutableArray alloc]init];
        for(NSString *url in group.photos){
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
            NSLog(@"%@" , newUrl);
            [photos addObject:newUrl];
        }
        [cell displayImages:photos];
        cell.lblTitle.text = currentTime.title;
        cell.lblContent.text = group.title;
//        NSString * htmlString = group.title;
//        NSString *stringToLoad = [NSString stringWithFormat:@"<html> \n"
//                                  "<head> \n"
//                                  "<style type=\"text/css\"> \n"
//                                  "body {font-family: \"%@\"; font-size: %lu;}\n"
//                                  "</style> \n"
//                                  "</head> \n"
//                                  "<body>%@</body> \n"
//                                  "</html>", @"HelveticaNeue", (unsigned long)[Utils fontSizeNormal], htmlString];
//        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[stringToLoad dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//        
//        cell.lblContent.attributedText = attrStr;
        group.title = [group.title stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
        cell.lblContent.text = group.title;
    }
    [cell setNeedsLayout];
//    [cell layoutIfNeeded];
    
    return cell;
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

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (CGFloat)getLabelHeight:(UILabel*)label
{
    CGSize constraint = CGSizeMake(label.frame.size.width, CGFLOAT_MAX);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:label.font}
                                                  context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 0;
    }
    else return 10.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

#pragma mark - label tapped
-(void)contentTapped:(NSInteger)cellIndex{
    if(_access_token.length > 1){
        ViewController *vc = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:@"ViewController"];
        Timeline *timeline = self.results[cellIndex];
        vc.idPost = timeline.idPost;
        _indexReload = cellIndex;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        [self presentViewController:self.vc animated:NO completion:nil];
    }

}
-(void)usernameTapped:(NSInteger)cellIndex{
    if(_access_token.length > 1){
        UserProfileViewController *vc = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:@"UserProfileViewController"];
        Timeline *timeline = self.results[cellIndex];
        vc.userID = timeline.authorID;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else [self presentViewController:self.vc animated:NO completion:nil];;
     
}

#pragma mark - 
-(void)didSelectedImage:(id)sender atIndex:(NSUInteger)index atSection:(NSInteger)cellIndex{
    
    Timeline *timeline = self.results[cellIndex];
    ImageGroup *group = [MTLJSONAdapter modelOfClass:[ImageGroup class]
                                  fromJSONDictionary:timeline.image_groups[0]
                                               error:nil];
    NSMutableArray *photos = [[NSMutableArray alloc]init];
    for(NSString *url in group.photos){
        NSMutableString *mu = [NSMutableString stringWithString:url];
        [mu insertString:@"s" atIndex:4];
        [photos addObject:mu];
    }
    self.thumbs = [[NSMutableArray alloc]init];
    self.photos = [[NSMutableArray alloc]init];
    for(int i = 0; i < photos.count ; i++){
        [_photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:photos[i]]]];
        [_thumbs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:photos[i]]]];
    }
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.zoomPhotosToFill = YES;
    browser.alwaysShowControls = NO;
    browser.enableGrid = YES;
    browser.startOnGrid = NO;
    browser.autoPlayOnAppear = NO;
    [browser setCurrentPhotoIndex:index];
    
    // Present
    [self.navigationController pushViewController:browser animated:YES];
    
    // Manipulate
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
}
-(void)clickBtnComment:(NSInteger)cellIndex{
    if(_access_token.length > 1){
        ViewController *vc = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:@"ViewController"];
        Timeline *timeline = self.results[cellIndex];
        vc.idPost = timeline.idPost;
        _indexReload = cellIndex;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
//         [self.navigationController pushViewController:self.vc animated:YES];
        [self presentViewController:self.vc animated:NO completion:nil];
    }
}
-(void)clickBtnReport:(NSInteger)cellIndex{
    Timeline *timeline = self.results[cellIndex];
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    NSLog(@"%@", string);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
    NSString *url = [NSString stringWithFormat:@"210.245.95.50:6996/api/post/%@/report",timeline.idPost];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}
-(void)clickBtnLike:(NSInteger)cellIndex id:(id)sender{
    
    
    
    
    
    
    
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    NSLog(@"%@" , access_token);
    Timeline *timeline = self.results[cellIndex];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:cellIndex];
    if(_access_token.length > 1){
        HomeTableviewCell *cell = (HomeTableviewCell *)[_homeTableview cellForRowAtIndexPath:indexPath];
        if(cell.isLike == NO){
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
            NSString *url = [NSString stringWithFormat:@"http:210.245.95.50:6996/api/post/%@/like",timeline.idPost];
            [manager POST:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];
            cell.isLike = YES;
            [cell.btnLike setImage:[UIImage imageNamed:@"liked"] forState:UIControlStateNormal];
            timeline.is_like = YES;
            cell.lblNumberLike.text = [NSString stringWithFormat:@"%d" , timeline.number_like + 1];
            timeline.number_like ++;
            self.results[cellIndex] = timeline;
        }
        else{
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
            NSString *url = [NSString stringWithFormat:@"http:210.245.95.50:6996/api/post/%@/unlike",timeline.idPost];
            [manager DELETE:url parameters:nil success:^(NSURLSessionTask *task , id responseObject){
                NSLog(@"%@" , responseObject);
            }failure:^(NSURLSessionTask *operation, NSError *error){
                NSLog(@"%@" , error);
            }];
            cell.isLike = NO;
            [cell.btnLike setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
            timeline.is_like = NO;
            cell.lblNumberLike.text = [NSString stringWithFormat:@"%ld" , timeline.number_like - 1];
            timeline.number_like --;
            self.results[cellIndex] = timeline;
        }

    }
    else{
        
        [self presentViewController:self.vc animated:NO completion:nil];
    }
}
-(void)clickBtnFollow:(NSInteger)cellIndex{
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    Timeline *timeline = self.results[cellIndex];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:cellIndex];
    HomeTableviewCell *cell = (HomeTableviewCell *)[_homeTableview cellForRowAtIndexPath:indexPath];
    if(cell.isFollow == NO){
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
        NSString *url = [NSString stringWithFormat:@"http:210.245.95.50:6996/api/post/%@/follow",timeline.idPost];
        [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        cell.isFollow = YES;
        [cell.btnFollow setTitle:@"Unfollow" forState:UIControlStateNormal];
        [cell.btnFollow setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [[cell.btnFollow layer] setBorderColor:[UIColor darkGrayColor].CGColor];
        int x = [timeline.number_follow intValue];
        cell.lblNumberFollow.text = [NSString stringWithFormat:@"%d" , x + 1];
        timeline.number_follow = [NSNumber numberWithInt:x+1];
        [cell.btnFollow layer].cornerRadius = 3;
        timeline.is_follow = YES;
        self.results[cellIndex] = timeline;
    }
    else{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
        NSString *url = [NSString stringWithFormat:@"http:210.245.95.50:6996/api/post/%@/unfollow",timeline.idPost];
        [manager DELETE:url parameters:nil success:^(NSURLSessionTask *task , id responseObject){
            NSLog(@"%@" , responseObject);
        }failure:^(NSURLSessionTask *operation, NSError *error){
            NSLog(@"%@" , error);
        }];
        cell.isFollow = NO;
        [cell.btnFollow setTitle:@"Follow" forState:UIControlStateNormal];
        [cell.btnFollow setTitleColor:[UIColor colorWithRed:74/255.0f green:138/255.0f blue:200/255.0f alpha:1] forState:UIControlStateNormal];
        [[cell.btnFollow layer] setBorderColor:[UIColor colorWithRed:74/255.0f green:138/255.0f blue:200/255.0f alpha:1].CGColor];
        [cell.btnFollow layer].cornerRadius = 3;
        timeline.is_follow = NO;
        int x = [timeline.number_follow intValue];
        cell.lblNumberFollow.text = [NSString stringWithFormat:@"%d" , x - 1];
        timeline.number_follow = [NSNumber numberWithInt:x-1];
        self.results[cellIndex] = timeline;

    }
}
#pragma mark - 
-(void)dismissViewController{
    _access_token = [[NSUserDefaults standardUserDefaults]
                     stringForKey:@"access_token"];
    [self.results removeAllObjects];
    [self getData];
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
}
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if(_access_token.length < 1){
        [self.tabBarController setSelectedIndex:0];
        [self presentViewController:self.vc animated:NO completion:nil];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [self.homeTableview scrollsToTop];
}
#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _thumbs.count)
        return [_thumbs objectAtIndex:index];
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}
- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark searchBar delegate-
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self.tabBarController setSelectedIndex:1];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
