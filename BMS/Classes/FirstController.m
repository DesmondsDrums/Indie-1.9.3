#import "BMSAppDelegate.h"
#import "FirstController.h"

@implementation FirstController
@synthesize gainSlider, speedSlider, subControls, speedLabel, gainLabel, engine, soundFile;

#pragma mark -
#pragma mark View Related

- (void)viewDidLoad {
    [super viewDidLoad];
	
	listOfItems = [[NSMutableArray alloc] init];	
	[listOfItems addObject:[NSDictionary dictionaryWithObject: [NSArray arrayWithObjects:
                                                                @"Fill 2",
                                                                @"Chorus 1",
                                                                @"Chorus 2",
                                                                @"Verse 1",
                                                                @"Crash",
                                                                @"Verse 2",
                                                                
                                                                @"Breakdown",
                                                                @"Fill 1",
                                                                @"Outro",
                                                                @"Chorus 3",
                                                                @"Verse 3",
                                                                @"Verse 4",
                                                                @"Chorus 4",
                                                                @"Hi-Hats",
                                                                @"Intro",
                                                                @"High Tom",
                                                                @"Low Tom",
                                                                @"Snare Long",
                                                                @"Snare Short",
                                                               
                                                            nil] forKey: @"Category"]];
}

- (void)viewWillAppear:(BOOL)animated {
	if (IPHONE()) self.parentViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"FirstBG.png"]];
	else self.parentViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"FirstBG-iPad.png"]];
	self.navigationController.navigationBarHidden = NO;
	self.navigationItem.title = @"Indie Drum Loops";
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
											   initWithTitle:@"WEB" 
											   style:UIBarButtonItemStylePlain
											   target:self
											   action:@selector(launchWWW)] autorelease];
	self.tableView.separatorColor = [UIColor whiteColor];
	self.tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	subControls = [[UIView alloc] init];
	if (IPHONE()) {
	subControls.frame = CGRectMake(0, 436, 320, 44);
	subControls.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"subControlsBG.png"]];
	}
	else {
		subControls.frame = CGRectMake(0, 980, 768, 44);
		subControls.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"subControlsBG-iPad.png"]];		
	}
	
	if (IPHONE()) speedLabel = [[UILabel alloc] initWithFrame: CGRectMake(3, 0, 172, 21)];
	else speedLabel = [[UILabel alloc] initWithFrame: CGRectMake(3, 0, 537, 21)];
	speedLabel.textAlignment = UITextAlignmentLeft;
	speedLabel.textColor = [UIColor whiteColor];
	speedLabel.backgroundColor = [UIColor clearColor];
	speedLabel.font = [UIFont fontWithName: @"Helvetica-Bold" size:(14.0)];
	speedLabel.shadowColor = [UIColor blackColor];
	speedLabel.shadowOffset = CGSizeMake(0,1);
	[subControls addSubview: speedLabel];
	
	if (IPHONE()) speedSlider = [[UISlider alloc] initWithFrame: CGRectMake(0, 21, 175, 23)];
	else speedSlider = [[UISlider alloc] initWithFrame: CGRectMake(0, 21, 540, 23)];
	[speedSlider addTarget:self action:@selector(updateFromSliders) forControlEvents:UIControlEventValueChanged];
	[speedSlider setBackgroundColor:[UIColor clearColor]];
	speedSlider.minimumValue = 1.0;
	if (IPHONE()) speedSlider.maximumValue = 15.0;
	else speedSlider.maximumValue = 25.0;
	speedSlider.continuous = YES;
	speedSlider.value = [defaults doubleForKey: @"speed"];
	[subControls addSubview: speedSlider];
	
	if (IPHONE()) gainLabel = [[UILabel alloc] initWithFrame: CGRectMake(178, 0, 84, 21)];
	else gainLabel = [[UILabel alloc] initWithFrame: CGRectMake(543, 0, 167, 21)];
	gainLabel.textAlignment = UITextAlignmentLeft;
	gainLabel.textColor = [UIColor whiteColor];
	gainLabel.backgroundColor = [UIColor clearColor];
	gainLabel.font = [UIFont fontWithName: @"Helvetica-Bold" size:(14.0)];
	gainLabel.shadowColor = [UIColor blackColor];
	gainLabel.shadowOffset = CGSizeMake(0,1);	
	[subControls addSubview: gainLabel];
	
	if (IPHONE()) gainSlider = [[UISlider alloc] initWithFrame: CGRectMake(175, 21, 87, 23)];
	else gainSlider = [[UISlider alloc] initWithFrame: CGRectMake(540, 21, 170, 23)];
	[gainSlider addTarget:self action:@selector(updateFromSliders) forControlEvents:UIControlEventValueChanged];
	[gainSlider setBackgroundColor:[UIColor clearColor]];
	gainSlider.minimumValue = 0.0;
	gainSlider.maximumValue = 11.0;
	gainSlider.continuous = YES;
	gainSlider.value = [defaults doubleForKey: @"gain"];
	[subControls addSubview: gainSlider];

	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	if (IPHONE()) button.frame = CGRectMake(267, 7, 48, 30);
	else button.frame = CGRectMake(715, 7, 48, 30);
	[button setImage:[UIImage imageNamed:@"Stop.png"] forState:UIControlStateNormal];
	[button setImage:[UIImage imageNamed:@"StopDown.png"] forState:UIControlStateHighlighted];
	[button addTarget:self action:@selector(stopSound) forControlEvents:UIControlEventTouchUpInside];
	[subControls addSubview: button];

	[self updateFromSliders];
	[self.parentViewController.view addSubview: subControls];
}

