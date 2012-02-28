//
//  getImageOperation.h
//  NSOperationTest
//
//  Created by 手代木 伸一 on 12/02/15.
//  Copyright (c) 2012年 paraches. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface getImageOperation : NSOperation {
	NSURL *url;
	UIImageView *imageView;
}

- (id)initWithURL:(NSURL *)imageURL imageView:(UIImageView *)iv;

@end
