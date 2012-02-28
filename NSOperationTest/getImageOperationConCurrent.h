//
//  getImageOperationConCurrent.h
//  NSOperationTest
//
//  Created by 手代木 伸一 on 12/02/27.
//  Copyright (c) 2012年 paraches. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface getImageOperationConCurrent : NSOperation {
	NSURL *url;
	UIImageView *imageView;
	UIActivityIndicatorView *av;
	NSMutableData *responseData;
	BOOL isExecuting, isFinished;
}

- (id)initWithURL:(NSURL *)imageURL imageView:(UIImageView *)iv;

@end