- (void)viewWillDisappear:(BOOL)animated {
	[subControls removeFromSuperview];
	subControls = nil;
	[super viewWillDisappear:animated];
}

#pragma mark -
#pragma mark Special Functions

- (void)updateFromSliders {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setDouble: speedSlider.value forKey: @"speed"];
	[defaults setDouble: gainSlider.value forKey: @"gain"];
	speedLabel.text = [NSString stringWithFormat: @"Tempo: %@ - %@", [[NSString alloc] initWithFormat: @"%1.0f", speedSlider.value], [self speedDescription: [[NSString alloc] initWithFormat: @"%1.0f", speedSlider.value]]];
	gainLabel.text = [NSString stringWithFormat: @"Gain: %@", [[NSString alloc] initWithFormat: @"%1.0f", gainSlider.value]];
	if (soundFile) {
		if (IPHONE()) [soundFile setPitch: [[[NSString alloc] initWithFormat: @"%1.0f", speedSlider.value] intValue]*0.125];
		else [soundFile setPitch: [[[NSString alloc] initWithFormat: @"%1.0f", speedSlider.value] intValue]*0.076923077];
		[soundFile setGain: [[[NSString alloc] initWithFormat: @"%1.0f", gainSlider.value] intValue]*0.2];
	}
	
	if (IPHONE()) {
		speedSlider.value = [[[NSString alloc] initWithFormat: @"%1.0f", speedSlider.value] doubleValue];
		gainSlider.value = [[[NSString alloc] initWithFormat: @"%1.0f", gainSlider.value] doubleValue];
	}
}

- (NSString *)speedDescription:(NSString *)spd {
	int speed = [spd doubleValue];
	
	if (IPHONE()) {
		if (speed <= 3) return @"Adagio";
		else if (speed <= 7) return @"Andante";
		else if (speed == 8) return @"Moderato";
		else if (speed <= 12) return @"Allegro";
		else if (speed <= 15) return @"Vivacissimo";
		return spd;
	}
	else {
		if (speed <= 5) return @"Adagio";
		else if (speed <= 12) return @"Andante";
		else if (speed == 13) return @"Moderato";
		else if (speed <= 20) return @"Allegro";
		else if (speed <= 25) return @"Vivacissimo";
		return spd;		
	}
}

- (void)stopSound {
	if (soundFile && [soundFile playing]) {
		[soundFile stop];
		[soundFile release];
		soundFile = nil;
		[engine release];
		engine = nil;
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Read"
														message:@"You are currently not playing any music.  Please tap a loop."
													   delegate:nil
											  cancelButtonTitle:@"Ok"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];		
	}
}

- (void)launchWWW {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://desmondsdrums.com"]];	
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Access Denied"
                                                    message:@"You need access to the web to visit DesmondsDrums.com.  Check your parental controls and try again."
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark -
#pragma mark TableView Related

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [listOfItems count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSDictionary *dictionary = [listOfItems objectAtIndex:section];
	NSArray *array = [dictionary objectForKey:@"Category"];
	return [array count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (IPHONE()) return 76;
	else return 151;
}

- (NSIndexPath *)tableView :(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	return indexPath;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	
	NSString *file;
	if (IPHONE()) file = [@"Images.bundle/" stringByAppendingString: [[[[listOfItems objectAtIndex:indexPath.section]
																	objectForKey:@"Category"]
																   objectAtIndex: indexPath.row]
																  stringByAppendingString: @".png"]];
	else file = [@"Images.bundle/" stringByAppendingString: [[[[listOfItems objectAtIndex:indexPath.section]
																		 objectForKey:@"Category"]
																		objectAtIndex: indexPath.row]
																	   stringByAppendingString: @"@2x.png"]];
	NSString *finalPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:file];
	
	cell.textLabel.text = [[[listOfItems objectAtIndex:indexPath.section] objectForKey:@"Category"] objectAtIndex:indexPath.row];
	if (IPHONE()) cell.textLabel.font = [UIFont systemFontOfSize: 22];
	else cell.textLabel.font = [UIFont systemFontOfSize: 38];
	cell.textLabel.textColor = [UIColor whiteColor];
	cell.imageView.opaque = YES;
	cell.imageView.image = [UIImage imageWithContentsOfFile: finalPath];
	if (!IPHONE()) cell.imageView.transform=CGAffineTransformMakeScale(2,2); 
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSString *file = [@"Sounds.bundle/" stringByAppendingString: [[[[listOfItems objectAtIndex:0]
																	objectForKey:@"Category"]
																   objectAtIndex: indexPath.row]
																  stringByAppendingString: @".wav"]];
	NSURL *finalPath = [NSURL fileURLWithPath: [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:file]];
	
	if (soundFile) {
		[soundFile stop];
		[soundFile release];
		soundFile = nil;
		[engine release];
		engine = nil;
	}
	
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	[audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
	engine = [[Finch alloc] init];
	soundFile = [[Sound alloc] initWithFile:finalPath];
	[soundFile setLoop: YES];
	[self updateFromSliders];
	[soundFile play];
}

#pragma mark -
#pragma mark Memory Related

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)dealloc {
	[listOfItems release];
	[gainSlider release];
	[speedSlider release];
	[subControls release];
	[speedLabel release];
	[gainLabel release];
	[engine release];
	[soundFile release];
	[super dealloc];
}

@end
