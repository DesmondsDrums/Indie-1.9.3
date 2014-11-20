#import <UIKit/UIKit.h>

#ifdef UI_USER_INTERFACE_IDIOM 
#define IPHONE()(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
#else
#define IPHONE()(true)
#endif

#define APPIRATER_APP_ID	437728569
#define APPIRATER_DEBUG		NO

@class FirstController, SecondController;

@interface BMSAppDelegate : NSObject <UIApplicationDelegate> {
	IBOutlet UIWindow *window;
	UINavigationController *navigationController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end
