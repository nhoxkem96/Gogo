//
//  Content.h
//  Gogo
//
//  Created by Thuong on 10/18/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ContentDelegate <NSObject>

- (void)txtViewDidChange:(id)sender;
@end
@interface Content : UIView
@property (weak, nonatomic) id <ContentDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextView *txtContent;
@property NSString *content;
@end
