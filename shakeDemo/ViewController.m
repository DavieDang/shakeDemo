//
//  ViewController.m
//  shakeDemo
//
//  Created by admin on 2017/1/13.
//  Copyright © 2017年 gzpingao.com. All rights reserved.
//

#import "ViewController.h"
#import "wcCell.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;


// 是否抖动
@property (nonatomic, assign, getter=isShaking) BOOL shaking;

@property (nonatomic,strong) NSMutableArray * dataSource;


@end

@implementation ViewController

- (NSMutableArray *)dataSource{
    
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        for (int i = 1; i <= 14; i++) {
            NSString *imageName = [NSString stringWithFormat:@"%d",i];
            [_dataSource addObject:imageName];
        }
    }
    return _dataSource;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout  alloc]init];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        flowLayout.itemSize = CGSizeMake((kWidth-50)/4, 60);
        flowLayout.minimumLineSpacing = 10;
       // flowLayout.minimumInteritemSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        
        [_collectionView registerClass:[wcCell class] forCellWithReuseIdentifier:@"MyCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self.view addSubview:_collectionView];
        
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(BeginWobbleCell:)];
        
        [self.collectionView addGestureRecognizer:longPress];
     
//        UITapGestureRecognizer *tapges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(EndWobble)];
       //[self.view addGestureRecognizer:tapges];
        
        
        
    }
    return _collectionView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.collectionView.hidden = NO;

}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
 
        wcCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor purpleColor];
        cell.userInteractionEnabled = YES;
    UILabel *munLb = [[UILabel alloc] init];
    munLb.textColor = [UIColor blackColor];
    munLb.text = self.dataSource[indexPath.item];
    munLb.frame  =  CGRectMake(5, 5, 20, 20);
    
    
    
    [cell.delectBtn addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    cell.delectBtn.hidden = YES;
    
    [cell.contentView addSubview:munLb];
    

    
   // [self BeginWobbleCell:cell];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)BeginWobbleCell:(UILongPressGestureRecognizer *)longGesture
{

    
    //判断手势状态
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:{
  
            self.shaking = YES;
            
            for (wcCell *cell in _collectionView.subviews) {
                
                
                cell.delectBtn.hidden = NO;
                
                srand([[NSDate date] timeIntervalSince1970]);
                float rand=(float)random();
                CFTimeInterval t=rand*0.0000000001;
                
                [UIView animateWithDuration:0.1 delay:t options:0  animations:^
                 {
                     cell.transform=CGAffineTransformMakeRotation(-0.05);
                 } completion:^(BOOL finished)
                 {
                     [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction  animations:^
                      {
                          cell.transform=CGAffineTransformMakeRotation(0.05);
                      } completion:^(BOOL finished) {}];
                 }];
            }

            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[longGesture locationInView:self.collectionView]];
            if (indexPath == nil) {
                break;
            }
            //在路径上则开始移动该路径上的cell
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
            
            break;

        }

        case UIGestureRecognizerStateChanged:{
 
            for (wcCell *cell in _collectionView.subviews) {
                
                [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^
                 {
                     cell.transform=CGAffineTransformIdentity;
                 } completion:^(BOOL finished) {}];
            }
            [self.collectionView updateInteractiveMovementTargetPosition:[longGesture locationInView:self.collectionView]];
            break;
        }
        case UIGestureRecognizerStateEnded:
            
            for (wcCell *cell in _collectionView.subviews) {
                
                srand([[NSDate date] timeIntervalSince1970]);
                float rand=(float)random();
                CFTimeInterval t=rand*0.0000000001;
                
                [UIView animateWithDuration:0.1 delay:t options:0  animations:^
                 {
                     cell.transform=CGAffineTransformMakeRotation(-0.05);
                 } completion:^(BOOL finished)
                 {
                     [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction  animations:^
                      {
                          cell.transform=CGAffineTransformMakeRotation(0.05);
                      } completion:^(BOOL finished) {}];
                 }];
            }
            //移动结束后关闭cell移动
         [self.collectionView endInteractiveMovement];
            break;
        default:
         [self.collectionView cancelInteractiveMovement];
            break;
    }
    
    }

//-(void)EndWobble
//{
//    if (_shaking) {
//         for (UICollectionViewCell *cell in _collectionView.subviews) {
//             
//        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^
//         {
//             cell.transform=CGAffineTransformIdentity;
//         } completion:^(BOOL finished) {}];
//    }
//
//    }
//    
//}


- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}
//
//
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
    
    //取出源item数据
    id objc = [_dataSource objectAtIndex:sourceIndexPath.item];
    //从资源数组中移除该数据
    [_dataSource removeObject:objc];
    //将数据插入到资源数组中的目标位置上
    [_dataSource insertObject:objc atIndex:destinationIndexPath.item];
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了");
}


- (void)test{
     NSLog(@"点击了---------");
}

@end
