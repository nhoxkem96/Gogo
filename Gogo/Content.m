//
//  Content.m
//  Gogo
//
//  Created by Thuong on 10/18/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "Content.h"
#import "PostView.h"
@implementation Content

- (void)awakeFromNib {
    [super awakeFromNib];
    _txtContent.textContainer.lineBreakMode = NSLineBreakByCharWrapping;
    _txtContent.textContainerInset = UIEdgeInsetsZero;
    [self.txtContent sizeToFit];
}
-(void)textViewDidChange:(UITextView *)textView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(txtViewDidChange:)]) {
        [self.delegate txtViewDidChange:self];
        
    }
    NSLog(@"fuck");
    self.content = textView.text;
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    UIView *containerView = [[[NSBundle mainBundle] loadNibNamed:@"PostView" owner:self options:nil] lastObject];
    textView.inputAccessoryView = containerView;
    return YES;
    
}

@end
