//
//  ComposePostViewController.m
//  Gogo
//
//  Created by Thuong on 10/14/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "ComposePostViewController.h"
#import "GroupImage.h"
#import "BotView.h"
#import "TopView.h"
#import "TextViewContent.h"
#import "CollectionView.h"
#import "Content.h"
@interface ComposePostViewController ()<UITextViewDelegate>
@property NSMutableArray *arrayTextView;
@property NSMutableArray *arrayImageGroup;
@property NSMutableArray *arrayView;
@property NSMutableArray *arrayContent;
@property (nonatomic) UITapGestureRecognizer *tapRecognizer;
@end
UIView *lastView;
@implementation ComposePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    self.tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:self.tapRecognizer];
    self.arrayTextView = [[NSMutableArray alloc]init];
    self.arrayImageGroup = [[NSMutableArray alloc]init];
    self.arrayView = [[NSMutableArray alloc]init];
    self.arrayContent = [[NSMutableArray alloc]init];
    [self.arrayContent addObject:@""];
    UIView *firstViewUIView = [[[NSBundle mainBundle] loadNibNamed:@"PostView" owner:self options:nil] firstObject];
    [self.postView addSubview:firstViewUIView];
    [self addCustomView];
}
- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    return NO;
}
- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}
- (void)addCustomView
{
    
    for (int i = 0; i< 3; i++)
    {
        UIView *view = [[UIView alloc] init];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self.scrollView addSubview:view];
        [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
        [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        [self.arrayView addObject:view];
        if (i == 0)
        {
            NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"TopView"
                                                                  owner:self
                                                                options:nil];
            
            TopView* myView = [ nibViews objectAtIndex:0];
            myView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width/4 );
            [view addSubview:myView];
            NSString *height = [NSString stringWithFormat:@"V:|[view(%f)]" , [UIScreen mainScreen].bounds.size.width/4];
            [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:height options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
            
            
        }
        else if(i== 1)
        {
            NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"Content"
                                                              owner:self
                                                            options:nil];
            
            Content* myView = [ nibViews objectAtIndex:0];
            myView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height*25/71 );
            [view addSubview:myView];
            NSString *height = [NSString stringWithFormat:@"V:[lastView(400)]-10-[view(%f)]" , [UIScreen mainScreen].bounds.size.height*25/71];

            [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:height options:0 metrics:nil views:NSDictionaryOfVariableBindings(lastView,view)]];
            [self.arrayTextView addObject:myView];
        }
        else{
            NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"BotView"
                                                              owner:self
                                                            options:nil];
            
            BotView* myView = [ nibViews objectAtIndex:0];
            myView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width/4);
            [view addSubview:myView];
            NSString *height = [NSString stringWithFormat:@"V:[lastView(400)]-10-[view(%f)]" , [UIScreen mainScreen].bounds.size.width/4];
            
            [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:height options:0 metrics:nil views:NSDictionaryOfVariableBindings(lastView,view)]];
        }
        lastView = view;
    }
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lastView(150)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lastView)]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)drawView{
//    for (UIView *v in self.scrollView.subviews) {
//        [v removeFromSuperview];
//    }
    for (int i = 0; i< self.arrayView.count; i++)
    {
        UIView *view = [[UIView alloc] init];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        if (i == 0)
        {
            [self.scrollView addSubview:view];
            [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
//            [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];

            NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"TopView"
                                                              owner:self
                                                            options:nil];
            
            TopView* myView = [ nibViews objectAtIndex:0];
            myView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width/4 );
            [view addSubview:myView];
            NSString *height = [NSString stringWithFormat:@"V:|[view(%f)]" , [UIScreen mainScreen].bounds.size.width/4];
            [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:height options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
        }
        else if(i % 2 == 1)
        {
            [self.scrollView addSubview:view];
            [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
            [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
            NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"Content"
                                                              owner:self
                                                            options:nil];
            
            Content* myView = [ nibViews objectAtIndex:0];
            myView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width/8 );
            myView.txtContent.delegate = self;
            int index = (i-1)/2;
            myView.txtContent.text = self.arrayContent[index];
            myView.txtContent.frame = CGRectMake(myView.txtContent.frame.origin.x, myView.txtContent.frame.origin.y, myView.txtContent.frame.size.width, 300);
            UITextView *textView = [[UITextView alloc]init];
            textView.delegate = self;
            textView.text = @"Thuong";
            textView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width/8 );
            [view addSubview:textView];
            
            UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, 10, 10);
            
            [view addConstraints:@[
                                        //view1 constraints
                                        [NSLayoutConstraint constraintWithItem:textView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:view
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:padding.top],
                                        
                                        [NSLayoutConstraint constraintWithItem:textView
                                                                     attribute:NSLayoutAttributeLeft
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:view
                                                                     attribute:NSLayoutAttributeLeft
                                                                    multiplier:1.0
                                                                      constant:padding.left],
                                        
                                        [NSLayoutConstraint constraintWithItem:textView
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:view
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:-padding.bottom],
                                        
                                        [NSLayoutConstraint constraintWithItem:textView
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:view
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1
                                                                      constant:-padding.right],]];
            NSString *height;
            if(myView.txtContent.contentSize.height > [UIScreen mainScreen].bounds.size.width/8){
                height =  [NSString stringWithFormat:@"V:[lastView(400)]-0-[view(%f)]" , myView.txtContent.contentSize.height];
            }
            else {
                height =  [NSString stringWithFormat:@"V:[lastView(400)]-0-[view(%f)]" , [UIScreen mainScreen].bounds.size.width/8];
            }
            
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 300);
            [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:height options:0 metrics:nil views:NSDictionaryOfVariableBindings(lastView,view)]];
            [view setNeedsUpdateConstraints];
            [view updateConstraintsIfNeeded];
            [view setNeedsLayout];
            [view layoutIfNeeded];
        }
        else if(i % 2 == 0 && i != self.arrayView.count - 1){
            [self.scrollView addSubview:view];
            [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
            [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
            NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"CollectionView"
                                                              owner:self
                                                            options:nil];
            
            CollectionView* myView = [ nibViews objectAtIndex:0];
            myView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width/3 );
            [view addSubview:myView];
            NSString *height = [NSString stringWithFormat:@"V:[lastView(400)]-0-[view(%f)]" , [UIScreen mainScreen].bounds.size.width/3];
            
            [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:height options:0 metrics:nil views:NSDictionaryOfVariableBindings(lastView,view)]];
        }
        else{
            [self.scrollView addSubview:view];
            [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
            [self.scrollView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
            NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"BotView"
                                                              owner:self
                                                            options:nil];
            
            BotView* myView = [ nibViews objectAtIndex:0];
            myView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width/4);
            [view addSubview:myView];
            NSString *height = [NSString stringWithFormat:@"V:[lastView(400)]-0-[view(%f)]" , [UIScreen mainScreen].bounds.size.width/4];
            
            [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:height options:0 metrics:nil views:NSDictionaryOfVariableBindings(lastView,view)]];
        }
        lastView = view;
        view.tag = i + 100;
    }
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lastView(150)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lastView)]];
}
- (IBAction)clickBtnAddGroupImage:(id)sender {
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"Content"
                                                      owner:self
                                                    options:nil];
    
    Content* content = [ nibViews objectAtIndex:0];
    [self.arrayView insertObject:content atIndex:self.arrayView.count - 1];
    NSArray* nibViewCollection = [[NSBundle mainBundle] loadNibNamed:@"CollectionView"
                                                      owner:self
                                                    options:nil];
    
    CollectionView* collectionView = [ nibViewCollection objectAtIndex:0];
    [self.arrayView insertObject:collectionView atIndex:self.arrayView.count - 1];
    for (UIView *v in self.scrollView.subviews) {
            [v removeFromSuperview];
    }
    [self.arrayContent addObject:@""];
    [self drawView];
}

-(void)textViewDidChange:(UITextView *)textView{
    long number = textView.superview.superview.tag%100;
    long index = (number - 1) / 2;
    self.arrayContent[index] = textView.text;
    NSLog(@"%@" , textView.text);
    CGRect frame = textView.frame;
    frame.size.height = textView.contentSize.height;
    textView.frame = frame;
//    [self drawView];
}
@end
