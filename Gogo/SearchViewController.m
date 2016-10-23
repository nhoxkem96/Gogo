//
//  SearchViewController.m
//  Gogo
//
//  Created by Thuong on 8/27/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "SearchViewController.h"
#import "Utils.h"
#import "AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Object.h"
#import "SearchModel.h"
#import "SearchTableViewCell.h"
#import "Utils.h"
#import "ViewController.h"
#import "LoginViewController.h"
@interface SearchViewController ()

@end

@implementation SearchViewController


int check = 0;
//- (void)viewWillAppear:(BOOL)animated{
//    NSString *access_token = [[NSUserDefaults standardUserDefaults]
//                              stringForKey:@"access_token"];
//    if(access_token.length < 1){
//        LoginViewController *vc = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:@"LoginViewController"];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    self.tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:self.tapRecognizer];
    self.results = [[NSArray alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (check == 0) {
        self.viewLine.backgroundColor = [UIColor colorWithRed:(1/255.f) green:(87/255.f) blue:(155/255.f) alpha:1.0];
        [Utils setXView:self.viewLine height:self.viewBaiViet.frame.origin.x +2];
        
    }
    if (check == 1) {
        self.viewLine.backgroundColor = [UIColor colorWithRed:(51/255.f) green:(105/255.f) blue:(30/255.f) alpha:1.0];
        [Utils setXView:self.viewLine height:self.viewNhaNghi.frame.origin.x];
        
    }
    if (check == 2) {
        self.viewLine.backgroundColor = [UIColor colorWithRed:(255/255.f) green:(193/255.f) blue:(7/255.f) alpha:1.0];
        [Utils setXView:self.viewLine height:self.viewTicket.frame.origin.x];
        
    }
    [self initSearchBar];
    
}
#pragma  mark - edit keyboard
- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    return NO;
}
- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.searchBar resignFirstResponder];
    [self.view endEditing:YES];
}
- (void)initSearchBar {
    _searchBar = [[UISearchBar alloc] init];
    self.searchBar.showsCancelButton = false;
    self.searchBar.placeholder = @"Tìm kiếm";
    self.searchBar.delegate = self;
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    [self.searchBar becomeFirstResponder];
    self.navigationItem.titleView = self.searchBar;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - show bai viet
- (IBAction)clickBaiviet:(id)sender {
    [self showBaiViet];
    check = 0;
}
- (IBAction)clickNhanghi:(id)sender {
    check = 1;
    [self showNhaNghi];
}
- (IBAction)clickTeckit:(id)sender {
    check = 1;
    [self showTicket];
}


- (void)showBaiViet
{
    [_btnBaiviet setTitleColor:[UIColor colorWithRed:(22/255.f) green:(79/255.f) blue:(122/255.f) alpha:1.0] forState:UIControlStateNormal];
    [_btnNhanghi setTitleColor:[UIColor colorWithRed:(0/255.f) green:(0/255.f) blue:(0/255.f) alpha:1.0] forState:UIControlStateNormal];
    [_btnTeckit setTitleColor:[UIColor colorWithRed:(0/255.f) green:(0/255.f) blue:(0/255.f) alpha:1.0] forState:UIControlStateNormal];
    
    [Utils setXView:self.viewLine height:self.viewBaiViet.frame.origin.x];
}
- (void)showNhaNghi
{
    [_btnBaiviet setTitleColor:[UIColor colorWithRed:(0/255.f) green:(0/255.f) blue:(0/255.f) alpha:1.0] forState:UIControlStateNormal];
    [_btnNhanghi setTitleColor:[UIColor colorWithRed:(22/255.f) green:(79/255.f) blue:(122/255.f) alpha:1.0] forState:UIControlStateNormal];
    [_btnTeckit setTitleColor:[UIColor colorWithRed:(0/255.f) green:(0/255.f) blue:(0/255.f) alpha:1.0] forState:UIControlStateNormal];
    [Utils setXView:self.viewLine height:self.viewNhaNghi.frame.origin.x];
}
- (void)showTicket
{
    [_btnBaiviet setTitleColor:[UIColor colorWithRed:(0/255.f) green:(0/255.f) blue:(0/255.f) alpha:1.0] forState:UIControlStateNormal];
    [_btnNhanghi setTitleColor:[UIColor colorWithRed:(0/255.f) green:(0/255.f) blue:(0/255.f) alpha:1.0] forState:UIControlStateNormal];
    [_btnTeckit setTitleColor:[UIColor colorWithRed:(22/255.f) green:(79/255.f) blue:(122/255.f) alpha:1.0] forState:UIControlStateNormal];
    [Utils setXView:self.viewLine height:self.viewTicket.frame.origin.x];
}
#pragma mark - searchBar delegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(check == 0){
        NSString *loadNew = [NSString stringWithFormat:@"http:210.245.95.50:6996/api/search/post?keyword=%@&page=1" , searchText];
        NSLog(@"%@" , loadNew);
        NSURL *URL = [NSURL URLWithString:[loadNew stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            Object *object = [MTLJSONAdapter modelOfClass:[Object class]
                                       fromJSONDictionary:responseObject
                                                    error:nil];
            if(object.code == 1){
                NSArray *results = [MTLJSONAdapter modelsOfClass:[SearchModel class] fromJSONArray:object.result error:nil];
                self.results = results;
                [self.tableView reloadData];
                NSLog(@"success");
            }
            else NSLog(@"%@" , object.message);
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:YES animated:NO];
    for (UIView *view in searchBar.subviews)
    {
        for (id subview in view.subviews)
        {
            if ( [subview isKindOfClass:[UIButton class]] )
            {
                [subview setEnabled:YES];
                UIButton *cancelButton = (UIButton*)subview;
                [cancelButton setTitle:@"Hủy" forState:UIControlStateNormal];
                
                
                NSLog(@"enableCancelButton");
                return;
            }
        }
    }
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [self.searchBar setShowsCancelButton:NO animated:NO];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    [self.results removeAllObjects];
    [self.tableView reloadData];
}

#pragma  mark - tableview
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchTableViewCell"];
    SearchModel *search = self.results[indexPath.row];
    NSString *linkAvatar = [NSString stringWithFormat:@"%@" , search.avatar];

    [cell.imgAvatar sd_setImageWithURL:[NSURL URLWithString:[linkAvatar stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                      placeholderImage:[UIImage imageNamed:@"1"]];
    cell.lblTitle.text = search.title;
    cell.lblNamePost.text = search.author_name;
    NSString *number_like = [NSString stringWithFormat:@"%@" , search.numberLike];
    cell.lblNumberLike.text = number_like;
    NSString *number_comment = [NSString stringWithFormat:@"%@" , search.numberComment];
    cell.lblNumberComment.text = number_comment;

    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.results.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UIScreen mainScreen].bounds.size.height * 35 / 284;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchModel *search = self.results[indexPath.row];
    ViewController *vc = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:@"ViewController"];
    vc.idPost = search.postID;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
