/*
	file: main.c
 
 */

#include <CoreGraphics/CGEventTypes.h>
#include <CoreGraphics/CGEventSource.h>
#include <CoreGraphics/CGEvent.h>
#include <iokit/hidsystem/IOLLEvent.h>

#include <ApplicationServices/ApplicationServices.h>
#include <stdlib.h>
#include <unistd.h>
#include "eventTap.h"

int main(int argc, const char *argv[])
{
	eventLogger(kCGHIDEventTap, kInterceptOption);
    return 0;
}

