#import "MyApplication.h"

@implementation MyApplication

-(id)init {
	self = [super init];
	if (self) 
	{
		// send the init event to MyHIDDevice
		myHIDDevice = [[MyHIDDevice alloc] init];
	}	
	return self;
}

-(void) dealloc {
	// release the myHIDDevice
	[myHIDDevice release];
	
	[super dealloc];
}

// simluate a button down/up sequence - if you do not send the button up event, the system will hang
- (IBAction)buttonUpDown:(id)sender
{
	id			selectedOne;
	NSString	*title;
	Boolean		buttonDown;

	// track the state of the Cmd on/off radio button
	// sender is an NSMatrix so get the selected cell of the NSButton object
	selectedOne = [sender selectedCell];
	title = [selectedOne title];
	buttonDown = NSOrderedSame == [title compare:@"Mouse Down"];
	if (buttonDown)
	{
		[myHIDDevice postMouseButtonEvent:TRUE];		// this will cause the mouse button to change name momentarily.
		[selectedOne setTitle:@"Mouse Up"];
		[myHIDDevice postMouseButtonEvent:FALSE];
	}
	else
	{
		[selectedOne setTitle:@"Mouse Down"];
	}
}

- (IBAction)cursorDown:(id)sender
{
	static	int down = 0;
	
	down += 5;
	[myHIDDevice postCursorMoveEvent: 0: down];
}

- (IBAction)cursorLeft:(id)sender
{
	static int left = 0;
	left -= 5;
	[myHIDDevice postCursorMoveEvent: left: 0];
}

- (IBAction)cursorRight:(id)sender
{
	static int right = 0;
	right += 5;
	[myHIDDevice postCursorMoveEvent: right: 0];
}

- (IBAction)cursorUp:(id)sender
{
	static	int up = 0;

	up -= 5;
	[myHIDDevice postCursorMoveEvent: 0: up];
}

- (IBAction)a:(id)sender
{
	[myHIDDevice postKeyCodeEvent: 0x00:KEY_DOWN:IS_NOT_REPEAT];
	[myHIDDevice postKeyCodeEvent: 0x00:KEY_UP:IS_NOT_REPEAT];
//	NSLog(@"a pressed");
}

- (IBAction)b:(id)sender
{
	[myHIDDevice postKeyCodeEvent: 0x0b:KEY_DOWN:IS_NOT_REPEAT];
	[myHIDDevice postKeyCodeEvent: 0x0b:KEY_UP:IS_NOT_REPEAT];
//	NSLog(@"b pressed");
}

- (IBAction)c:(id)sender
{
	[myHIDDevice postKeyCodeEvent: 0x08:KEY_DOWN:IS_NOT_REPEAT];
	[myHIDDevice postKeyCodeEvent: 0x08:KEY_UP:IS_NOT_REPEAT];
//	NSLog(@"c pressed");
}

- (IBAction)d:(id)sender
{
	[myHIDDevice postKeyCodeEvent: 0x02:KEY_DOWN:IS_NOT_REPEAT];
	[myHIDDevice postKeyCodeEvent: 0x02:KEY_UP:IS_NOT_REPEAT];
//	NSLog(@"d pressed");
}

- (IBAction)e:(id)sender
{
	[myHIDDevice postKeyCodeEvent: 0x0e:KEY_DOWN:IS_NOT_REPEAT];
	[myHIDDevice postKeyCodeEvent: 0x0e:KEY_UP:IS_NOT_REPEAT];
//	NSLog(@"e pressed");
}

- (IBAction)f:(id)sender
{
	[myHIDDevice postKeyCodeEvent: 0x0c:KEY_DOWN:IS_NOT_REPEAT];	// simulate pressing 'q' so that we can simulate cmd-q to
	[myHIDDevice postKeyCodeEvent: 0x0c:KEY_UP:IS_NOT_REPEAT];		// quit the sample.
//	NSLog(@" pressed");
}

- (IBAction)eject:(id)sender
{
	// simulate pressing the eject key
	[myHIDDevice postSystemDefineEvent:NX_KEYTYPE_EJECT: TRUE];
	[myHIDDevice postSystemDefineEvent:NX_KEYTYPE_EJECT: FALSE];
	NSLog(@"eject pressed");
}

- (IBAction)mute:(id)sender
{
	// simulate pressing the mute key
	[myHIDDevice postSystemDefineEvent:NX_KEYTYPE_MUTE: TRUE];
	[myHIDDevice postSystemDefineEvent:NX_KEYTYPE_MUTE: FALSE];
	NSLog(@"mute pressed");
}

- (IBAction)quit:(id)sender
{
	[NSApp terminate:nil];
}

- (IBAction)volumeDown:(id)sender
{
	// simulate pressing the volume down key
	[myHIDDevice postSystemDefineEvent:NX_KEYTYPE_SOUND_DOWN:TRUE];
	[myHIDDevice postSystemDefineEvent:NX_KEYTYPE_SOUND_DOWN:FALSE];
	NSLog(@"volume down pressed");
}

- (IBAction)volumeUp:(id)sender
{
	// simulate pressing the volume up key
	[myHIDDevice postSystemDefineEvent:NX_KEYTYPE_SOUND_UP:TRUE];
	[myHIDDevice postSystemDefineEvent:NX_KEYTYPE_SOUND_UP:FALSE];
	NSLog(@"volume up pressed");
}

- (IBAction)CmdOnOff:(id)sender
{
	id			selectedOne;
	NSString	*stateString;
	Boolean		enabled;

	// track the state of the Cmd on/off radio button
	// sender is an NSMatrix so get the selected cell of the NSButton object
	selectedOne = [sender selectedCell];
	stateString = [selectedOne title];
	NSLog(@"cmd state is %@", [selectedOne title]);
	enabled = NSOrderedSame == [stateString compare:@"Cmd on"];
	[myHIDDevice setCmdState:enabled];
	
	
}

- (IBAction)ShiftOnOff:(id)sender
{
	id	selectedOne;
	NSString	*stateString;
	Boolean		enabled;

	// track the state of the Shift on/off radio button
	// sender is an NSMatrix so get the selected cell of the NSButton object
	selectedOne = [sender selectedCell];
	stateString = [selectedOne title];
	NSLog(@"shift state is %@", [selectedOne title]);
	enabled = NSOrderedSame == [stateString compare:@"Shift on"];
	[myHIDDevice setShiftState:enabled];
}


/* 
quit the app if the window is closed.
 */
- (BOOL)windowShouldClose:(id)sender
{
	[NSApp terminate:nil];
	return YES;
}

@end
