//
//  UIViewController+XYJUIBase.m
//  XYJUIBase
//
//  Created by 肖迎军 on 2021/3/3.
//

#import "UIViewController+XYJUIBase.h"
#import <objc/runtime.h>

static void class_instanceMethod_exchangeImplementations(Class _Nullable cls, SEL _Nonnull n1, SEL _Nonnull n2) {
    Method m1 = class_getInstanceMethod(cls, n1);
    Method m2 = class_getInstanceMethod(cls, n2);
    method_exchangeImplementations(m1, m2);
}


@implementation UIViewController (XYJUIBase)

+ (void)load {
    class_instanceMethod_exchangeImplementations(self, @selector(viewDidLoad), @selector(xyj_viewDidLoad));
    class_instanceMethod_exchangeImplementations(self, @selector(viewDidLayoutSubviews), @selector(xyj_viewDidLayoutSubviews));
    if (@available(iOS 11.0, *)) {
        class_instanceMethod_exchangeImplementations(self, @selector(viewSafeAreaInsetsDidChange), @selector(xyj_viewSafeAreaInsetsDidChange));
    }
    class_instanceMethod_exchangeImplementations(self, @selector(viewWillAppear:), @selector(xyj_viewWillAppear:));
    class_instanceMethod_exchangeImplementations(self, @selector(viewDidAppear:), @selector(xyj_viewDidAppear:));
    class_instanceMethod_exchangeImplementations(self, @selector(viewWillDisappear:), @selector(xyj_viewWillDisappear:));
    class_instanceMethod_exchangeImplementations(self, @selector(viewDidDisappear:), @selector(xyj_viewDidDisappear:));
}

- (void)xyj_viewDidLoad {
    [self xyj_viewDidLoad];
    
    xyj_viewEventHandler handler = self.xyj_viewDidLoadHandler;
    if (handler != nil) {
        handler(self);
    }
}

- (void)xyj_viewDidLayoutSubviews {
    [self xyj_viewDidLayoutSubviews];
    
    xyj_viewEventHandler handler = self.xyj_viewDidLayoutSubviewsHandler;
    if (handler != nil) {
        handler(self);
    }
}

- (void)xyj_viewSafeAreaInsetsDidChange {
    if (@available(iOS 11.0, *)) {
        [self xyj_viewSafeAreaInsetsDidChange];
        xyj_viewEventHandler handler = self.xyj_viewSafeAreaInsetsDidChangeHandler;
        if (handler != nil) {
            handler(self);
        }
    }
}

- (void)xyj_viewWillAppear:(BOOL)animated {
    [self xyj_viewWillAppear:animated];
    
    self.xyj_viewAppearStatus = XYJViewWillAppear;
    
    self.xyj_viewIsVisiable = YES;
    [self xyj_viewIsVisiableChanged];
    
    xyj_viewAppearHandler handler = self.xyj_viewWillAppearHandler;
    if (handler != nil) {
        handler(self, animated);
    }
}

- (void)xyj_viewDidAppear:(BOOL)animated {
    [self xyj_viewDidAppear:animated];
    
    self.xyj_viewAppearStatus = XYJViewDidAppear;
    
    if (!self.xyj_viewIsAppear) {
        self.xyj_viewIsAppear = YES;
        [self xyj_viewIsAppearChanged];
    }
    
    self.xyj_viewIsActive = YES;
    [self xyj_viewIsActiveChanged];
    
    xyj_viewAppearHandler handler = self.xyj_viewDidAppearHandler;
    if (handler != nil) {
        handler(self, animated);
    }
}

- (void)xyj_viewWillDisappear:(BOOL)animated {
    [self xyj_viewWillDisappear:animated];
    
    self.xyj_viewAppearStatus = XYJViewWillDisappear;
    
    self.xyj_viewIsActive = NO;
    [self xyj_viewIsActiveChanged];
    
    xyj_viewAppearHandler handler = self.xyj_viewWillDisappearHandler;
    if (handler != nil) {
        handler(self, animated);
    }
}

- (void)xyj_viewDidDisappear:(BOOL)animated {
    [self xyj_viewDidDisappear:animated];
    
    self.xyj_viewAppearStatus = XYJViewDidDisappear;
    
    self.xyj_viewIsVisiable = NO;
    [self xyj_viewIsVisiableChanged];
    
    if (self.xyj_viewIsAppear) {
        self.xyj_viewIsAppear = NO;
        [self xyj_viewIsAppearChanged];
    }
    
    xyj_viewAppearHandler handler = self.xyj_viewDidDisappearHandler;
    if (handler != nil) {
        handler(self, animated);
    }
}

