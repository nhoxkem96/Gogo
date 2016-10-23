//
//  GroupImage.h
//  Gogo
//
//  Created by Thuong on 10/14/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CollectionDelegate <NSObject>
-(void)clickBtnAddImage:(NSInteger)cellIndex;
@end
@interface GroupImage : UIView<UICollectionViewDelegate , UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UITextView *txtContent;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) id <CollectionDelegate> delegate;
@property NSMutableArray *arrayImage;
@property NSInteger cellIndex;
@property BOOL isHiden;
@end
