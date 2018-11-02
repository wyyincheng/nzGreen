//
//  YMMTopTabbarView.m
//  YMMBaseProject
//
//  Created by jaderyang on 2017/9/21.
//  Copyright © 2017年 kevin. All rights reserved.
//

#import "YMMTopTabbarView.h"

#import "UIView+YMMBorder.h"
#import "UIView+Controller.h"

#define kDefaultTitleNormalColor            [UIColor grayColor]
#define kDefaultTitleSelectedColor          [UIColor orangeColor]
#define kDefaultBottomLineColor             [UIColor orangeColor]


static CGFloat   kYmmTopBarDefaultHeight     = 48.0f;
static CGFloat   kYmmTopBarBottomlineHeight  = 3.f;
static CGFloat   kYmmTopBarTitleFont         = 16.f;
static NSInteger kColumnBaseTag              = 1600;

@interface YMMTopTabbarView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIView *topTabbar;
@property (nonatomic, strong) UIScrollView *contentScrollView;  //容器 scrollview
@property (nonatomic, strong) UIView *scrollViewContentView;    //scrollview 的 contentview
@property (nonatomic, strong) NSArray *contentViewsArray;
@property (nonatomic, strong) NSArray *columnItemsArray;
@property (nonatomic, assign, readwrite) NSInteger numberOfColumns;
@property (nonatomic, strong) NSArray *viewControllersArray;    //子viewcontrolls 数组

@property (nonatomic, weak) UIViewController *viewController;
@end

@implementation YMMTopTabbarView{
    BOOL _hasLayouted;
    NSMutableSet *_apperedContentViewsIndexs;   //已出现过的View的index set
}

- (void)dealloc{
    NSLog(@"%s", __func__);
}

#pragma mark - lifecyle
- (instancetype)initWithtopBarStyle:(YMMTopBarStyle)topBarStyle{
    self = [super init];
    if (!self) return nil;
    _topBarStyle = topBarStyle;
    _showBottomLine = YES;
    _selectedColumnIndex = -1;
    _needUpdateContentViewWhenAppear = YES;
    _apperedContentViewsIndexs = [NSMutableSet set];
    [self setupViews];
    return self;
}

- (instancetype)init{
    return [self initWithtopBarStyle:YMMTopBarStyleDefault];
}

//初始化容器视图
- (void)setupViews{
    [self addSubview:self.topTabbar];
    [self addSubview:self.contentScrollView];
    [self.contentScrollView addSubview:self.scrollViewContentView];
    
    [self.topTabbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
    }];
    
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topTabbar.mas_bottom);
        make.left.bottom.right.equalTo(@0);
    }];
    
    [self.scrollViewContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.height.equalTo(self.contentScrollView);
    }];
}


- (void)layoutSubviews{
    if (!_hasLayouted) {
        _hasLayouted = YES;
        [self reloadData];
        [self reloadTopBarData];
        NSInteger temIndex = _selectedColumnIndex;
        _selectedColumnIndex = -1;
        [self setSelectedColumnIndex:temIndex == -1 ? 0 : temIndex];
    }
    [super layoutSubviews];
}

- (void)confirmTopBarDatasource{
    //获取上部分tabbar的视图数组
    NSMutableArray *muTempArray = @[].mutableCopy;
    if (_topBarStyle == YMMTopBarStyleDefault) {
        [self _handleTitlesArr];
        for (NSString *title in _topBarTitles) {
            [muTempArray addObject:[self _createTitleLabelByTitle:title]];
        }
    } else if(_topBarStyle == YMMTopBarStyleCustom){
        BOOL canFetchColumnItem = self.dataSource && [self.dataSource respondsToSelector:@selector(topTabbarView:itemForColumnAtIndex:)];
        NSAssert(canFetchColumnItem, @"%@: Custom 模式下必须实现协议的 itemForColumnAtIndex 方法", self);
        for (int i = 0; i < _numberOfColumns; i ++) {
            UIView *contentView = [self.dataSource topTabbarView:self itemForColumnAtIndex:i];
            NSAssert(contentView != nil, @"%@:itemForColumnAtIndex: 返回不能为nil", self);
            [muTempArray setObject:contentView atIndexedSubscript:i];
        }
    }
    //给视图添加事件
    if (muTempArray.count) {
        _columnItemsArray = [muTempArray copy];
        for (int i = 0; i < _columnItemsArray.count ; i ++) {
            UIView *contentView = _columnItemsArray[i];
            contentView.tag = kColumnBaseTag + i;
            contentView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
            [tap addTarget:self action:@selector(_columnSelected:)];
            [contentView addGestureRecognizer:tap];
            if (i == _selectedColumnIndex) {
                [self _resetColumAtIndex:i fromIndex:-1];
            }
        }
    }
    [self reSetUpTopBar];
}

