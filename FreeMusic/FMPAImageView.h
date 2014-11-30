//
//  SPMImageAsyncView.h
//  ImageDL
//
//  Created by Pierre Abi-aad on 21/03/2014.
//  Copyright (c) 2014 Pierre Abi-aad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMPAImageView : UIImageView

@property (nonatomic, assign, getter = isCacheEnabled) BOOL cacheEnabled;
@property (nonatomic, strong) UIImageView *containerImageView;

- (id)initWithFrame:(CGRect)frame backgroundProgressColor:(UIColor *)backgroundProgresscolor;
@end
