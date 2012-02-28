//
//  getImageOperationConCurrent.m
//  NSOperationTest
//
//  Created by 手代木 伸一 on 12/02/27.
//  Copyright (c) 2012年 paraches. All rights reserved.
//

#import "getImageOperationConCurrent.h"

@implementation getImageOperationConCurrent

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString*)key {
	if ([key isEqualToString:@"isExecuting"] || [key isEqualToString:@"isFinished"]) {
		return YES;
	}
	return [super automaticallyNotifiesObserversForKey:key];
}

- (BOOL)isConcurrent {
	return YES;
}

- (BOOL)isExecuting {
	return isExecuting;
}

- (BOOL)isFinished {
	return isFinished;
}

- (id)initWithURL:(NSURL *)imageURL imageView:(UIImageView *)iv {
	self = [super init];
	
	if (self) {
		url = [imageURL retain];
		imageView = [iv retain];

		isExecuting = NO;
		isFinished = NO;
	}  

	return self;
}

- (void)dealloc {
	[url release];
	url = nil;
	
	[imageView release];
	imageView = nil;
	
	[super dealloc];
}

- (void)start {
	NSLog(@"tag:%d start!", imageView.tag);

	[self setValue:[NSNumber numberWithBool:YES] forKey:@"isExecuting"];

	//	Prepare and start activity indicator
	av = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	av.hidesWhenStopped = YES;
	av.center = CGPointMake(imageView.bounds.size.width/2.0, imageView.bounds.size.height/2.0);
	dispatch_async(dispatch_get_main_queue(), ^{
		[imageView addSubview:av];
		[av startAnimating];
	});


	NSURLRequest *request = [NSURLRequest requestWithURL:url
											 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
										 timeoutInterval:60.0];
	NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:self];
	if (conn != nil) {
		// NSURLConnection は RunLoop をまわさないとメインスレッド以外で動かない
		do {
			[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
		} while (isExecuting);
	}

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"%@", @"エラー");
	[self setValue:[NSNumber numberWithBool:NO] forKey:@"isExecuting"];
	[self setValue:[NSNumber numberWithBool:YES] forKey:@"isFinished"];

	[av removeFromSuperview];
	[av release];
	[responseData release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {

	//	Remove activity indicator and show downloaded image
	dispatch_async(dispatch_get_main_queue(), ^{
		[av removeFromSuperview];
		[av release];
		imageView.image = [UIImage imageWithData:responseData];
		[responseData release];
	});

	[self setValue:[NSNumber numberWithBool:NO] forKey:@"isExecuting"];
	[self setValue:[NSNumber numberWithBool:YES] forKey:@"isFinished"];
	NSLog(@"tag:%d finished", imageView.tag);
}


@end
