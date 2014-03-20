//
//  ViewController.m
//  SampleTest01
//
//  Created by 活文2G on 2014/03/20.
//  Copyright (c) 2014年 CSV. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label01;
@property (weak, nonatomic) IBOutlet UITextField *textfield01;
@property (weak, nonatomic) IBOutlet UITextView *textview01;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)setText:(id)sender {
    self.label01.text = @"01";
    self.textfield01.text=@"02";
    //self.textview01.text = @"03";

	// request
	NSURL *url = [NSURL URLWithString:@"http://beacon.ruby.iijgio.com/uumes/uuid-test-uuid"];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	NSURLResponse *response = nil;
	NSError *error = nil;
	NSData *data = [
		NSURLConnection
		sendSynchronousRequest : request
		returningResponse : &response
		error : &error
	];

	// error
	NSString *error_str = [error localizedDescription];
	if (0<[error_str length]) {
		UIAlertView *alert = [
			[UIAlertView alloc]
			initWithTitle : @"RequestError"
			message : error_str
			delegate : nil
			cancelButtonTitle : @"OK"
			otherButtonTitles : nil
		];
		[alert show];
//		[alert release];
		return;
	}

	// response
	int enc_arr[] = {
		NSUTF8StringEncoding,			// UTF-8
		NSShiftJISStringEncoding,		// Shift_JIS
		NSJapaneseEUCStringEncoding,	// EUC-JP
		NSISO2022JPStringEncoding,		// JIS
		NSUnicodeStringEncoding,		// Unicode
		NSASCIIStringEncoding			// ASCII
	};
	NSString *data_str = nil;
	int max = sizeof(enc_arr) / sizeof(enc_arr[0]);
	for (int i=0; i<max; i++) {
		data_str = [
			[NSString alloc]
			initWithData : data
			encoding : enc_arr[i]
		];
		if (data_str!=nil) {
			break;
		}
	}
    self.textview01.text = data_str;
}

@end
