//
//  ViewController.m
//  ScrollviewPagination
//
//  Created by Dhawal Bera on 03/04/21.
//  Copyright © 2021 Dhawal Bera. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "PaginationManager.h"

@interface CustomCell : UICollectionViewCell
@property(nonatomic, weak) IBOutlet UILabel *lblTitle;
@end

@implementation CustomCell

@end


@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PaginationManagerDelegate>
{
    PaginationManager *pagination;
    NSMutableArray *arritem;
}
@property(nonatomic , weak) IBOutlet UICollectionView *colView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pagination = [[PaginationManager alloc] init:self.colView];
    pagination.delegate = self;
    pagination.refreshColor = [UIColor blueColor];
    pagination.loaderColor = [UIColor systemPinkColor];
    self.colView.alwaysBounceHorizontal = YES;
    
    arritem = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3", @"2",@"3",nil];
    
    [pagination initialLoad];
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    CustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.lblTitle.text = [NSString stringWithFormat:@"%ld",(long)indexPath.item];
    return  cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return arritem.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
}

- (void)loadMore:(nonnull void (^)(BOOL))completion {
    
    
    [self delay:2 completion:^{
        [self->arritem addObjectsFromArray:@[@"1",@"2",@"3",@"4",@"5"]];
        [self.colView reloadData];
        completion(YES);
        if(self->arritem.count > 10){
            self->pagination.isStopRight = true;
        }
        
    }];
}

- (void)refreshAll:(nonnull void (^)(BOOL))completion {
    [self delay:2 completion:^{
        self->arritem = [[NSMutableArray alloc] initWithArray:@[@"1",@"2",@"3",@"4",@"5"]];
        [self.colView reloadData];
        completion(YES);
        if(self->arritem.count < 10){
            self->pagination.isStopRight = false;
        }
    }];
}

-(void)delay:(double)delay completion:(void(^)(void))completion{
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        completion();
    });
}
@end
