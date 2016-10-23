//
//  ViewController.m
//  Demo
//
//  Created by Trung Đức on 8/27/16.
//  Copyright © 2016 Trung Đức. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "SingleObject.h"
#import "Object.h"
#import "Comment.h"
#import "CommentCell.h"
#import "THChatInput.h"
#import "Profile.h"
#import "LoginViewController.h"
#import "MWPhotoBrowser.h"
@interface ViewController ()<SliceImageDelegate , HeaderCellDelegate , BottomCellDelegate,THChatInputDelegate,LoginViewControllerDelegate,MWPhotoBrowserDelegate>
@property NSInteger numberCell;
@property (nonatomic) UITapGestureRecognizer *tapRecognizer;
@property (strong, nonatomic) IBOutlet THChatInput *chatInput;
@property NSString *userAvatar;
@property NSString *userName;
@property int numberData;
@property NSMutableArray *photos;
@property NSMutableArray *thumbs;
@property int index;
@property (strong, nonatomic) IBOutlet UIView *emojiInputView;
@end
int indexCommnet;
@implementation ViewController
- (void)viewWillAppear:(BOOL)animated{
    
}
- (void)viewDidLoad {
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSLog(@"%@" , access_token);
    _numberData = 0;
    if(access_token.length < 1){
        LoginViewController *vc = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    [self getData];
    [self getComment];
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedView:)];
    [self.view addGestureRecognizer:tapper];
    indexCommnet = 0;
    _numberCell = 4;
    self.arrayComment = [[NSMutableArray alloc]init];
    NSLog(@"%ld" , (long)_numberCell);
    self.tableView.allowsSelection = NO;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.navigationItem.backBarButtonItem setTitle:@""];
    [self getUserInfo];
    [self setChatInput:nil];
    [self setEmojiInputView:nil];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                                         initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.tableView.estimatedRowHeight = 1000.0f;
}

-(void)dismissViewController{
    [self getData];
    [self getUserInfo];
    [self getComment];
}
-(void)getUserInfo{
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
            Profile *myProfile =  [MTLJSONAdapter modelOfClass:[Profile class]
                                    fromJSONDictionary:responseObject
                                                 error:nil];
            NSString *linkAvatar = [NSString stringWithFormat:@"%@" , myProfile.avatar];
            self.userAvatar = linkAvatar;
            self.userName = myProfile.name;
            UIImageView *myImageView = (UIImageView *)[self.view viewWithTag:990];
            
            [myImageView sd_setImageWithURL:[NSURL URLWithString:linkAvatar]
                              placeholderImage:[UIImage imageNamed:@"1"]
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     }];
            
        }
        else NSLog(@"%@" ,object.message);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}
- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    return NO;
}
- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [_chatInput resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - THChatInputDelegate
- (void)chat:(THChatInput*)input sendWasPressed:(NSString*)text
{
    NSLog(@"%@" , text);
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    NSDictionary *params = @{
                             @"content":text
                             };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
    NSString *url = [NSString stringWithFormat:@"http:210.245.95.50:6996/api/comment/%@",_idPost];
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        Comment *comment = [[Comment alloc]init];
        comment.authorAvatar = self.userAvatar;
        comment.authorName = self.userName;
        comment.content = text;
        NSDate *date = [NSDate date];
        comment.created = [NSNumber numberWithLongLong:[@(floor([date timeIntervalSince1970] * 1000)) longLongValue]];
//
        [self.arrayComment addObject:comment];
        _numberCell = 4 + 2 * self.detailPost.image_groups.count + self.arrayComment.count;
        [self.tableView reloadData];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

    UITextView *textView = (UITextView *)[self.view viewWithTag:991];
    textView.text = @"";
    [textView resignFirstResponder];
    
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
     [self scrollToCursorForTextView:textView];
}

- (void)chatShowEmojiInput:(THChatInput*)input
{
    _chatInput.textView.inputView = _chatInput.textView.inputView == nil ? _emojiInputView : nil;
    
    [_chatInput.textView reloadInputViews];
}
- (void)tappedView:(UITapGestureRecognizer*)tapper
{
    [_chatInput resignFirstResponder];
    UITextView *textView = (UITextView *)[self.view viewWithTag:991];
    [textView resignFirstResponder];
}
#pragma mark - TableView Datasource
-(void)getData{
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSLog(@"%@" , _idPost);
    [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
    NSString *url = [NSString stringWithFormat:@"http:210.245.95.50:6996/api/post/%@",self.idPost];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"%@" , responseObject);
        SingleObject *object= [MTLJSONAdapter modelOfClass:[SingleObject class]
                                  fromJSONDictionary:responseObject
                                               error:nil];
        if(object.code == 1){
            self.detailPost = [MTLJSONAdapter modelOfClass:[Timeline class]
                                        fromJSONDictionary:object.result
                                                     error:nil];

            _numberCell = 4 + 2 * self.detailPost.image_groups.count;
            _numberData++;
            if(_numberData >= 2){
//                [self.tableView reloadData];
            }
        }
        NSLog(@"%@" , object.message);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
-(void)getComment{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"http:210.245.95.50:6996/api/comment/%@",self.idPost];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        Object *object= [MTLJSONAdapter modelOfClass:[Object class]
                                        fromJSONDictionary:responseObject
                                                     error:nil];
        NSLog(@"%@" , responseObject);
        NSLog(@"result: %@" , object.result);
        if(object.code == 1){
            NSArray *comments = [MTLJSONAdapter modelsOfClass:[Comment class] fromJSONArray:object.result error:nil];
            for (Comment *timeline in comments) {
                [self.arrayComment addObject:timeline];
            }
            
            _numberCell = 4 + 2 * self.detailPost.image_groups.count + self.arrayComment.count;
            NSLog(@"%ld" , (long)_numberCell);
            _numberData++;
            if(_numberData >= 2){
                NSLog(@"number data: %d" , _numberData);
                [self.tableView reloadData];
            }
            
        }

        NSLog(@"%@" , object.message);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return _numberCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
        if (indexPath.row == 0) {
        HeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HeaderCell class])];
        
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([HeaderCell class]) owner:nil options:nil];
            cell = [nib lastObject];
        }
        cell.delegate = self;
                NSString *linkAvatar = [NSString stringWithFormat:@"%@" , self.detailPost.authorAvatar];
        
        [cell.imvUser sd_setImageWithURL:[NSURL URLWithString:[linkAvatar stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                          placeholderImage:[UIImage imageNamed:@"1"]];
        cell.lblUserName.text = self.detailPost.authorName;
        cell.lblAddress.text = self.detailPost.location;
        cell.isFollow = _detailPost.is_follow;
        UIButton *btnFollow = (UIButton *)[self.view viewWithTag:998];
        if(cell.isFollow){
            [btnFollow setTitle:@"Unfollow" forState:UIControlStateNormal];
            [btnFollow setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [[btnFollow layer] setBorderColor:[UIColor darkGrayColor].CGColor];
        }
        else{
            [btnFollow setTitle:@"Follow" forState:UIControlStateNormal];
            [btnFollow setTitleColor:[UIColor colorWithRed:74/255.0f green:138/255.0f blue:200/255.0f alpha:1] forState:UIControlStateNormal];
            [[btnFollow layer] setBorderColor:[UIColor colorWithRed:74/255.0f green:138/255.0f blue:200/255.0f alpha:1].CGColor];
        }
        return cell;
    } else if (indexPath.row == 1) {
        TextCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TextCell class])];
        
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([TextCell class]) owner:nil options:nil];
            cell = [nib lastObject];
        }
        
        cell.lblTitle.text = self.detailPost.title;
        [cell.lblTitle sizeToFit];
        return cell;
    }else if(indexPath.row % 2 == 0 && indexPath.row != 0 && indexPath.row < (2 + 2 * self.detailPost.image_groups.count)){
        TextContent *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TextContent class])];
        
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([TextContent class]) owner:nil options:nil];
            cell = [nib lastObject];
        }
        long index = (indexPath.row - 2)/2;
        
        ImageGroup *group = [MTLJSONAdapter modelOfClass:[ImageGroup class]
                                                          fromJSONDictionary:self.detailPost.image_groups[index]
                                                                       error:nil];

        NSLog(@"%@" , group.title);
         group.title = [group.title stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
        cell.lblContent.text = @"123"; // set text vs .text co khac gi nhau ko? k a! vao ben trong post detail di, r do a
        [cell.lblContent setText:group.title]; //file nao nhi? cai nay day a, file xib y' file layout do
        return cell;
    }
    
    else if (indexPath.row != 1 && indexPath.row < (2 + 2 * self.detailPost.image_groups.count) && indexPath.row%2 !=0 ) {
        SliceImageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SliceImageCell class])];
        
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([SliceImageCell class]) owner:nil options:nil];
            cell = [nib lastObject];
        }
        cell.delegate = self;
        long index = (indexPath.row - 3) / 2;
        
        cell.cellIndex = index;
        ImageGroup *group = [MTLJSONAdapter modelOfClass:[ImageGroup class]
                                      fromJSONDictionary:self.detailPost.image_groups[index]
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
            [photos addObject:newUrl];
        }

        [cell displayImages:photos];
        return cell;
    } else if (indexPath.row == (2 + 2 * self.detailPost.image_groups.count)) {
        DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DetailCell class])];
        
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([DetailCell class]) owner:nil options:nil];
            cell = [nib lastObject];
        }
        NSDate *date = [NSDate date];
        long long time =  [@(floor([date timeIntervalSince1970] * 1000)) longLongValue] - [_detailPost.time_created longLongValue];
        cell.lblTime.text = [NSString stringWithFormat:@"%lld ngày trước" , time/86400000];
        cell.lblNumberLike.text = [NSString stringWithFormat:@"%ld" , (long)self.detailPost.number_like];
        cell.lblNumberComment.text = [NSString stringWithFormat:@"%ld" , (long)self.detailPost.number_comment];
        
        return cell;
    }else if (indexPath.row == (2 + 2 * self.detailPost.image_groups.count) + 1) {
        BottomCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BottomCell class])];
        
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([BottomCell class]) owner:nil options:nil];
            cell = [nib lastObject];
        }
        cell.delegate = self;
        cell.isLike = _detailPost.is_like;
        if(cell.isLike){
            [cell.btnLike setImage:[UIImage imageNamed:@"liked"] forState:UIControlStateNormal];
        }else [cell.btnLike setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        return cell;
    }
    else {
        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CommentCell class])];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([CommentCell class]) owner:nil options:nil];
            cell = [nib lastObject];
        }
        [cell.contentView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [cell.contentView.layer setBorderWidth:0.3f];
        Comment *comment = self.arrayComment[indexPath.row - 4 - 2 * self.detailPost.image_groups.count];
        NSString *linkAvatar = [NSString stringWithFormat:@"%@" , comment.authorAvatar];
        [cell.imgCommentAvatar sd_setImageWithURL:[NSURL URLWithString:[linkAvatar stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                        placeholderImage:[UIImage imageNamed:@"1"]];
        cell.lblCommentName.text = comment.authorName;
        cell.lblCommentContent.text = comment.content;
        NSDate *date = [NSDate date];
        long long time =  [@(floor([date timeIntervalSince1970] * 1000)) longLongValue] - [comment.created longLongValue];
        cell.lblCommentTime.text = [NSString stringWithFormat:@"%lld ngày trước" , time/86400000];

        
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
}
#pragma mark - TableView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.row == 0) {
        return [UIScreen mainScreen].bounds.size.width* 13 / 64;
    } if (indexPath.row == 1) {
        return [UIScreen mainScreen].bounds.size.width* 3 / 32;
    }if(indexPath.row % 2 == 0 && indexPath.row != 0 && indexPath.row <(2 + 2 * self.detailPost.image_groups.count)){
        return UITableViewAutomaticDimension;
    }
    if (indexPath.row != 1 && indexPath.row <(2 + 2 * self.detailPost.image_groups.count) && indexPath.row%2!=0 ) {
        long index = (indexPath.row - 3) / 2;
        ImageGroup *group = [MTLJSONAdapter modelOfClass:[ImageGroup class]
                                      fromJSONDictionary:self.detailPost.image_groups[index]
                                                   error:nil];
        if(group.photos.count == 0){
            return 0;
        }
        else return self.view.frame.size.width * 4 / 7;
        
    } if (indexPath.row == (2 + 2 * self.detailPost.image_groups.count)) {
        return [UIScreen mainScreen].bounds.size.width* 3 / 32;
    } if(indexPath.row == (2 + 2 * self.detailPost.image_groups.count) + 1){
        return [UIScreen mainScreen].bounds.size.width / 8;
    }
    else {
        return UITableViewAutomaticDimension;
    }
}
#pragma mark - SliceImage delegate
-(void)didSelectedImage:(id)sender atIndex:(NSUInteger)index atCellIndex:(NSInteger)cellIndex{
    ImageGroup *group = [MTLJSONAdapter modelOfClass:[ImageGroup class]
                                  fromJSONDictionary:self.detailPost.image_groups[cellIndex]
                                               error:nil];
    NSMutableArray *photos = [[NSMutableArray alloc]init];
    for(NSString *url in group.photos){
        NSMutableString *mu = [NSMutableString stringWithString:url];
        [mu insertString:@"s" atIndex:4];
        [photos addObject:mu];
    }
    NSLog(@"%@" , photos);
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
-(void)didSelectedImage:(id)sender atIndex:(NSUInteger)index{
}
#pragma  mark - click button
-(void)clickBtnFollow{
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    UIButton *btnFollow = (UIButton *)[self.view viewWithTag:998];
    if(self.detailPost.is_follow == NO){
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
        NSString *url = [NSString stringWithFormat:@"http:210.245.95.50:6996/api/user/%@/follow",self.detailPost.authorID];
        [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        [btnFollow setTitle:@"Unfollow" forState:UIControlStateNormal];
        btnFollow.layer.cornerRadius;
        [btnFollow setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [[btnFollow layer] setBorderColor:[UIColor darkGrayColor].CGColor];
        self.detailPost.is_follow = YES;
    }
    else{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
        NSString *url = [NSString stringWithFormat:@"http:210.245.95.50:6996/api/user/%@/follow",self.detailPost.authorID];
        [manager DELETE:url parameters:nil success:^(NSURLSessionTask *task , id responseObject){
            NSLog(@"%@" , responseObject);
        }failure:^(NSURLSessionTask *operation, NSError *error){
            NSLog(@"%@" , error);
        }];
        [btnFollow setTitle:@"Follow" forState:UIControlStateNormal];
        [btnFollow setTitleColor:[UIColor colorWithRed:74/255.0f green:138/255.0f blue:200/255.0f alpha:1] forState:UIControlStateNormal];
        [[btnFollow layer] setBorderColor:[UIColor colorWithRed:74/255.0f green:138/255.0f blue:200/255.0f alpha:1].CGColor];
        self.detailPost.is_follow = NO;
    }
}
-(void)clickBtnLike{
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    UIButton *btnLike = (UIButton *)[self.view viewWithTag:999];
    if(self.detailPost.is_like == NO){
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
        NSString *url = [NSString stringWithFormat:@"http:210.245.95.50:6996/api/post/%@/like",self.detailPost.idPost];
        [manager POST:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        self.detailPost.is_like = YES;
        [btnLike setImage:[UIImage imageNamed:@"liked"] forState:UIControlStateNormal];
    }
    else{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
        NSString *url = [NSString stringWithFormat:@"http:210.245.95.50:6996/api/post/%@/unlike",self.detailPost.idPost];
        [manager DELETE:url parameters:nil success:^(NSURLSessionTask *task , id responseObject){
            NSLog(@"%@" , responseObject);
        }failure:^(NSURLSessionTask *operation, NSError *error){
            NSLog(@"%@" , error);
        }];
        self.detailPost.is_like = NO;
        [btnLike setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    }

}

#pragma mark -
- (void)keyboardWillShow:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.tableView.contentInset.top, 0.0, kbSize.height, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
}

- (void)keyboardWillHide:(NSNotification*)aNotification {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.35];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.tableView.contentInset.top, 0.0, 0.0, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    [UIView commitAnimations];
}
- (void)scrollToCursorForTextView: (UITextView*)textView {
    
    CGRect cursorRect = [textView caretRectForPosition:textView.selectedTextRange.start];
    
    cursorRect = [self.tableView convertRect:cursorRect fromView:textView];
    
    if (![self rectVisible:cursorRect]) {
        cursorRect.size.height += 8; // To add some space underneath the cursor
        [self.tableView scrollRectToVisible:cursorRect animated:YES];
    }
}
- (BOOL)rectVisible: (CGRect)rect {
    CGRect visibleRect;
    visibleRect.origin = self.tableView.contentOffset;
    visibleRect.origin.y += self.tableView.contentInset.top;
    visibleRect.size = self.tableView.bounds.size;
    visibleRect.size.height -= self.tableView.contentInset.top + self.tableView.contentInset.bottom;
    
    return CGRectContainsRect(visibleRect, rect);
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

@end
