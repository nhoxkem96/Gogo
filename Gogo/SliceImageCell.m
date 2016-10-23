//
//  SliceImageCell.m
//  Gogo
//
//  Created by Thuong on 8/31/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "SliceImageCell.h"

@implementation SliceImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _imagePager.pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    _imagePager.pageControl.pageIndicatorTintColor = [UIColor blackColor];
//
    _imagePager.slideshowShouldCallScrollToDelegate = YES;
    self.imagePager.delegate = self;
    self.imagePager.dataSource = self;
}

#pragma mark - KIImagePager DataSource
- (NSArray *) arrayWithImages:(KIImagePager*)pager
{
    return self.imageArray;
}

- (UIViewContentMode) contentModeForImage:(NSUInteger)image inPager:(KIImagePager *)pager
{
    return UIViewContentModeScaleAspectFit;
}

//- (NSString *) captionForImageAtIndex:(NSUInteger)index inPager:(KIImagePager *)pager
//{
//    return @[
//             @"First screenshot",
//             @"Another screenshot",
//             @"Last one! ;-)"
//             ][index];
//}

#pragma mark - KIImagePager Delegate
//- (void) imagePager:(KIImagePager *)imagePager didScrollToIndex:(NSUInteger)index
//{
//    NSLog(@"%s %lu", __PRETTY_FUNCTION__, (unsigned long)index);
//}
-(void)layoutSubviews{
    _imagePager.slideshowTimeInterval = 2.0f;
}
- (void) imagePager:(KIImagePager *)imagePager didSelectImageAtIndex:(NSUInteger)index{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedImage:atIndex:atCellIndex:)]) {
        [self.delegate didSelectedImage:self atIndex:index atCellIndex:_cellIndex];
        
    }

    NSLog(@"%s %lu", __PRETTY_FUNCTION__, (unsigned long)index);
}

- (void)displayImages:(NSMutableArray *)imageArray;
{
    self.imageArray = imageArray;
    
    [self.imagePager reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
