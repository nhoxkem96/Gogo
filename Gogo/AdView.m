//
//  AdView.m
//  Gogo
//
//  Created by Thuong on 9/5/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "AdView.h"
#import "MoreTableViewCell2.h"
@interface AdView ()<UITableViewDataSource , UITableViewDelegate>

@end

@implementation AdView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    MoreTableViewCell2 *cell2 = [tableView dequeueReusableCellWithIdentifier:@"MoreTableViewCell2"];
    NSString * htmlString;
    NSString * htmlString2;
    if(indexPath.row == 0){
        //[[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        cell2.imgAvatar.image = [UIImage imageNamed:@"avatar.jpg"];
        cell2.lblTitle.text = @"Pass lại cặp vé khứ hồi Hà nội - Đà nẵng 15/8-20/8";
        htmlString = @"<html><body><style>body{font-size:15px;}</style>Mình có cặp vé khứ hồi bay ngày 15/8 về 20/8 giờ không đi...<font color=blue>Đọc tiếp</font> </body></html>";
        
        cell2.lblContent.attributedText = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        
        
        htmlString2 = @"<html><body><style>body{font-size:13px;}</style>Đăng bởi <b>Hang Tran</b> 30 phút trước </body></html>";
        cell2.lblPoster.attributedText = [[NSAttributedString alloc] initWithData:[htmlString2 dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        cell2.lblLocation.text = @"HaNoi,VietNam";
    }
    else if(indexPath.row == 1){
        cell2.imgAvatar.image = [UIImage imageNamed:@"avatar.jpg"];
        cell2.lblTitle.text = @"Đồ phượt thủ cực chất mới cập nhật";
        htmlString = @"<html><body><style>body{font-size:15px;}</style>Mọi người qua 454 Bạch Mai, Hai Bà Trưng ,Hà Nội xem...<font color=blue>Đọc tiếp</font> </body></html>";
        cell2.lblContent.attributedText = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        htmlString2 = @"<html><body><style>body{font-size:13px;}</style>Đăng bởi <b>Duc Nguyen</b> 45 phút trước </body></html>";
        cell2.lblPoster.attributedText = [[NSAttributedString alloc] initWithData:[htmlString2 dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        cell2.lblLocation.text = @"HaNoi,VietNam";
    }
    return cell2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MoreTableViewCell2 *cell2 = [tableView dequeueReusableCellWithIdentifier:@"MoreTableViewCell2"];
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
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
