/*
 *  eventTap.h
 *  EventTapSample
 *
 *  Created by admin on 2/2/06.
 *  Copyright 2006 __MyCompanyName__. All rights reserved.
 *
 */

#ifndef __EVENT_TAP__
#define __EVENT_TAP__

#include <CoreGraphics/CGEventTypes.h>
#include <CoreGraphics/CGEventSource.h>
#include <CoreGraphics/CGEvent.h>
#include <iokit/hidsystem/IOLLEvent.h>
#include <IOKit/hidsystem/ev_keymap.h>

#include <ApplicationServices/ApplicationServices.h>
#include <stdlib.h>
#include <unistd.h>

#define ALLOWINTERCEPT	1	// to allow this sample to intercept and filter events, set ALLOWINTERCEPT to 1

#if ALLOWINTERCEPT
#define kInterceptOption	0
#else
#define kInterceptOption	kCGEventTapOptionListenOnly
#endif

void eventLogger(CGEventTapLocation location, CGEventTapOptions opts);
void eventLogByPSN(ProcessSerialNumber *pPsn, CGEventTapOptions opts);

#endif   // __EVENT_TAP__