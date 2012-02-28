//
//  getImageOperation.m
//  NSOperationTest
//
//  Created by 手代木 伸一 on 12/02/15.
//  Copyright (c) 2012年 paraches. All rights reserved.
//

#import "getImageOperation.h"

@implementation getImageOperation

- (id)initWithURL:(NSURL *)imageURL imageView:(UIImageView *)iv {
	self = [super init];

	if (self) {
		url = [imageURL retain];
		imageView = [iv retain];
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

- (void)main {
	NSLog(@"tag:%d start!", imageView.tag);

	//	Prepare activity indicator
	UIActivityIndicatorView *av = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	av.hidesWhenStopped = YES;
	av.center = CGPointMake(imageView.bounds.size.width/2.0, imageView.bounds.size.height/2.0);
	dispatch_async(dispatch_get_main_queue(), ^{
		[imageView addSubview:av];
		[av startAnimating];
	});

	//	Start to download image as Synchronous
	NSURLRequest *request = [NSURLRequest requestWithURL:url
											 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
										 timeoutInterval:60.0];
	NSURLResponse *response = nil;
	NSError *error = nil;
	NSData *data = [NSURLConnection sendSynchronousRequest:request 
										 returningResponse:&response 
													 error:&error];
	if (error == nil) {
		dispatch_async(dispatch_get_main_queue(), ^{
			av.hidden = YES;
			[av removeFromSuperview];
			[av release];
			imageView.image = [UIImage imageWithData:data];
		});
		NSLog(@"tag:%d finished", imageView.tag);
	}
}

@end
