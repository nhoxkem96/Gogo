//
//  GroupImage.m
//  Gogo
//
//  Created by Thuong on 10/14/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "GroupImage.h"
#import "CollectionAdd.h"
#import "CollectionImage.h"
@interface GroupImage ()<CollectionAddDelegate>

@end
@implementation GroupImage
- (void)awakeFromNib {
    [super awakeFromNib];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.arrayImage = [[NSMutableArray alloc]init];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CollectionAdd class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([CollectionAdd class])];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CollectionImage class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([CollectionImage class])];
    // Initialization code
}
#pragma mark - Collectionview
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return self.arrayImage.count + 1;;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    if(indexPath.row == self.arrayImage.count){
        CollectionAdd *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CollectionAdd class]) forIndexPath:indexPath];
        
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([CollectionAdd class]) owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.delegate = self;
        return cell;
    }
    
    else{
        CollectionImage *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CollectionImage class]) forIndexPath:indexPath];
        
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([CollectionImage class]) owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        //       cell.imgItem.image = [UIImage imageNamed:self.collectionArray[indexPath.row]];
        cell.imgItem.image = self.arrayImage[indexPath.row];
        
        return cell;
    }
}
-(void)clickBtnAddImage:(NSInteger)cellIndex{
    
    if ([self.delegate respondsToSelector:@selector(clickBtnAddImage:)]) {
        [self.delegate clickBtnAddImage:self.cellIndex];
    }
}

#pragma mark - CollectionView Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    if(indexPath.row == self.arrayImage.count){
        return CGSizeMake([UIScreen mainScreen].bounds.size.width/ 3 ,[UIScreen mainScreen].bounds.size.width/ 3);
    }
    else return CGSizeMake([UIScreen mainScreen].bounds.size.width/ 2 ,[UIScreen mainScreen].bounds.size.width/ 3);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
