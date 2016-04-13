//
//  HNPlaceholderLabel.m
//  HNBouncyPlaceholderTextField
//
//  Created by 许浩男 on 16/4/12.
//  Copyright © 2016年 Zakariyya. All rights reserved.
//

#import "HNPlaceholderLabel.h"

@implementation HNPlaceholderLabel

- (instancetype)init{
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    self.textColor = [UIColor lightGrayColor];
}


@end
