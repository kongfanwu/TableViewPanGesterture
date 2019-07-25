//
//  ViewController.m
//  demoa
//
//  Created by kfw on 2019/7/2.
//  Copyright © 2019 kfw. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"
#import "UIView+FWScreenshot.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
/** <##> */
@property (nonatomic, strong) UITableView *tableView;
/** <##> */
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
/** <##> */
@property (nonatomic, strong) UIImageView *screenImageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 44, self.view.frame.size.width - 30, self.view.frame.size.height-44) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleScopeGesture:)];
    self.panGesture = panGesture;
    panGesture.delegate = self;
    panGesture.minimumNumberOfTouches = 1;
    panGesture.maximumNumberOfTouches = 2;
    [self.view addGestureRecognizer:panGesture];
    //[A requireGestureRecognizerToFail：B]手势互斥 它可以指定当A手势发生时，即便A已经滿足条件了，也不会立刻触发，会等到指定的手势B确定失败之后才触发。
    [_tableView.panGestureRecognizer requireGestureRecognizerToFail:panGesture];
    
    if ([_tableView respondsToSelector:@selector(contentInsetAdjustmentBehavior)]) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}
#pragma mark - <UIGestureRecognizerDelegate>

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint velocity = [self.panGesture velocityInView:self.view];
//    NSLog(@"self.panGesture:%@", NSStringFromCGPoint(velocity));
    
    // 横向
    if (fabs(velocity.x) > fabs(velocity.y)) {
       NSLog(@"横向滑动，事件生效");
        return YES;
    }
    // 竖向
    else {
       NSLog(@"竖向, 事件失效");
        return NO;
    }
        
    return YES;
}

- (void)handleScopeGesture:(UIPanGestureRecognizer *)sender
{
    CGFloat translationY = [sender translationInView:sender.view].y;
    CGFloat translationX = [sender translationInView:sender.view].x;
    NSLog(@"%lf %lf", translationX, translationY);
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            [self scopeTransitionDidBegan];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self scopeTransitionDidUpdate:sender];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:{
            [self scopeTransitionDidEnd];
            [self commitTranslation:[sender translationInView:self.view]];
            break;
        }
        default: {
            break;
        }
    }
}

-(void)scopeTransitionDidBegan {
    // 截屏，开始位置为滑动的偏移量，结束位置为开始位置+ tableView 高
    UIImage *screenImage = [_tableView screenshotWithRect:CGRectMake(0, _tableView.contentOffset.y, _tableView.frame.size.width, _tableView.frame.size.height)];
    UIImageView *screenImageView = [[UIImageView alloc] initWithImage:screenImage];
    screenImageView.backgroundColor = UIColor.blueColor;
    self.screenImageView = screenImageView;
    screenImageView.frame = _tableView.frame;//CGRectMake(_tableView.frame.origin.x, 44, screenImage.size.width, screenImage.size.height);
    [self.view addSubview:_screenImageView];
    
    // 隐藏
    _tableView.hidden = YES;
}

- (void)scopeTransitionDidUpdate:(UIPanGestureRecognizer *)sender {
    CGFloat translationX = [sender translationInView:sender.view].x;
    // 设置截图的图片为滑动的位置
    _screenImageView.frame = CGRectMake(_tableView.frame.origin.x + translationX, 44, _tableView.frame.size.width, _tableView.frame.size.height);
}

- (void)scopeTransitionDidEnd {
    // 显示
    _tableView.hidden = NO;
    // 移除
    [_screenImageView removeFromSuperview];
}

/** 判断手势方向  */
- (void)commitTranslation:(CGPoint)translation {
    CGFloat absX = fabs(translation.x);
    CGFloat absY = fabs(translation.y);
    CGFloat screenWYiBan = _tableView.frame.size.width / 2.f;
    // 设置滑动有效距离
//    if (MAX(absX, absY) < 10) return;
    
    if (absX > absY ) {
        if (translation.x<0) {//向左滑动
            NSLog(@"向左滑动");
            // 滑动距离大于等于屏幕一半，显示下页数据
            if (absX >= screenWYiBan) {
                NSLog(@"向左滑动成功");
            }
        }else{//向右滑动
            NSLog(@"向右滑动");
            // 滑动距离大于等于屏幕一半，显示上页数据
            if (absX >= screenWYiBan) {
                NSLog(@"向右滑动成功");
            }
        }
    }
//    else if (absY > absX) {
//        if (translation.y<0) {//向上滑动
//        }else{ //向下滑动
//        }
//    }
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Cell %ld", indexPath.row];
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
