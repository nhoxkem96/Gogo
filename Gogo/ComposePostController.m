//
//  ComposePostController.m
//  Gogo
//
//  Created by Thuong on 9/10/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "ComposePostController.h"
#import "TopView.h"
#import "BotView.h"
#import "DetailView.h"
#import "TextViewContent.h"
#import "CollectionView.h"
#import "MyURL.h"
#import "Image_Groups_Post.h"
#import "AssetsLibrary/AssetsLibrary.h"
#import "JSONModelLib.h"
#import "JSONModel.h"
#import "PostModel.h"
#import "Cloudinary.h"
#import "LoginViewController.h"
#import "CustomIOSAlertView.h"
#import "AlertView.h"
@interface ComposePostController ()<CollectionViewDelegate , BotViewDelegate ,CLUploaderDelegate, CustomIOSAlertViewDelegate , UITextFieldDelegate , AlearViewDelegate>
@property UIImagePickerController *imagePickerController;
@property NSString *stringTitle;
@property CGPoint offset;
@end

NSInteger clickAt = 0;
CustomIOSAlertView *alertView;
@implementation ComposePostController
+ (ComposePostController *)sharedInstance
{
    static ComposePostController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ComposePostController alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrayContentGroup =  [[NSMutableArray alloc] init];
    [self.arrayContentGroup addObject:@""];
    self.numberGroup = 3;
    // Do any additional setup after loading the view.
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    self.tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:self.tapRecognizer];
    [alertView addGestureRecognizer:self.tapRecognizer];
    alertView.closeOnTouchUpOutside = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [[self tableView] setBounces:NO];
    [self setDefinesPresentationContext:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.arrayImage = [[NSMutableArray alloc]init];
    self.arrayInfoImage = [NSMutableArray new];
    self.arrayURL = [NSMutableArray new];
    UIView *firstViewUIView = [[[NSBundle mainBundle] loadNibNamed:@"PostView" owner:self options:nil] firstObject];
    [self.postView addSubview:firstViewUIView];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}


- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    return NO;
}
- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
    [alertView close];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return _numberGroup;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.row == 0) {
        TopView *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TopView class])];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([TopView class]) owner:nil options:nil];
            cell = [nib lastObject];
        }
        cell.txtTitle.text = self.stringTitle;
        cell.txtTitle.delegate = self;
        return cell;
    }else  if (indexPath.row == _numberGroup - 1  ) {
        BotView *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BotView class])];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([BotView class]) owner:nil options:nil];
            cell = [nib lastObject];
        }
        cell.delegate = self;
        return cell;
    }else if((indexPath.row % 2 == 0) && (indexPath.row != _numberGroup-2) && (indexPath.row != 0)){
        CollectionView *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CollectionView class])];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([CollectionView class]) owner:nil options:nil];
            cell = [nib lastObject]; 
        }
        long index = (indexPath.row - 2)/2;
        cell.delegate = self;
        cell.arrayImage = self.arrayImage[index];
        cell.cellIndex = indexPath.row;
        return cell;
    }
    
    else if((indexPath.row % 2 == 1) && (indexPath.row != _numberGroup-1)){
        TextViewContent *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TextViewContent class])];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([TextViewContent class]) owner:nil options:nil];
            cell = [nib lastObject];
        }
        cell.txtContent.delegate = self;
        long index = (indexPath.row - 1)/2;
        cell.txtContent.text = self.arrayContentGroup[index];
        cell.txtContent.contentInset = UIEdgeInsetsMake(8 , 0 , 0 , 0);
//        if(indexPath.row == _numberGroup - 2 && indexPath.row != 1 && [self.arrayContentGroup[index]  isEqual: @""]){
//            [cell.txtContent becomeFirstResponder];
//        }
        if ([cell.txtContent.text isEqualToString:@""]) {
            cell.txtContent.text = @"Nhập nội dung...";
            cell.txtContent.textColor = [UIColor lightGrayColor];
        }
        return cell;
    }
    else {
        return [UITableViewCell new];
    }

}

#pragma mark - TableView Delegate

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.row == 0) {
        return [UIScreen mainScreen].bounds.size.width / 4;
    }else if (indexPath.row == _numberGroup - 1) {
        return [UIScreen mainScreen].bounds.size.width *5/16;
    }else if((indexPath.row % 2 == 0) && (indexPath.row != _numberGroup-2) && (indexPath.row != 0)){
        return [UIScreen mainScreen].bounds.size.width / 3;
    }
    else{
        long index = (indexPath.row - 1)/2;
        
        UIFont *font = [UIFont systemFontOfSize:16.0];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:self.arrayContentGroup[index] attributes:attrsDictionary];
        if(_numberGroup > 3){
            return [self textViewHeightForAttributedText:attrString  andWidth:CGRectGetWidth(self.tableView.bounds)-30]+10;
        }
        else if([self textViewHeightForAttributedText:attrString  andWidth:CGRectGetWidth(self.tableView.bounds)-30]+10 > 250){
            return [self textViewHeightForAttributedText:attrString  andWidth:CGRectGetWidth(self.tableView.bounds)-30]+10;
        }
        else return 250;
    }
}