static char xyj_viewAppearStatusAssociatedKey;
- (void)setXyj_viewAppearStatus:(XYJViewAppearStatus)xyj_viewAppearStatus {
    objc_setAssociatedObject(self, &xyj_viewAppearStatusAssociatedKey, @(xyj_viewAppearStatus), OBJC_ASSOCIATION_ASSIGN);
}
- (XYJViewAppearStatus)xyj_viewAppearStatus {
    NSNumber * obj = (NSNumber*)objc_getAssociatedObject(self, &xyj_viewAppearStatusAssociatedKey);
    if (obj == nil) {
        return XYJViewDidDisappear;
    }
    else {
        return (XYJViewAppearStatus)obj.integerValue;
    }
}

static char xyj_viewIsVisiableAssociatedKey;
- (void)setXyj_viewIsVisiable:(BOOL)xyj_viewIsVisiable {
    objc_setAssociatedObject(self, &xyj_viewIsVisiableAssociatedKey, @(xyj_viewIsVisiable), OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)xyj_viewIsVisiable {
    NSNumber * obj = (NSNumber*)objc_getAssociatedObject(self, &xyj_viewIsVisiableAssociatedKey);
    if (obj == nil) {
        return NO;
    }
    else {
        return obj.boolValue;
    }
}

static char xyj_viewIsAppearAssociatedKey;
- (void)setXyj_viewIsAppear:(BOOL)xyj_viewIsAppear {
    objc_setAssociatedObject(self, &xyj_viewIsAppearAssociatedKey, @(xyj_viewIsAppear), OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)xyj_viewIsAppear {
    NSNumber * obj = (NSNumber*)objc_getAssociatedObject(self, &xyj_viewIsAppearAssociatedKey);
    if (obj == nil) {
        return NO;
    }
    else {
        return obj.boolValue;
    }
}

static char xyj_viewIsActiveAssociatedKey;
- (void)setXyj_viewIsActive:(BOOL)xyj_viewIsActive {
    objc_setAssociatedObject(self, &xyj_viewIsActiveAssociatedKey, @(xyj_viewIsActive), OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)xyj_viewIsActive {
    NSNumber * obj = (NSNumber*)objc_getAssociatedObject(self, &xyj_viewIsActiveAssociatedKey);
    if (obj == nil) {
        return NO;
    }
    else {
        return obj.boolValue;
    }
}

static char xyj_viewDidLoadHandlerAssociatedKey;
- (void)setXyj_viewDidLoadHandler:(xyj_viewEventHandler)xyj_viewDidLoadHandler {
    objc_setAssociatedObject(self, &xyj_viewDidLoadHandlerAssociatedKey, xyj_viewDidLoadHandler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (xyj_viewEventHandler)xyj_viewDidLoadHandler {
    return objc_getAssociatedObject(self, &xyj_viewDidLoadHandlerAssociatedKey);
}

static char xyj_viewDidLayoutSubviewsHandlerAssociatedKey;
- (void)setXyj_viewDidLayoutSubviewsHandler:(xyj_viewEventHandler)xyj_viewDidLayoutSubviewsHandler {
    objc_setAssociatedObject(self, &xyj_viewDidLayoutSubviewsHandlerAssociatedKey, xyj_viewDidLayoutSubviewsHandler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (xyj_viewEventHandler)xyj_viewDidLayoutSubviewsHandler {
    return objc_getAssociatedObject(self, &xyj_viewDidLayoutSubviewsHandlerAssociatedKey);
}

static char xyj_viewSafeAreaInsetsDidChangeHandlerAssociatedKey;
- (void)setXyj_viewSafeAreaInsetsDidChangeHandler:(xyj_viewEventHandler)xyj_viewSafeAreaInsetsDidChangeHandler {
    objc_setAssociatedObject(self, &xyj_viewSafeAreaInsetsDidChangeHandlerAssociatedKey, xyj_viewSafeAreaInsetsDidChangeHandler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (xyj_viewEventHandler)xyj_viewSafeAreaInsetsDidChangeHandler {
    return objc_getAssociatedObject(self, &xyj_viewSafeAreaInsetsDidChangeHandlerAssociatedKey);
}

static char xyj_viewWillAppearHandlerAssociatedKey;
- (void)setXyj_viewWillAppearHandler:(xyj_viewAppearHandler)xyj_viewWillAppearHandler {
    objc_setAssociatedObject(self, &xyj_viewWillAppearHandlerAssociatedKey, xyj_viewWillAppearHandler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (xyj_viewAppearHandler)xyj_viewWillAppearHandler {
    return objc_getAssociatedObject(self, &xyj_viewWillAppearHandlerAssociatedKey);
}

static char xyj_viewDidAppearHandlerAssociatedKey;
- (void)setXyj_viewDidAppearHandler:(xyj_viewAppearHandler)xyj_viewDidAppearHandler {
    objc_setAssociatedObject(self, &xyj_viewDidAppearHandlerAssociatedKey, xyj_viewDidAppearHandler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (xyj_viewAppearHandler)xyj_viewDidAppearHandler {
    return objc_getAssociatedObject(self, &xyj_viewDidAppearHandlerAssociatedKey);
}

static char xyj_viewWillDisappearHandlerAssociatedKey;
- (void)setXyj_viewWillDisappearHandler:(xyj_viewAppearHandler)xyj_viewWillDisappearHandler {
    objc_setAssociatedObject(self, &xyj_viewWillDisappearHandlerAssociatedKey, xyj_viewWillDisappearHandler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (xyj_viewAppearHandler)xyj_viewWillDisappearHandler {
    return objc_getAssociatedObject(self, &xyj_viewWillDisappearHandlerAssociatedKey);
}

static char xyj_viewDidDisappearHandlerAssociatedKey;
- (void)setXyj_viewDidDisappearHandler:(xyj_viewAppearHandler)xyj_viewDidDisappearHandler {
    objc_setAssociatedObject(self, &xyj_viewDidDisappearHandlerAssociatedKey, xyj_viewDidDisappearHandler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (xyj_viewAppearHandler)xyj_viewDidDisappearHandler {
    return objc_getAssociatedObject(self, &xyj_viewDidDisappearHandlerAssociatedKey);
}

static char xyj_viewIsActiveChangedHandlerAssociatedKey;
- (void)setXyj_viewIsActiveChangedHandler:(xyj_viewEventHandler)xyj_viewIsActiveChangedHandler {
    objc_setAssociatedObject(self, &xyj_viewIsActiveChangedHandlerAssociatedKey, xyj_viewIsActiveChangedHandler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (xyj_viewEventHandler)xyj_viewIsActiveChangedHandler {
    return objc_getAssociatedObject(self, &xyj_viewIsActiveChangedHandlerAssociatedKey);
}

static char xyj_viewIsAppearChangedHandlerAssociatedKey;
- (void)setXyj_viewIsAppearChangedHandler:(xyj_viewEventHandler)xyj_viewIsAppearChangedHandler {
    objc_setAssociatedObject(self, &xyj_viewIsAppearChangedHandlerAssociatedKey, xyj_viewIsAppearChangedHandler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (xyj_viewEventHandler)xyj_viewIsAppearChangedHandler {
    return objc_getAssociatedObject(self, &xyj_viewIsAppearChangedHandlerAssociatedKey);
}

static char xyj_viewIsVisiableChangedAssociatedKey;
- (void)setXyj_viewIsVisiableChangedHandler:(xyj_viewEventHandler)xyj_viewIsVisiableChangedHandler {
    objc_setAssociatedObject(self, &xyj_viewIsVisiableChangedAssociatedKey, xyj_viewIsVisiableChangedHandler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (xyj_viewEventHandler)xyj_viewIsVisiableChangedHandler {
    return objc_getAssociatedObject(self, &xyj_viewIsVisiableChangedAssociatedKey);
}


- (void) xyj_viewIsVisiableChanged {
    xyj_viewEventHandler handler = self.xyj_viewIsVisiableChangedHandler;
    if (handler != nil) {
        handler(self);
    }
}

- (void) xyj_viewIsAppearChanged {
    xyj_viewEventHandler handler = self.xyj_viewIsVisiableChangedHandler;
    if (handler != nil) {
        handler(self);
    }
}

- (void) xyj_viewIsActiveChanged {
    xyj_viewEventHandler handler = self.xyj_viewIsActiveChangedHandler;
    if (handler != nil) {
        handler(self);
    }
}


@end
