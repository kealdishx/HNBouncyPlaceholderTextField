//
//  HNBouncyPlaceholderTextField.m
//  HNBouncyPlaceholderTextField
//
//  Created by 许浩男 on 16/4/11.
//  Copyright © 2016年 Zakariyya. All rights reserved.
//

#import "HNBouncyPlaceholderTextField.h"
#import "HNPlaceholderLabel.h"

static const CFTimeInterval kAnimationDuration = 0.5f;

@interface HNBouncyPlaceholderTextField()

@property (nonatomic,strong) HNPlaceholderLabel *leftPlaceholderLabel;

@property (nonatomic,strong) HNPlaceholderLabel *rightPlaceholderLabel;

@property (nonatomic,copy) NSString *leftPlaceholderStr;

@property (nonatomic,assign) BOOL animateToRightEnable;

@property (nonatomic,assign) BOOL animateToLeftEnable;

@end

@implementation HNBouncyPlaceholderTextField

#pragma mark - init
- (instancetype)init{
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
        self.placeholder = self.placeholder;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    [self observerConfig];
}

- (void)observerConfig{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - lazy load
- (HNPlaceholderLabel *)leftPlaceholderLabel{
    if (!_leftPlaceholderLabel) {
        _leftPlaceholderLabel = [[HNPlaceholderLabel alloc] initWithFrame:[self placeholderRectForBounds:self.bounds]];
        _leftPlaceholderLabel.layer.opacity = 1.0f;
        _leftPlaceholderLabel.font = self.font;
        [self addSubview:_leftPlaceholderLabel];
    }
    return _leftPlaceholderLabel;
}

- (HNPlaceholderLabel *)rightPlaceholderLabel{
    if (!_rightPlaceholderLabel) {
        _rightPlaceholderLabel = [[HNPlaceholderLabel alloc] initWithFrame:[self placeholderRectForBounds:self.bounds]];
        _rightPlaceholderLabel.layer.opacity = 0.0f;
        _rightPlaceholderLabel.font = self.font;
        [self addSubview:_rightPlaceholderLabel];
    }
    return _rightPlaceholderLabel;
}

#pragma mark - setter method
- (void)setPlaceholder:(NSString *)placeholder{
    [super setPlaceholder:nil];
    _leftPlaceholderStr = placeholder;
    self.leftPlaceholderLabel.text = _leftPlaceholderStr;
    if (!self.rightPlaceholder) {
        self.rightPlaceholder = _leftPlaceholderStr;
    }
}

- (void)setRightPlaceholder:(NSString *)rightPlaceholder{
    _rightPlaceholder = rightPlaceholder;
    self.rightPlaceholderLabel.text = _rightPlaceholder;

}


- (void)setFont:(UIFont *)font{
    [super setFont:font];
    self.leftPlaceholderLabel.font = font;
    self.rightPlaceholderLabel.font = font;
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds{
    return [super placeholderRectForBounds:UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(0, 5, 0, 5))];
}

#pragma mark - animation implementation
- (CAKeyframeAnimation *)addPositionAnimationToRight:(BOOL)right{
    CAKeyframeAnimation *postionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    postionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    postionAnimation.duration = kAnimationDuration;
    postionAnimation.removedOnCompletion = NO;
    postionAnimation.values = [self bounceFrameArrToRight:right];
    postionAnimation.additive = YES;
    postionAnimation.fillMode = kCAFillModeForwards;
    return postionAnimation;
}

- (CABasicAnimation *)addFadeAnimationOut:(BOOL)Out{
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    fadeAnimation.fromValue = (Out ? @1 : @0);
    fadeAnimation.toValue = (Out ? @0 : @1);
    fadeAnimation.fillMode = kCAFillModeBoth;
    fadeAnimation.removedOnCompletion = NO;
    fadeAnimation.duration = kAnimationDuration * 0.6;
    return fadeAnimation;
}

- (void)animatePlaceholderToRight:(BOOL)right{
    if (right) {
        [self.leftPlaceholderLabel.layer removeAllAnimations];
        [self.rightPlaceholderLabel.layer removeAllAnimations];
        [self.leftPlaceholderLabel.layer addAnimation:[self addPositionAnimationToRight:right] forKey:@"bounceToRight"];
        [self.leftPlaceholderLabel.layer addAnimation:[self addFadeAnimationOut:YES] forKey:@"fadeOut"];
        [self.rightPlaceholderLabel.layer addAnimation:[self addPositionAnimationToRight:right] forKey:@"bounceToRight"];
        [self.rightPlaceholderLabel.layer addAnimation:[self addFadeAnimationOut:NO] forKey:@"fadeIn"];
        self.animateToRightEnable = NO;
        self.animateToLeftEnable = YES;
    }
    else{
        [self.leftPlaceholderLabel.layer removeAllAnimations];
        [self.rightPlaceholderLabel.layer removeAllAnimations];
        [self.leftPlaceholderLabel.layer addAnimation:[self addPositionAnimationToRight:right] forKey:@"bounceToLeft"];
        [self.leftPlaceholderLabel.layer addAnimation:[self addFadeAnimationOut:NO] forKey:@"fadeIn"];
        [self.rightPlaceholderLabel.layer addAnimation:[self addPositionAnimationToRight:right] forKey:@"bounceToLeft"];
        [self.rightPlaceholderLabel.layer addAnimation:[self addFadeAnimationOut:YES] forKey:@"fadeOut"];
        self.animateToRightEnable = YES;
        self.animateToLeftEnable = NO;
    }
}

- (CGFloat)placeholderBlankWidth{
    return  ([self placeholderRectForBounds:self.bounds].size.width - [self.rightPlaceholder sizeWithAttributes:@{NSFontAttributeName : self.leftPlaceholderLabel.font}].width);
}

- (NSArray *)bounceFrameArrToRight:(BOOL)right{
    int step = 100;
    NSMutableArray *keyFrameArrM = [NSMutableArray arrayWithCapacity:step];
    double blankWidth = (double)[self placeholderBlankWidth];
    for (int i = 0; i < step; i++) {
        double keyFrame = blankWidth * (right ? -1 : 1) * pow(2.2, -0.08 * i) * cos(0.1 * i) + (right ? blankWidth : 0);
        [keyFrameArrM addObject:@(keyFrame)];
    }
    return keyFrameArrM;
}


#pragma mark - notification handler
- (void)textFieldDidBeginEditing:(NSNotification *)noti{
    self.animateToRightEnable = (self.text.length == 0) ? YES : NO;
    self.animateToLeftEnable = !self.animateToRightEnable;
}

- (void)_textDidChange:(NSNotification *)noti{
    if (self.text.length > 0 && self.animateToRightEnable) {
        [self animatePlaceholderToRight:YES];
    }
    else if (self.text.length == 0 && self.animateToLeftEnable){
        [self animatePlaceholderToRight:NO];
    }
}

- (void)textFieldDidEndEditing:(NSNotification *)noti{
    self.animateToRightEnable = (self.text.length == 0) ? YES : NO;
    self.animateToLeftEnable = !self.animateToRightEnable;
}


@end