#pragma mark - textview delegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    UIView *containerView = [[[NSBundle mainBundle] loadNibNamed:@"PostView" owner:self options:nil] lastObject];
    textView.inputAccessoryView = containerView;
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    
    UITableViewCell *textFieldRowCell;
    textFieldRowCell = (UITableViewCell *) textView.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:textFieldRowCell];
    long index = (indexPath.row - 1)/2;
    NSString *string = textView.text;
    NSString *tmp = self.arrayContentGroup[index];
    UIFont *font = [UIFont systemFontOfSize:16.0];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:tmp attributes:attrsDictionary];
    
    NSAttributedString *attrString1 = [[NSAttributedString alloc] initWithString:string attributes:attrsDictionary];
    NSAttributedString *attrString2 = [[NSAttributedString alloc] initWithString:@"a" attributes:attrsDictionary];
    self.offset = self.tableView.contentOffset;
    if([self textViewHeightForAttributedText:attrString1  andWidth:CGRectGetWidth(self.tableView.bounds)-30]+10 > [self textViewHeightForAttributedText:attrString  andWidth:CGRectGetWidth(self.tableView.bounds)-30] && [self textViewHeightForAttributedText:attrString  andWidth:CGRectGetWidth(self.tableView.bounds)-30]+10 > [self textViewHeightForAttributedText:attrString2  andWidth:CGRectGetWidth(self.tableView.bounds)-30] + 9){
        [UIView setAnimationsEnabled:NO];
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        [self.tableView.layer removeAllAnimations];
        [self.tableView setContentOffset:CGPointMake(self.offset.x,self.offset.y) animated:NO];
        [UIView setAnimationsEnabled:YES];
        

        [self.tableView.layer removeAllAnimations];
        
        
        [UIView performWithoutAnimation:^{
                    }];
        
    }
    
    self.arrayContentGroup[index] = string;
}
- (void)scrollToCaretInTextView:(UITextView *)textView animated:(BOOL)animated
{
    CGRect rect = [textView caretRectForPosition:textView.selectedTextRange.end];
    rect.size.height += textView.textContainerInset.bottom;
    [textView scrollRectToVisible:rect animated:animated];
}
- (CGFloat)textViewHeightForAttributedText: (NSAttributedString*)text andWidth: (CGFloat)width {
    UITextView *calculationView = [[UITextView alloc] init];
    [calculationView setAttributedText:text];
    CGSize size = [calculationView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Nhập nội dung..."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    self.activeTextView = textView;
    [textView becomeFirstResponder];
    self.offset = self.tableView.contentOffset;
    [self.tableView.layer removeAllAnimations];
    [self.tableView setContentOffset:CGPointMake(self.offset.x,self.offset.y) animated:NO];
//    [self scrollToCursorForTextView:textView];
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    UITableViewCell *textFieldRowCell;
    textFieldRowCell = (UITableViewCell *) textView.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:textFieldRowCell];
    [UIView setAnimationsEnabled:NO];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    self.offset = self.tableView.contentOffset;
    [UIView setAnimationsEnabled:YES];
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Nhập nội dung...";
        textView.textColor = [UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
    self.activeTextView = nil;
}
#pragma mark - textfield
-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.stringTitle = textField.text;
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
    [self.tableView reloadData];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.35];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.tableView.contentInset.top, 0.0, 0.0, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    [UIView commitAnimations];
}
- (void)scrollToCursorForTextView:(UITextView *)textView {
    CGRect cursorRect = [textView caretRectForPosition:textView.selectedTextRange.start];
    cursorRect = [self.tableView convertRect:cursorRect fromView:textView];
    if (![self rectVisible:cursorRect]) {
        cursorRect.size.height += 20;
        [self.tableView scrollRectToVisible:cursorRect animated:YES];
    }
}

