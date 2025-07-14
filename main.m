#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

// Debug logging flag
static const BOOL DEBUG_LOGGING = NO; // Set to YES/NO to enable/disable logging

// Log file path
static NSString * const LOG_FILE_PATH = @"/tmp/openinfinder.log";

@interface OpenInFinderApp : NSObject <NSApplicationDelegate>
@end

@implementation OpenInFinderApp

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    NSArray *args = [[NSProcessInfo processInfo] arguments];
    
    if (DEBUG_LOGGING) {
        // Log the call
        NSString *logMessage = [NSString stringWithFormat:@"%@: Objective-C app called with args: %@\n", [NSDate date], args];
        NSString *pwdMessage = [NSString stringWithFormat:@"%@: PWD: %@\n", [NSDate date], [[NSFileManager defaultManager] currentDirectoryPath]];
        
        NSString *fullLog = [logMessage stringByAppendingString:pwdMessage];
        [fullLog writeToFile:LOG_FILE_PATH atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
    if ([args count] > 1) {
        NSString *filePath = [args objectAtIndex:1];
        [self revealInFinder:filePath];
    } else {
        if (DEBUG_LOGGING) {
            NSString *usageMessage = [NSString stringWithFormat:@"Usage: %@ <file_path>\n", [args objectAtIndex:0]];
            [usageMessage writeToFile:LOG_FILE_PATH atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
    }
    
    [NSApp terminate:nil];
}

- (BOOL)application:(NSApplication *)sender openFile:(NSString *)filename {
    // This method is called when a file is opened with the app
    if (DEBUG_LOGGING) {
        NSString *logMessage = [NSString stringWithFormat:@"%@: Objective-C app openFile called with: %@\n", [NSDate date], filename];
        [logMessage writeToFile:LOG_FILE_PATH atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
    [self revealInFinder:filename];
    [NSApp terminate:nil];
    return YES;
}

- (void)revealInFinder:(NSString *)filePath {
    if (DEBUG_LOGGING) {
        NSString *logMessage = [NSString stringWithFormat:@"%@: Revealing file: %@\n", [NSDate date], filePath];
        [logMessage writeToFile:LOG_FILE_PATH atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
    NSURL *url = [NSURL fileURLWithPath:filePath];
    [[NSWorkspace sharedWorkspace] selectFile:filePath inFileViewerRootedAtPath:[url.URLByDeletingLastPathComponent path]];
}

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSApplication *app = [NSApplication sharedApplication];
        OpenInFinderApp *delegate = [[OpenInFinderApp alloc] init];
        [app setDelegate:delegate];
        [app run];
    }
    return 0;
}