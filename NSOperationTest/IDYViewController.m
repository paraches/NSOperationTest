//
//  IDYViewController.m
//  NSOperationTest
//
//  Created by 手代木 伸一 on 12/02/15.
//  Copyright (c) 2012年 paraches. All rights reserved.
//

#import "IDYViewController.h"
#import "getImageOperation.h"
#import "getImageOperationConCurrent.h"

#define MATRIX_COUNT	3

@implementation IDYViewController
@synthesize opCountSwitch, isConcurrent;
@synthesize urlArray;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.urlArray = [NSArray arrayWithObjects:
						 @"http://www.paraches.com/wp-content/uploads/2012/02/contentsManagerIcon.jpg",
						 @"http://www.paraches.com/wp-content/uploads/2011/10/IMG_3047.png",
						 @"http://www.paraches.com/wp-content/uploads/2012/01/eyeCatch1.png",
						 @"http://www.paraches.com/wp-content/uploads/2012/01/vitaNearOnlineIDIcon.png",
						 @"http://www.paraches.com/wp-content/uploads/2012/01/eyeCatch.png",
						 @"http://storeimages.apple.com/5944/as-images.apple.com/is/image/AppleInc/step0-touch-inthebox?wid=62&hei=114&fmt=png-alpha&qlt=95",
						 @"http://storeimages.apple.com/5944/as-images.apple.com/is/image/AppleInc/step0-touch-applecare?wid=112&hei=124&fmt=png-alpha&qlt=95",
						 @"http://images.apple.com/jp/macbookpro/images/features_processor_icon20110224.jpg",
						 @"http://images.apple.com/jp/macbookpro/images/features_graphics_icon20110224.jpg",
						 nil];

	for (int y=0; y<MATRIX_COUNT; y++) {
		for (int x=0; x<MATRIX_COUNT; x++) {
			UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5+106*x, 5+106*y, 96, 96)];
			imageView.backgroundColor = [UIColor blackColor];
			imageView.tag = 1000 + y*MATRIX_COUNT+x;
			[self.view addSubview:imageView];
		}
	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)startThreads:(id)sender
{
	NSOperationQueue *queue = [[[NSOperationQueue alloc] init] autorelease];
	if (self.opCountSwitch.on) {
		[queue setMaxConcurrentOperationCount:3];
	}
	for (int y=0; y<MATRIX_COUNT; y++) {
		for (int x=0; x<MATRIX_COUNT; x++) {
			UIImageView *iv = (UIImageView *)[self.view viewWithTag:1000 + y*MATRIX_COUNT+x];
			iv.image = nil;
			NSURL *url = [NSURL URLWithString:[self.urlArray objectAtIndex:y*MATRIX_COUNT+x]];
			if (self.isConcurrent.on) {
				getImageOperationConCurrent *gio = [[getImageOperationConCurrent alloc] initWithURL:url imageView:iv];
				[queue addOperation:gio];
				[gio release];
			}
			else {
				getImageOperation *gio = [[getImageOperation alloc] initWithURL:url imageView:iv];
				[queue addOperation:gio];
				[gio release];
			}
		}
	}
}

@end