- (BOOL)rectVisible:(CGRect)rect {
    CGRect visibleRect;
    visibleRect.origin = self.tableView.contentOffset;
    visibleRect.origin.y += self.tableView.contentInset.top;
    visibleRect.size = self.tableView.bounds.size;
    visibleRect.size.height -= self.tableView.contentInset.top + self.tableView.contentInset.bottom;
    
    return CGRectContainsRect(visibleRect, rect);
}
#pragma  mark -
- (IBAction)clickBtnAddPhotoGroup:(id)sender {
    
    _numberGroup += 2;
    [self.arrayContentGroup addObject:@""];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    [self.arrayImage addObject:array];
    [self.arrayInfoImage addObject:array];
    [self.arrayURL addObject:array];
    [self.tableView layoutIfNeeded];
    [self.tableView reloadData];
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    
    elcPicker.maximumImagesCount = 100; //Set the maximum number of images to select to 100
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]; //Supports image and movie types
    
    elcPicker.imagePickerDelegate = self;
    [self presentViewController:elcPicker animated:YES completion:nil];
    if(_numberGroup == 5){
        clickAt = 0;
    }
    else{
        clickAt = (_numberGroup - 5)/2;
    }
    [UIView setAnimationsEnabled:NO];
    [self.tableView.layer removeAllAnimations];
    [self.tableView setContentOffset:CGPointMake(self.offset.x,self.offset.y + [UIScreen mainScreen].bounds.size.width / 3) animated:NO];
    [UIView setAnimationsEnabled:YES];
    
    
}
-(void)clickBtnAddImage{
    

}
#pragma mark ELCImagePickerControllerDelegate Methods
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    NSMutableArray *myArray;
    NSMutableArray *myArrayInfo ;
    NSMutableArray *myArrayURL ;
    
    if(![self.arrayInfoImage[clickAt]  isEqual: @""]){
        myArray = self.arrayImage[clickAt];
        myArrayInfo = [self.arrayInfoImage[clickAt] mutableCopy];
        myArrayURL = [self.arrayURL[clickAt] mutableCopy];
    }
    else{
        myArray = [[NSMutableArray alloc]init];
        myArrayInfo = [[NSMutableArray alloc]init];
        myArrayURL = [[NSMutableArray alloc]init];
    }
    MyImage *myImage = [[MyImage alloc]init];
    myImage.filePath = [info valueForKey:UIImagePickerControllerReferenceURL];
    NSLog(@"%@" , [info valueForKey:UIImagePickerControllerReferenceURL]);
//    UIImage* image;
    [myArrayInfo addObject:myImage];
    for (NSDictionary *dict in info) {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage *image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                NSLog(@"%@" , image);
                NSDate *date = [[NSDate alloc] init];
                NSString *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%lld.jpg", [@(floor([date timeIntervalSince1970] * 1000)) longLongValue]]];
                [UIImageJPEGRepresentation(image, 1.0) writeToFile:jpgPath atomically:YES];
                NSURL *url = [[NSURL alloc]initFileURLWithPath:jpgPath];
                
                CLCloudinary *cloudinary = [[CLCloudinary alloc] initWithUrl: @"cloudinary://884437676672962:neeFwPtXtRZePa9wWNEBzUWqHZo@dsjukizml"];
                
                CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:self];
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [uploader upload:UIImageJPEGRepresentation(image, 0.8) options:@{} withCompletion:^(NSDictionary *successResult, NSString *errorResult, NSInteger code, id context) {
                        if (successResult) {
                            NSLog(@"%@" , successResult);
                            NSString *urlImage = [successResult valueForKey:@"url"];
                            [myArrayURL addObject:urlImage];
                            self.arrayURL[clickAt] = myArrayURL;
                        } else {
                            NSLog(@"Block upload error: %@, %ld", errorResult, (long)code);
                            
                        }
                    } andProgress:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite, id context) {
                        NSLog(@"Block upload progress: %ld/%ld (+%ld)", (long)totalBytesWritten, (long)totalBytesExpectedToWrite, (long)bytesWritten);
                    }];

                });
                [myArray addObject:image];
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        } else if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypeVideo){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage *image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                NSLog(@"%@" , image);
                NSDate *date = [[NSDate alloc] init];
                NSString *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%lld.jpg", [@(floor([date timeIntervalSince1970] * 1000)) longLongValue]]];
                [UIImageJPEGRepresentation(image, 1.0) writeToFile:jpgPath atomically:YES];
                NSURL *url = [[NSURL alloc]initFileURLWithPath:jpgPath];
                
                CLCloudinary *cloudinary = [[CLCloudinary alloc] initWithUrl: @"cloudinary://884437676672962:neeFwPtXtRZePa9wWNEBzUWqHZo@dsjukizml"];
                
                CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:self];
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [uploader upload:UIImageJPEGRepresentation(image, 0.8) options:@{} withCompletion:^(NSDictionary *successResult, NSString *errorResult, NSInteger code, id context) {
                        if (successResult) {
                            NSLog(@"%@" , successResult);
                            NSString *urlImage = [successResult valueForKey:@"url"];
                            [myArrayURL addObject:urlImage];
                            self.arrayURL[clickAt] = myArrayURL;
                        } else {
                            NSLog(@"Block upload error: %@, %ld", errorResult, (long)code);
                            
                        }
                    } andProgress:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite, id context) {
                        NSLog(@"Block upload progress: %ld/%ld (+%ld)", (long)totalBytesWritten, (long)totalBytesExpectedToWrite, (long)bytesWritten);
                    }];
                    
                });
                [myArray addObject:image];
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        } else {
            NSLog(@"Uknown asset type");
        }
    }
    
    

    self.arrayInfoImage[clickAt] = myArrayInfo;
    self.arrayImage[clickAt] = myArray;
    [self.tableView reloadData];
    