//从datasouce协议中的方法获取视图配置必须的数据
- (void)confirmDataSource{
    //获取pages的数量
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfColumsInTopTabbarView:)]) {
        _numberOfColumns = [self.dataSource numberOfColumsInTopTabbarView:self];
    }
    //获取下面内容视图数组
    BOOL isConfirmedToViewDatasource = self.dataSource && [self.dataSource respondsToSelector:@selector(topTabbarView:contentViewForColumnAtIndex:)];
    BOOL isConfirmedToViewControllerDatasource = self.dataSource && [self.dataSource respondsToSelector:@selector(topTabbarView:contentViewControllerForColumnAtIndex:)];
    NSAssert(isConfirmedToViewControllerDatasource || isConfirmedToViewDatasource, @"contentViewForColumnAtIndex 和 contentViewControllerForColumnAtIndex 必须实现其中一个");
    if (isConfirmedToViewDatasource) {
        NSMutableArray *muTempArray = @[].mutableCopy;
        for (int i = 0; i < _numberOfColumns; i ++) {
            UIView *contentView = [self.dataSource topTabbarView:self contentViewForColumnAtIndex:i];
            [muTempArray setObject:contentView atIndexedSubscript:i];
        }
        _contentViewsArray = muTempArray.mutableCopy;
    }
    
    if (isConfirmedToViewControllerDatasource) {
        NSMutableArray *muTempArray = @[].mutableCopy;
        NSMutableArray *muTempVCArray = @[].mutableCopy;
        for (int i = 0; i < _numberOfColumns; i ++) {
            UIViewController *controller = [self.dataSource topTabbarView:self contentViewControllerForColumnAtIndex:i];
            [muTempArray setObject:controller.view atIndexedSubscript:i];
            [muTempVCArray addObject:controller];
        }
        _contentViewsArray = muTempArray.copy;
        _viewControllersArray = muTempVCArray.copy;
    }
    
    [self reSetUpContentView];
}

#pragma mark - private method
//防止 numberOfColumn 数值和 titles array 维度不一样， 以titles arrays 为主
- (void)_handleTitlesArr{
    NSAssert(_numberOfColumns <= _topBarTitles.count, @"标题数组小于定义的column数量");
    if (_topBarTitles.count == _numberOfColumns) return;
    if (_topBarTitles.count > _numberOfColumns) {
        _topBarTitles = [[_topBarTitles mutableCopy] subarrayWithRange:NSMakeRange(0, _numberOfColumns)].copy;
    }
    
}

//通过title创建默认的column视图
- (UILabel *)_createTitleLabelByTitle:(NSString *)title{
    UILabel *titleL = [UILabel new];
    titleL.font = self.titleFont;
    titleL.textColor = self.titleNormalColor;
    titleL.numberOfLines = 1;
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.text = title;
    return titleL;
}

//column点击
- (void)_columnSelected:(UIGestureRecognizer *)reg{
    if (!reg.view) return;
    NSInteger index = reg.view.tag - kColumnBaseTag;
    if (index > -1 && index < _numberOfColumns) {
        [self setSelectedColumnIndex:index];
    }
}

