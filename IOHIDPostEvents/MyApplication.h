/* MyApplication */

#import <Cocoa/Cocoa.h>
#import "MyHIDDevice.h"

@interface MyApplication : NSObject
{
	MyHIDDevice	*myHIDDevice;
}
- (IBAction)a:(id)sender;
- (IBAction)b:(id)sender;
- (IBAction)buttonUpDown:(id)sender;
- (IBAction)c:(id)sender;
- (IBAction)cursorDown:(id)sender;
- (IBAction)cursorLeft:(id)sender;
- (IBAction)cursorRight:(id)sender;
- (IBAction)cursorUp:(id)sender;
- (IBAction)d:(id)sender;
- (IBAction)e:(id)sender;
- (IBAction)eject:(id)sender;
- (IBAction)f:(id)sender;
- (IBAction)mute:(id)sender;
- (IBAction)quit:(id)sender;
- (IBAction)volumeDown:(id)sender;
- (IBAction)volumeUp:(id)sender;
- (IBAction)CmdOnOff:(id)sender;
- (IBAction)ShiftOnOff:(id)sender;
@end
