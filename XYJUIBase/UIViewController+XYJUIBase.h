//
//  UIViewController+XYJUIBase.h
//  XYJUIBase
//
//  Created by 肖迎军 on 2021/3/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XYJViewAppearStatus) {
    XYJViewDidDisappear,
    XYJViewWillAppear,
    XYJViewDidAppear,
    XYJViewWillDisappear
};


typedef void(^xyj_viewEventHandler)(UIViewController * viewController);
typedef void(^xyj_viewAppearHandler)(UIViewController * viewController, BOOL animated);


@interface UIViewController (XYJUIBase)

@property (nonatomic, assign, readonly) XYJViewAppearStatus xyj_viewAppearStatus;
// 可视状态
@property (nonatomic, assign, readonly) BOOL xyj_viewIsVisiable;
// Appear状态
@property (nonatomic, assign, readonly) BOOL xyj_viewIsAppear;
// 活跃状态
@property (nonatomic, assign, readonly) BOOL xyj_viewIsActive;

- (void) xyj_viewIsVisiableChanged;
- (void) xyj_viewIsAppearChanged;
- (void) xyj_viewIsActiveChanged;

@property (nonatomic) xyj_viewEventHandler xyj_viewDidLoadHandler;
@property (nonatomic) xyj_viewEventHandler xyj_viewDidLayoutSubviewsHandler;
@property (nonatomic) xyj_viewEventHandler xyj_viewSafeAreaInsetsDidChangeHandler;
@property (nonatomic) xyj_viewAppearHandler xyj_viewWillAppearHandler;
@property (nonatomic) xyj_viewAppearHandler xyj_viewDidAppearHandler;
@property (nonatomic) xyj_viewAppearHandler xyj_viewWillDisappearHandler;
@property (nonatomic) xyj_viewAppearHandler xyj_viewDidDisappearHandler;
@property (nonatomic) xyj_viewEventHandler xyj_viewIsVisiableChangedHandler;
@property (nonatomic) xyj_viewEventHandler xyj_viewIsAppearChangedHandler;
@property (nonatomic) xyj_viewEventHandler xyj_viewIsActiveChangedHandler;

@end

NS_ASSUME_NONNULL_END