//    [self upload];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)clickBtnAddImage:(NSInteger)cellIndex{
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    
    elcPicker.maximumImagesCount = 100; //Set the maximum number of images to select to 100
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]; //Supports image and movie types
    
    elcPicker.imagePickerDelegate = self;
    
    [self presentViewController:elcPicker animated:YES completion:nil];
    clickAt = (cellIndex - 2) / 2;
}
#pragma mark - alearview
-(void)clickBtnPost:(NSString *)idCategory location:(NSString *)location{
    NSArray *user_tagged = [[NSArray alloc]initWithObjects:@"57cd1283811db4833887db82", @"57d7ef29e0d981a54349bb05", nil];
    PostModel *post = [[PostModel alloc]init];
    post.title = self.stringTitle;
    post.category = idCategory;
    
    post.location = location;
    NSLog(@"%@" , post.location);
    post.user_tagged = user_tagged;
    post.image_groups = [[NSMutableArray alloc] init];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for(int i = 0 ; i < self.arrayURL.count ; i++){
        Image_Groups_Post *imageGroup = [[Image_Groups_Post alloc]init];
        imageGroup.title = self.arrayContentGroup[i];
        NSLog(@"%@" , self.arrayContentGroup[i]);
        imageGroup.photos = self.arrayURL[i];
        [array addObject:imageGroup];
    }
    post.image_groups = array;
    NSURL * url = [[NSURL alloc]initWithString:@"http:210.245.95.50:6996/api/newpost"];
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    NSData *requestData = [[post toJSONString] dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    //I have to tried a base64 convert here but still not work.
    //request.HTTPBody = [NSData base64DataFromString:bodyRequest];
    
    request.HTTPBody = requestData;
    NSLog(@"j%@" , requestData);
    
    NSURLSessionConfiguration* configureSession = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    configureSession.HTTPAdditionalHeaders = @{@"Content-Type" : @"application/json",
                                               @"Authorization" : string};
    
    NSURLSession* session = [NSURLSession sessionWithConfiguration:configureSession];
    
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    
        NSHTTPURLResponse* respHttp = (NSHTTPURLResponse*) response;
    
        if (!error && respHttp.statusCode == 200) {

            NSDictionary* respondData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
            NSLog(@"%@", respondData);
        }else{
    
            NSLog(@"%@", error);
        }
    
    }];
    [dataTask resume];
    [self resetData];
}
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    
}

-(void)clickBtnDangBaiViet{
    NSLog(@"%@" , self.stringTitle);
    AlertView *detailView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([AlertView class]) owner:nil options:nil] objectAtIndex:0];
    detailView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 2 /5);
    detailView.delegate = self;

    alertView = [[CustomIOSAlertView alloc] init];

    [alertView setContainerView:detailView];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:nil]];
    [alertView setTintColor:[UIColor whiteColor]];
    [alertView setBackgroundColor:[UIColor colorWithRed:31 green:137 blue:255 alpha:1]];
    [alertView setDelegate:self];
    
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        [alertView close];
    }];
    alertView.parentView.userInteractionEnabled = YES;
    [alertView setUseMotionEffects:true];
    [alertView show];
    [alertView bringSubviewToFront:self.view];
    
}
-(void)tapOutAlertView{
    
}
-(void)resetData{
    self.title = @"";
    [self.arrayURL removeAllObjects];
    [self.arrayImage removeAllObjects];
    [self.arrayInfoImage removeAllObjects];
    [self.arrayContentGroup removeAllObjects];
    self.stringTitle = @"";
    [alertView close];
    _numberGroup = 3;
    [self.arrayContentGroup addObject:@""];
    self.arrayImage = [[NSMutableArray alloc]init];
    self.arrayInfoImage = [NSMutableArray new];
    self.arrayURL = [NSMutableArray new];
    [self.tableView reloadData];
}
@end