//reload视图的时候 根据datasouce提供的数据 重新生成视图
- (void)reSetUpContentView{
    if (!self.contentViewsArray) return;
    [self.contentViewsArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.viewControllersArray makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    [_apperedContentViewsIndexs removeAllObjects];
    [self makeEqualWidthViews:self.contentViewsArray inView:self.scrollViewContentView];
    for (UIViewController *vc in _viewControllersArray) {
        if (self.viewController) {
            [self.viewController addChildViewController:vc];
        }
    }
    [self.scrollViewContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.contentScrollView).multipliedBy(self.numberOfColumns);
    }];
}

- (void)reSetUpTopBar{
    if (!self.columnItemsArray) return;
    [self.topTabbar.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.topTabbar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(self.topTabbarHight));
    }];
    [self makeEqualWidthViews:self.columnItemsArray inView:self.topTabbar];
    [self.topTabbar addBorderInPosition:YMMBorderPositionBottom];
    
}

//等宽视图布局
-(void)makeEqualWidthViews:(NSArray *)views inView:(UIView *)contentView{
    UIView *lastView;
    for (UIView *view in views) {
        [contentView addSubview:view];
        if (lastView) {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(lastView);
                make.left.greaterThanOrEqualTo(lastView.mas_right);
                make.left.equalTo(lastView.mas_right).priority(999);//用于防止宽度过小时的约束错误
                make.width.equalTo(lastView);
            }];
        } else {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.bottom.equalTo(@0);
            }];
        }
        lastView = view;
    }
    [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.greaterThanOrEqualTo(@0);
        make.right.equalTo(@0).priority(999);
    }];
}

//更新默认column 选中及未选中效果
- (void)_resetColumAtIndex:(NSInteger)index fromIndex:(NSInteger)fromIndex{
    UIView *toView = (index < 0 || index > _numberOfColumns - 1) ? nil : _columnItemsArray[index];
    UIView *fromView = (fromIndex < 0 || fromIndex > _numberOfColumns - 1) ? nil:_columnItemsArray[fromIndex];
    if (_showBottomLine) {
        [fromView clearBorder];
        [toView addBorderInPosition:YMMBorderPositionBottom style:YMMBorderStyleSolid borderColor:self.bottomlineColor borderWidth:self.bottomLineHeight];
    }
    //若为默认模式 则控件管理， 否则 自己在delegate里管理视图变化。
    if (_topBarStyle == YMMTopBarStyleDefault) {
        [(UILabel *)toView setTextColor:self.titleSelectedColor];
        [(UILabel *)fromView setTextColor:self.titleNormalColor];
    }
}

#pragma mark - public method
- (UIView *)colomnItemAtIndex:(NSUInteger)index{
    if (index < self.columnItemsArray.count) {
        return self.columnItemsArray[index];
    }
    return nil;
}

- (UIView *)contentViewAtIndex:(NSUInteger)index{
    if (index < self.contentViewsArray.count) {
        return self.contentViewsArray[index];
    }
    return nil;
}

- (void)scrollToColumnAtIndex:(NSInteger)index animated:(BOOL)animated{
    CGFloat width = self.contentScrollView.frame.size.width ? : [UIScreen mainScreen].bounds.size.width;
    CGFloat offsetX = width * index;
    [self.contentScrollView setContentOffset:CGPointMake(offsetX, 0) animated:animated];
}

- (void)reloadData{
    [self confirmDataSource];
}

- (void)reloadTopBarData{
    [self confirmTopBarDatasource];
}

