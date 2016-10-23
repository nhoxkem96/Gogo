//
//  CollectionView.h
//  Gogo
//
//  Created by Thuong on 9/14/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CollectionViewDelegate <NSObject>
-(void)clickBtnAddImage:(NSInteger)cellIndex;
@end
@interface CollectionView : UITableViewCell<UICollectionViewDelegate , UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) id <CollectionViewDelegate> delegate;
@property NSMutableArray *arrayImage;
@property NSInteger cellIndex;
@end
