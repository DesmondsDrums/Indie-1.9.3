#import "BMSAppDelegate.h"
#import "FirstController.h"
#import "Appirater.h"

@implementation BMSAppDelegate

@synthesize window, navigationController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *initialRun = [defaults stringForKey: @"initial"];
	if (initialRun == nil) {
		if (IPHONE()) [defaults setDouble: 8.0 forKey: @"speed"];
		else [defaults setDouble: 13.0 forKey: @"speed"];
		[defaults setDouble: 5.0 forKey: @"gain"];
		[defaults setObject: @"runIsOver" forKey: @"initial"];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Indie Drum Loops"
														message:@"Tap Web to connect to DesmondsDrums.com to download drum samples.  For best results use wth amplified speaker.    I tried to make the easiest drum machine possible, an app that plays a classic variation of drum beats.."
													   delegate:self
											  cancelButtonTitle: @"Ok"
											  otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
	
	[Appirater appLaunched: YES];

	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
}

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}

@end