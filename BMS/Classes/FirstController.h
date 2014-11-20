#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Finch.h"
#import "Sound.h"

@interface FirstController : UITableViewController <UITableViewDelegate> {	
	NSMutableArray *listOfItems;
	UISlider *gainSlider, *speedSlider;
	UIView *subControls;
	UILabel *speedLabel, *gainLabel;
}

- (void)updateFromSliders;
- (NSString *)speedDescription:(NSString *)spd;
- (void)stopSound;
- (void)launchWWW;

@property (nonatomic, retain) UISlider *gainSlider, *speedSlider;
@property (nonatomic, retain) UIView *subControls;
@property (nonatomic, retain) UILabel *speedLabel, *gainLabel;
@property (nonatomic, retain) Finch *engine;
@property (nonatomic, retain) Sound *soundFile;

@end
