//
//  DetailImageView.h
//  Gogo
//
//  Created by Thuong on 9/12/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "MWPhotoBrowser.h"
@interface DetailImageView : UIViewController<MWPhotoBrowserDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *image;
//- (IBAction)clickBtnBack:(id)sender;
//- (IBAction)clickBtnNext:(id)sender;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic , strong) NSMutableArray *thumbs;
@property (nonatomic , strong) NSMutableArray *photos;
@property int index;
@end
