//
//  ComposePostViewController.h
//  Gogo
//
//  Created by Thuong on 10/14/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComposePostViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)clickBtnAddGroupImage:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *postView;

@end
