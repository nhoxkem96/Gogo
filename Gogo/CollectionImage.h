//
//  CollectionImage.h
//  Gogo
//
//  Created by Thuong on 9/10/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionImage : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgItem;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
- (IBAction)clickBtnCancel:(id)sender;

@end
