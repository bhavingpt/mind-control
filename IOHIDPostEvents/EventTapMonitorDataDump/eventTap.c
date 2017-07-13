/*
 *  eventTap.c
 *
	Copyright:		© Copyright 2001 Apple Computer, Inc. All rights reserved.

	Description:	This sample demonstrates the use of the EventTap API
	as presented in CoreGraphics.framework/CGEvents.h

	The EventTap API provides a means for a function to intercept HID Device events
		and to pass them through, alter the events, or swallow the events. This functionality
		is present in Mac OS X 10.4.x and greater.


	Disclaimer:		IMPORTANT:  This Apple software is supplied to you by Apple Computer, Inc.
	("Apple") in consideration of your agreement to the following terms, and your
	use, installation, modification or redistribution of this Apple software
	constitutes acceptance of these terms.  If you do not agree with these terms,
	please do not use, install, modify or redistribute this Apple software.

	In consideration of your agreement to abide by the following terms, and subject
	to these terms, Apple grants you a personal, non-exclusive license, under Apple’s
	copyrights in this original Apple software (the "Apple Software"), to use,
	reproduce, modify and redistribute the Apple Software, with or without
	modifications, in source and/or binary forms; provided that if you redistribute
	the Apple Software in its entirety and without modifications, you must retain
	this notice and the following text and disclaimers in all such redistributions of
	the Apple Software.  Neither the name, trademarks, service marks or logos of
	Apple Computer, Inc. may be used to endorse or promote products derived from the
	Apple Software without specific prior written permission from Apple.  Except as
	expressly stated in this notice, no other rights or licenses, express or implied,
	are granted by Apple herein, including but not limited to any patent rights that
	may be infringed by your derivative works or by other works in which the Apple
	Software may be incorporated.

	The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO
	WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED
	WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR
	PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN
	COMBINATION WITH YOUR PRODUCTS.

	IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR
	CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
						GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
	ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION
	OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF CONTRACT, TORT
	(INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN
	ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

#define NOMOUSEREPORTS	0
#include "eventTap.h"

#if 0
static const char * eventType[] =
{
    "NullEvent", "LMouseDown", "LMouseUp", "RMouseDown", "RMouseUp",
    "MouseMoved", "LMouseDragged", "RMouseDragged", "MouseEntered",
    "MouseExited", "KeyDown", "KeyUp", "FlagsChanged", "Kitdefined",
    "SysDefined", "AppDefined", "Timer", "CursorUpdate",
    "Journaling", "Suspend", "Resume", "Notification",
    "ScrollWheel", "TabletPointer", "TabletProximity",
    "OtherMouseDown", "OtherMouseUp", "OMouseDragged"
};
#endif


/*
	MyCGEventGetSysDefinedValueField makes of private information which is undocumented. The
	function accesses a private structure wnich exists in Mac OS X 10.4.x and can change with 
	any future release of the operating system. This function was derived by assuming that 
	the event ref is a pointer to an array of 256 uint8_t's. 
*/
static void MyCGEventGetSysDefinedValueField(CGEventRef event, uint8_t *syskey1, uint8_t *syskey2)
{
		uint8_t	*data = (uint8_t *)event;

#if __BIG_ENDIAN__		// have to deal with endian issues here
		*syskey2 = data[126];
		*syskey1 = data[125];
#else
		*syskey2 = data[125];
		*syskey1 = data[126];
#endif				
}

