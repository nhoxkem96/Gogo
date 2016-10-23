//
//  ExpandableTableView.m
//  ExpandableTableView
//
//  Created by Warif Akhand Rishi on 4/13/16.
//  Copyright © 2016 Warif Akhand Rishi. All rights reserved.
//

#import "ExpandableTableView.h"
#import "HeaderView.h"

@interface ExpandableTableView () <HeaderViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *sectionStatusDic;

@end

@implementation ExpandableTableView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _sectionStatusDic = [[NSMutableDictionary alloc] init];
    self.initiallyExpandedSection = - 1;
}

- (HeaderView *)headerView {
    
    HeaderView *headerView  = [self dequeueReusableHeaderFooterViewWithIdentifier:@"Header"];
    
    if (!headerView) {
        CGRect frame = CGRectMake(0 , 0, CGRectGetWidth(self.frame), HEADER_VIEW_HEIGHT);
        headerView = [[HeaderView alloc] initWithReuseIdentifier:@"Header" andFrame:frame];
        headerView.backgroundColor = [UIColor whiteColor];
        headerView.delegate = self;
    }
    
    return headerView;
}

- (BOOL)collapsedForSection:(NSInteger)section {
    
    NSString *key = [NSString stringWithFormat:@"%ld", (long)section];

    if (self.sectionStatusDic[key]) {
        return ((NSNumber *)self.sectionStatusDic[key]).boolValue;
    }
    
    return (self.initiallyExpandedSection == section) ? NO : self.allHeadersInitiallyCollapsed;
}

- (NSInteger)totalNumberOfRows:(NSInteger)total inSection:(NSInteger)section; {
    
    return ([self collapsedForSection:section]) ? 0 : total;
}

- (UIView *)headerWithTitle:(NSString *)title totalRows:(NSInteger)row inSection:(NSInteger)section {

    BOOL isCollapsed = [self collapsedForSection:section];
    
    HeaderView *headerView = self.headerView;
    [headerView updateWithTitle:title isCollapsed:isCollapsed totalRows:row andSection:section];
    
    return headerView;
}

#pragma mark - HeaderViewDelegate

- (void)didTapHeader:(HeaderView *)headerView {
    
    NSString *key = [NSString stringWithFormat:@"%ld", (long)headerView.section];
    BOOL isCollapsed = [self collapsedForSection:headerView.section];
    isCollapsed = !isCollapsed;
    
    [self.sectionStatusDic setObject:@(isCollapsed) forKey:key];
    
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < headerView.totalRows; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:headerView.section]];
    }
    
//    [self beginUpdates];
    
    if (isCollapsed) {
        [self.layer removeAllAnimations];
        [self deleteRowsAtIndexPaths:indexPaths withRowAnimation:NO];
    } else {
        [self.layer removeAllAnimations];
        [self insertRowsAtIndexPaths:indexPaths withRowAnimation:NO];
    }
    
//    [self endUpdates];
    [self reloadData];
}

@end