- (void)refreshCurrentColumnContentView{
    NSArray *childVCs = self.viewController.childViewControllers;
    if (self.selectedColumnIndex >= 0 && childVCs.count > self.selectedColumnIndex ) {
        UIViewController *willAppearVC = childVCs[self.selectedColumnIndex];
        if ([willAppearVC conformsToProtocol:@protocol(YMMTopbarContentViewControllerProtocol)] && [willAppearVC respondsToSelector:@selector(viewcontrollerDidDisplayToScreenInTopBar:)]) {
            [_apperedContentViewsIndexs addObject:@(self.selectedColumnIndex)];
            [willAppearVC performSelector:@selector(viewcontrollerDidDisplayToScreenInTopBar:) withObject:self];
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSUInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    [self setSelectedColumnIndex:index];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSUInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    [self setSelectedColumnIndex:index];
}

#pragma mark - getter
- (CGFloat)topTabbarHight{
    return _topTabbarHight ? : kYmmTopBarDefaultHeight;
}

- (UIColor *)titleNormalColor{
    return _titleNormalColor ? : kDefaultTitleNormalColor;
}

- (UIColor *)titleSelectedColor{
    return _titleSelectedColor ? : kDefaultTitleSelectedColor;
}

- (UIColor *)bottomlineColor{
    return _bottomlineColor ? : kDefaultBottomLineColor;
}

- (CGFloat)bottomLineHeight{
    return _bottomLineHeight ? : kYmmTopBarBottomlineHeight;
}

- (UIFont *)titleFont{
    return _titleFont ? : [UIFont systemFontOfSize:kYmmTopBarTitleFont];
}

- (UIView *)topTabbar{
    return _topTabbar ? : ({
        _topTabbar = [UIView new];
        _topTabbar.backgroundColor = [UIColor clearColor];
        _topTabbar;
    });
}

- (UIScrollView *)contentScrollView{
    return _contentScrollView ?: ({
        _contentScrollView = [UIScrollView new];
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.delegate = self;
        _contentScrollView;
    });
}

- (UIView *)scrollViewContentView{
    return _scrollViewContentView ?:({_scrollViewContentView = [UIView new];});
}

#pragma mark - setter
- (void)setSelectedColumnIndex:(NSInteger)selectedColumnIndex{
    if (!_hasLayouted) { //没有layout之前 单纯赋值 不做任何操作
        _selectedColumnIndex = selectedColumnIndex;
        return;
    }
    NSInteger fromIndex = _selectedColumnIndex;
    [self setSelectedColumnIndex:selectedColumnIndex fromIndex:fromIndex needUpdateView:_needUpdateContentViewWhenAppear];
    if (_selectedColumnIndex == selectedColumnIndex) return;
    _selectedColumnIndex = selectedColumnIndex;
    [self scrollToColumnAtIndex:selectedColumnIndex animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(topTabbarView:didSelectColumnAtIndex:fromIndex:)]) {
        [self.delegate topTabbarView:self didSelectColumnAtIndex:_selectedColumnIndex fromIndex:fromIndex];
    }
    [self _resetColumAtIndex:selectedColumnIndex fromIndex:fromIndex];
}

- (void)setSelectedColumnIndex:(NSInteger)selectedColumnIndex fromIndex:(NSInteger)fromIndex needUpdateView:(BOOL)needUpdateView{
    //当前selectedindex 是否被渲染过
    BOOL hasAppeared = [_apperedContentViewsIndexs containsObject:@(selectedColumnIndex)];
    if (!needUpdateView && hasAppeared) return;
    if (fromIndex == selectedColumnIndex) return;
    NSArray *childVCs = self.viewController.childViewControllers;
    if (fromIndex >= 0 && childVCs.count > fromIndex ) {
        UIViewController *willDisappearVC = childVCs[fromIndex];
        if ([willDisappearVC conformsToProtocol:@protocol(YMMTopbarContentViewControllerProtocol)] && [willDisappearVC respondsToSelector:@selector(viewcontrollerDidDissmissFromScreenInTopBar:)]) {
            [_apperedContentViewsIndexs removeObject:@(fromIndex)];
            [willDisappearVC performSelector:@selector(viewcontrollerDidDissmissFromScreenInTopBar:) withObject:self];
        }
    }
    if (selectedColumnIndex >= 0 && childVCs.count > selectedColumnIndex) {
        UIViewController *willAppearVC = childVCs[selectedColumnIndex];
        if ([willAppearVC conformsToProtocol:@protocol(YMMTopbarContentViewControllerProtocol)] && [willAppearVC respondsToSelector:@selector(viewcontrollerDidDisplayToScreenInTopBar:)]) {
            [_apperedContentViewsIndexs addObject:@(selectedColumnIndex)];
            [willAppearVC performSelector:@selector(viewcontrollerDidDisplayToScreenInTopBar:) withObject:self];
        }
    }
    
}

#pragma mark - getter
- (UIViewController *)viewController{
    return _viewController ?: self.topViewController;
}

@end
