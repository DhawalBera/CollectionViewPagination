//
//  PaginationManager.m
//  ScrollviewPagination
//
//  Created by Dhawal Bera on 03/04/21.
//  Copyright © 2021 Dhawal Bera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaginationManager.h"

@interface PaginationManager()
{
    BOOL isLoading;
    BOOL isObservingKeyPath;
    
    UIScrollView *scrollView;
    UIView *leftMostLoader;
    UIView *rightMostLoader;
    UIView *bottomMostLoader;
    
}

@end

@implementation PaginationManager

- (instancetype)init:(UIScrollView *)scrollview{
    
    isLoading = NO;
    isObservingKeyPath = NO;
    self.refreshColor = [UIColor whiteColor];
    self.loaderColor = [UIColor whiteColor];
    
    scrollView = scrollview;
    [self addScrollviewOffsetObserver];
    
    return self;
}

- (void)addScrollviewOffsetObserver{
  
    if(isObservingKeyPath){
        return;
    }
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    isObservingKeyPath = true;
}

- (void)removeScrollViewOffsetObserver{
    if (isObservingKeyPath){
        [scrollView removeObserver:self forKeyPath:@"contentOffset"];
    }
    isObservingKeyPath = NO;
}


- (void) initialLoad{
    [self.delegate refreshAll:^(BOOL success) {}];
}

- (void)dealloc{
    [self removeScrollViewOffsetObserver];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UIScrollView *scroll = (UIScrollView *)object;
    NSNumber *val = (NSNumber *)change[NSKeyValueChangeNewKey];
    CGPoint point = val.CGPointValue;
    
    if([scroll isKindOfClass:[UIScrollView class]]){
        [self setContentOffset:point];
    }
}

- (UIView *)getViewWithActivityControl:(CGRect)frame{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [view setBackgroundColor:self.refreshColor];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:view.bounds];
    indicator.color  = self.loaderColor;
    [indicator startAnimating];
    
    [view addSubview:indicator];
    return view;
}

- (void)addLeftMostControl{
    UIView *view = [self getViewWithActivityControl:CGRectMake(-60, 0, 60, scrollView.bounds.size.height)];
    
    UIEdgeInsets insets = scrollView.contentInset;
    insets.left = view.frame.size.width;
    scrollView.contentInset = insets;
    leftMostLoader = view;
    [scrollView addSubview:view];
}

- (void)removeLeftMostControl{
    [leftMostLoader removeFromSuperview];
    leftMostLoader = nil;
}

- (void)addRightMostControl{
    UIView *view = [self getViewWithActivityControl:CGRectMake(scrollView.contentSize.width, 0, 60, scrollView.bounds.size.height)];
    
    UIEdgeInsets insets = scrollView.contentInset;
    insets.right = view.frame.size.width;
    scrollView.contentInset = insets;
    rightMostLoader = view;
    [scrollView addSubview:view];
}

- (void)removeRightMostControl{
    [rightMostLoader removeFromSuperview];
    rightMostLoader = nil;
}

- (void)addBottomMostControl{
    UIView *view = [self getViewWithActivityControl:CGRectMake(0, scrollView.contentSize.height, scrollView.bounds.size.width, 60)];
    
    UIEdgeInsets insets = scrollView.contentInset;
    insets.bottom = view.frame.size.height;
    scrollView.contentInset = insets;
    bottomMostLoader = view;
    [scrollView addSubview:view];
}

- (void)removeBottomMostControl{
    [bottomMostLoader removeFromSuperview];
    bottomMostLoader = nil;
}


- (void)setContentOffset:(CGPoint)offsetVal{
    
    if(!_isStopLeft){
        
        CGFloat offsetX = offsetVal.x;
        if(offsetX < -100 && !isLoading){
            isLoading = YES;
            [self addLeftMostControl];
            [self.delegate refreshAll:^(BOOL success) {
                self -> isLoading = NO;
                [self removeLeftMostControl];
            }];
            return;
        }
    }
    
    if(!_isStopRight){
        CGFloat offsetX = offsetVal.x;
        CGFloat contenWidth = scrollView.contentSize.width;
        CGFloat frameWidth = scrollView.bounds.size.width;
        CGFloat diffX = contenWidth - frameWidth;
        if (contenWidth > frameWidth && offsetX > (diffX + 130) && !isLoading){
            isLoading = YES;
            [self addRightMostControl];
            [self.delegate loadMore:^(BOOL success) {
                self -> isLoading = NO;
                [self removeRightMostControl];
            }];
            return;
        }
    }
    
    
    if(!_isStopBottom){
        CGFloat offsetY = offsetVal.y;
        CGFloat contentHeight = scrollView.contentSize.height;
        CGFloat frameHeight = scrollView.bounds.size.height;
        CGFloat diffY = contentHeight - frameHeight;
        
        if(contentHeight > frameHeight && offsetY > (diffY + 60) && !isLoading){
            isLoading = YES;
            [self addBottomMostControl];
            [self.delegate loadMore:^(BOOL success) {
                self -> isLoading = NO;
                [self removeBottomMostControl];
            }];
        }
    }
    
    
}

@end
