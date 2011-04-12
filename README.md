ZIPToState
==========

ZIPToState is a simple iOS library for doing ZIP code lookups. No internet
or large ZIP database is required, the provided zipranges.plist file
includes all US states broken down by the ZIP code ranges they use.

Scripts are included to generate updated ZIP range property lists from a
source SQLite database (you must provide).

Usage:

    #include "ZIPToState.h"

	// ...

	ZIPToState *zipToState = [[ZIPToState alloc] init];
	NSString *zip = @"92629";
	NSString *stateCode = [zipToState stateCodeForZip:zip];
	NSString *stateName = [[zipToState infoForZip:zip] objectForKey:@"state"];

ZIPToState is provided as a static library. If you prefer to include the
source in your project, just copy these two files:

* ZIPToState.m
* ZIPToState.h

