//
//	DKRevealLoader
//

#import <dlfcn.h>
#import <UIKit/UIKit.h>

@interface DKRevealLoader : NSObject

@end

@implementation DKRevealLoader

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static DKRevealLoader *_sharedInstance;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });

    return _sharedInstance;
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
	NSDictionary *preferences = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/org.kostyshyn.DKRevealLoader.plist"];
	NSString *dylibPath = @"/Library/Application Support/DKRevealLoader/libReveal.dylib";

	if (![[NSFileManager defaultManager] fileExistsAtPath:dylibPath]) {
		NSLog(@"DKRevealLoader: library does not exists at path: %@", dylibPath);
	} else {
		NSLog(@"DKRevealLoader: library found at path: %@", dylibPath);
	}

	NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
	NSString *loaderEnabledKey = [NSString stringWithFormat:@"DKRevealLoader-%@", bundleIdentifier];
	if ([preferences[loaderEnabledKey] boolValue]) {
		dlopen([dylibPath UTF8String], RTLD_NOW);
		NSLog(@"DKRevealLoader: injected successfully");

		[[NSNotificationCenter defaultCenter] postNotificationName:@"IBARevealRequestStart" object:nil];
		NSLog(@"DKRevealLoader: IBARevealRequestStart sent");
	} else {
		NSLog(@"DKRevealLoader: disabled");
	}
}

@end

%ctor {
	[[NSNotificationCenter defaultCenter] addObserver:[DKRevealLoader sharedInstance] 
		selector:@selector(applicationDidBecomeActive:) 
		name:UIApplicationDidBecomeActiveNotification 
		object:nil];
}