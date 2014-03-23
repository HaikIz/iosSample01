//
//  ViewController.m
//  SampleTest01
//
//  Copyright (c) 2014年 CSV. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label01;
@property (weak, nonatomic) IBOutlet UITextField *textfield01;
@property (weak, nonatomic) IBOutlet UITextView *textview01;
@property (nonatomic) NSUUID *proximityUUID;

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

    
    self.proximityUUID = [[NSUUID alloc] initWithUUIDString:@"D456894A-02F0-4CB0-8258-81C187DF45C2"];

    NSString *jsonstr = [NSString stringWithFormat:@"%@.json?major=%@&minor=%@&accuracy=%f&rssi=%ld",
        [self.proximityUUID UUIDString],@"21", @"34", 0.2, (long)99];
    [self getJson: jsonstr] ;
}

- (void)getJson: (NSString *)mes
{
	// request
    NSString *urlstr = [NSString stringWithFormat:@"http://beacon.ruby.iijgio.com/uumes/%@",mes];

    NSLog(@"DEBUG:%@",urlstr);
    
	NSURL *url = [NSURL URLWithString:urlstr];
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
    NSString *message = [NSString stringWithFormat:@"param:%@\njson:%@", mes,data_str];
    
    self.textview01.text = message;
}

@end