CGEventRef eventCallback(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon)
{
//	int64_t			keycode;
//	uint32_t		*keycodedata = (uint32_t*)&keycode;
//	uint32_t		keydata0, keydata1;
//	uint8_t			syskey1, syskey2;
	uint8_t	*data = (uint8_t *)event;
	int				i;
	
	switch (type)
	{
		case NX_NULLEVENT:		  printf ("NULLEVENT      "); break;
		case NX_LMOUSEDRAGGED:    
#if NOMOUSEREPORTS
			return event; break;
#else
			printf ("LMOUSEDRAGGED  "); break;
#endif
		case NX_RMOUSEDRAGGED:    
#if NOMOUSEREPORTS
			return event; break;
#else
			printf ("RMOUSEDRAGGED  "); break;
#endif
		case NX_MOUSEENTERED:     
#if NOMOUSEREPORTS
			return event; break;
#else
			printf ("MOUSEENTERED   "); break;
#endif
		case NX_MOUSEEXITED:      
#if NOMOUSEREPORTS
			return event; break;
#else
			printf ("MOUSEEXITED    "); break;
#endif
		case NX_MOUSEMOVED:       
#if NOMOUSEREPORTS
			return event; break;
#else
			printf ("MOUSEMOVED     "); break;
#endif
		case NX_RMOUSEDOWN:       
#if NOMOUSEREPORTS
			return event; break;
#else
			printf ("RMOUSEDOWN     "); break;
#endif
		case NX_RMOUSEUP:         
#if NOMOUSEREPORTS
			return event; break;
#else
			printf ("RMOUSEUP       "); break;
#endif
		case NX_LMOUSEDOWN:       
#if NOMOUSEREPORTS
			return event; break;
#else
			printf ("LMOUSEDOWN     "); break;
#endif
		case NX_LMOUSEUP:         
#if NOMOUSEREPORTS
			return event; break;
#else
			printf ("LMOUSEUP       "); break;
#endif
		case NX_KEYDOWN:          printf ("KEYDOWN       "); break;
		case NX_KEYUP:            printf ("KEYUP          "); break;
		case NX_SYSDEFINED:       printf ("SYSDEFINED     "); break;
		case NX_FLAGSCHANGED:     printf ("FLAGSCHANGED   "); break;
		case NX_SCROLLWHEELMOVED: printf ("SCROLLWHEELMOVE"); break;
		case NX_OMOUSEDOWN:       
#if NOMOUSEREPORTS
			return event; break;
#else
			printf ("OMOUSEDOWN     "); break;
#endif
		case NX_OMOUSEUP:         
#if NOMOUSEREPORTS
			return event; break;
#else
			printf ("OMOUSEUP       "); break;
#endif
		case NX_OMOUSEDRAGGED:    
#if NOMOUSEREPORTS
			return event; break;
#else
			printf ("OMOUSEDRAGGED  "); break;
#endif
		case NX_TABLETPOINTER:    printf ("TABLETPOINTER  "); break;
		case NX_TABLETPROXIMITY:  printf ("TABLETPROXIMITY"); break;

	}
	
#if __BIG_ENDIAN__		// have to deal with endian issues here
	printf("type: %02x x: ", data[23]); // print event type
#else
	printf("type: %02x x: ", data[20]); // print event type
#endif
	
	for (i = 25; i <= 28; i++)	// print location x field
	{
		printf("%02x", data[i-1]);
	}

	printf(" y: ");
	for (i = 29; i <= 32; i++)	// print location y field
	{
		printf("%02x", data[i-1]);
	}
	
	printf(" time: ");
	for (i = 41; i <= 48; i++)	// print event time stamp
	{
		printf("%02x", data[i-1]);
		if (i % 4 == 0)
			printf(" ");
	}

	printf("modifiers: ");
	for (i = 49; i <= 52; i++)	// print modifier flags field
	{
		printf("%02x", data[i-1]);
	}
	
	printf(" ");
	for (i = 93; i <= 96; i++)	// unknown field
		printf("%02x", data[i-1]);
	
	printf(" ");
	for (i = 101; i <= 104; i++)	// print unknown field
		printf("%02x", data[i-1]);
	
	printf(" ");

	for (i = 109; i <= 116; i++)	// print unknown field
	{
		printf("%02x", data[i-1]);
		if (i % 4 == 0)
			printf(" ");
	}

	printf(" event data: ");

	if ((type == NX_KEYUP) || (type == NX_KEYDOWN))
	{
		NXEventData	*event = (NXEventData *)&data[120];
		printf ("ocr %04x cs %04x cc %04x kc %0x occ %04x kt  %08x ", 
				event->key.origCharSet, event->key.charSet, event->key.charCode, event->key.keyCode, 
				event->key.origCharCode, event->key.keyboardType);
	}
	else
	{
		for (i = 121; i <= 152; i++)	// print event info
		{
			printf("%02x", data[i-1]);
			if (i % 4 == 0)
				printf(" ");
		}
	}
	
	printf("\n");
	
    return event;
}

void eventLogger(CGEventTapLocation location, CGEventTapOptions opts)
{
    CFMachPortRef eventPort;
    CFRunLoopSourceRef  eventSrc;
    CFRunLoopRef	runLoop;
	
    runLoop = CFRunLoopGetCurrent();
    if ( runLoop == NULL )
        printf( "No run loop?\n" );
	
    eventPort = CGEventTapCreate(location,
								 kCGHeadInsertEventTap,
								 opts,
								 (CGEventMask) ~0ULL,
								 eventCallback,
								 (void*)NULL );
    if ( eventPort == NULL )
    {
        printf( "NULL event port\n" );
        exit( 1 );
    }
	
    eventSrc = CFMachPortCreateRunLoopSource(NULL, eventPort, 0);
    if ( eventPort == NULL )
        printf( "No event run loop src?\n" );
	
    CFRunLoopAddSource(runLoop,  eventSrc, kCFRunLoopDefaultMode);
    CFRunLoopRun();
}

