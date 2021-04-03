//
//  PaginationManager.h
//  ScrollviewPagination
//
//  Created by Dhawal Bera on 03/04/21.
//  Copyright © 2021 Dhawal Bera. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PaginationManagerDelegate

-(void)refreshAll:(void(^)(BOOL success))completion;
-(void)loadMore:(void(^)(BOOL success))completion;

@end


@interface PaginationManager : NSObject

@property (nonatomic , weak) id<PaginationManagerDelegate> delegate;
@property (nonatomic, retain) UIColor *refreshColor;
@property (nonatomic, retain) UIColor *loaderColor;
@property (nonatomic , assign) BOOL isStopLeft;
@property (nonatomic , assign) BOOL isStopRight;
@property (nonatomic , assign) BOOL isStopBottom;

- (instancetype)init:(UIScrollView *)scrollview;
- (void) initialLoad;

@end

NS_ASSUME_NONNULL_END
