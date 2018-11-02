//
//  YMMTopTabbarView.h
//  YMMBaseProject
//
//  Created by jaderyang on 2017/9/21.
//  Copyright © 2017年 kevin. All rights reserved.
//  @descripition: 自定义支持滑动切换的segementview， 实现及注释仿造tabbleview 写的 ho-ho

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YMMTopBarStyle) {
    YMMTopBarStyleDefault = 0,                      //default is a lable for title;
    YMMTopBarStyleCustom = 1                        //Custom you have to realize datasouce itemForColumnAtIndex to define your custom topbar item
};

@class YMMTopTabbarView;

@protocol YMMTopbarContentViewControllerProtocol <NSObject>

@optional
//当前显示为该vc的view时调用
- (void)viewcontrollerDidDisplayToScreenInTopBar:(YMMTopTabbarView *)topbar;
//当前vc的view离开屏幕时调用
- (void)viewcontrollerDidDissmissFromScreenInTopBar:(YMMTopTabbarView *)topbar;

@end

@protocol YMMTopTabbarDatasource <NSObject>

@required


/**
 Tells the data source to return the number of columns in table view.
 Parameters
 
 @param topTabbarView the top-tabbar object requesting this information
 @return the number of columns
 */
- (NSInteger)numberOfColumsInTopTabbarView:(YMMTopTabbarView *)topTabbarView;


@optional

//下面两个代理选一个实现就行了。 第二个的优先级高于第一个。
/**
 Ask the data source for a view to insert in a particular location of the toptabbar scroll-content view,
 
 @param topTabbarView a toptabbar-view requesting the view
 @param index an index location in toptabbar-view
 @return An UIView object that the tabbar view can use for specified page.
 */
- (UIView *)topTabbarView:(YMMTopTabbarView *)topTabbarView contentViewForColumnAtIndex:(NSInteger)index;

/**
 Ask the data source for a viewController to insert in a particular location of the toptabbar scroll-content view, note：when you confirmed
 
 @param topTabbarView a toptabbar-view requesting the view
 @param index an index location in toptabbar-view
 @return An UIView object that the tabbar view can use for specified page.
 */
- (UIViewController *)topTabbarView:(YMMTopTabbarView *)topTabbarView contentViewControllerForColumnAtIndex:(NSInteger)index;

/**
 Ask the data source for a view to insert in a particular location of the tobbar-view, if your topTabbar style is YMMTopBarStyleDefault. You need not to obide this method.
 
 @param topTabbarView a toptabbar-view requesting the view
 @param index an index location in toptabbar-view
 @return An UIView object that the tabbar view can use for specified column.
 */
- (UIView *)topTabbarView:(YMMTopTabbarView *)topTabbarView itemForColumnAtIndex:(NSInteger)index;


@end

@protocol YMMTopTabbarDelegate <NSObject>

@optional

/**
 tell the delegate that the specified column is now selected, and another column is now deselected.
 When you choose YMMTopBarStyleCustom to custom your own column item. You should update your item UI in this method.
 
 @param topTabbarView topTabbarView a toptabbar-view requesting the view
 @param index an index location in toptabbar-vie
 @param oldIndex the origin selected index
 */
- (void)topTabbarView:(YMMTopTabbarView *)topTabbarView didSelectColumnAtIndex:(NSInteger)index fromIndex:(NSInteger)oldIndex;

@end

@interface YMMTopTabbarView : UIView

@property (nonatomic, assign, readonly) YMMTopBarStyle topBarStyle;

/**
 The object that acts as the delegate of the table view.
 */
@property (nonatomic, weak) id<YMMTopTabbarDelegate> delegate;

/**
 The object that acts as the data source of the table view.
 */
@property (nonatomic, weak) id<YMMTopTabbarDatasource> dataSource;


/**
 The height of topbar in the topbarView
 */
@property (nonatomic, assign) CGFloat topTabbarHight;

/**
 Number of columns in topTabbarView;
 */
@property (nonatomic, assign, readonly) NSInteger numberOfColumns;


/**
 the property to control bottom-line
 */
@property (nonatomic, assign) BOOL showBottomLine;
@property (nonatomic, assign) CGFloat bottomLineHeight;
@property (nonatomic, strong) UIColor *bottomlineColor;

/**
 the property to control tabbar - titleLabel when tabbarStyle is YMMTopBarStyleDefault
 */
@property (nonatomic, strong) NSArray *topBarTitles;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleNormalColor;
@property (nonatomic, strong) UIColor *titleSelectedColor;

/**
 the selected column index, you can perform the setter method to exchange the show content page
 */
@property (nonatomic, assign) NSInteger selectedColumnIndex;


/**
 the property to control if contentView need to update when appear to window, default is YES;
 The precondition is you have confirmed the protocol <YMMTopbarContentViewControllerProtocol>
 and override the viewcontrollerDidDisplayToScreenInTopBar: method
 */
@property (nonatomic, assign) BOOL needUpdateContentViewWhenAppear;


/**
 Initializes and returns a topTabbar view object having the given style.
 
 @param topBarStyle the tabbar-item is custom or system default
 @return Returns an initialized YMMTopTabbarView object
 */
- (instancetype)initWithtopBarStyle:(YMMTopBarStyle)topBarStyle;


/**
 Returns the column item at the specified index .
 
 @param index The index path locating the column in the tabbar view.
 @return An object representing a column item of the tabbar, or nil if the view is not visible or indexPath is out of range.
 */
- (UIView *)colomnItemAtIndex:(NSUInteger)index;

/**
 Returns the content view at the specified index .
 
 @param index The index path locating the content view in the contentContainer view.
 @return An object representing a contentview of the tabbar, or nil if the view is not visible or indexPath is out of range.
 */
- (UIView *)contentViewAtIndex:(NSUInteger)index;

- (void)scrollToColumnAtIndex:(NSInteger)index animated:(BOOL)animated;


/**
 reload the column data and content data in tabbar view
 */
- (void)reloadData;


/**
 perform the protocal method: @selecotr(viewcontrollerDidDisplayToScreenInTopBar:)
 */
- (void)refreshCurrentColumnContentView;

- (void)reloadTopBarData;

@end

