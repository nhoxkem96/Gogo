//
//  ComposePostController.h
//  Gogo
//
//  Created by Thuong on 9/10/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCImagePickerHeader.h"
#import "MyImage.h"
#import "AFNetworking.h"
@interface ComposePostController : UIViewController <UITableViewDelegate,ELCImagePickerControllerDelegate , UITableViewDataSource , UITextViewDelegate , UINavigationControllerDelegate , UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtLocation;
@property (weak, nonatomic) IBOutlet UIView *postView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)clickBtnAddPhotoGroup:(id)sender;
@property int numberGroup;
@property (nonatomic) UITapGestureRecognizer *tapRecognizer;
@property(weak, nonatomic) UIView *activeTextView;
@property NSMutableArray *arrayImage;
@property NSMutableArray *arrayInfoImage;
@property NSMutableArray *arrayURL;
@property NSMutableArray *arrayContentGroup;
+ (ComposePostController *)sharedInstance;

@end
