//
//  SearchViewController.h
//  Gogo
//
//  Created by Thuong on 8/27/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaiViet.h"
#import "NhaNghi.h"
#import "Ticket.h"

@interface SearchViewController : UIViewController<UISearchBarDelegate,UISearchDisplayDelegate , UITableViewDelegate , UITableViewDataSource >
@property BaiViet *vcBaiViet;
@property NhaNghi *vcNhaNghi;
@property Ticket *vcTicket;


@property (weak, nonatomic) IBOutlet UIView *viewBaiViet;
@property (weak, nonatomic) IBOutlet UIView *viewNhaNghi;
@property (weak, nonatomic) IBOutlet UIView *viewTicket;
@property (nonatomic) UITapGestureRecognizer *tapRecognizer;
@property (weak, nonatomic) IBOutlet UIView *viewLine;

@property (weak, nonatomic) IBOutlet UIButton *btnBaiviet;
- (IBAction)clickBaiviet:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnNhanghi;
- (IBAction)clickNhanghi:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnTeckit;
- (IBAction)clickTeckit:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewPush;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property  UISearchBar* searchBar;
@property NSMutableArray *results;
@end
