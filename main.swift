import Cocoa
import Foundation

class AppDelegate: NSObject, NSApplicationDelegate {
    var shouldTerminate = true
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        let args = CommandLine.arguments
        
        // Log the call with environment info
        let logMessage = "\(Date()): Swift app called with args: \(args)\n"
        let pwdMessage = "\(Date()): PWD: \(FileManager.default.currentDirectoryPath)\n"
        let envMessage = "\(Date()): Environment:\n\(ProcessInfo.processInfo.environment.map { "\($0.key)=\($0.value)" }.joined(separator: "\n"))\n---\n"
        
        let fullLog = logMessage + pwdMessage + envMessage
        try? fullLog.write(to: URL(fileURLWithPath: "/tmp/openinfinder.log"), atomically: false, encoding: .utf8)
        
        if args.count > 1 {
            let filePath = args[1]
            revealInFinder(filePath: filePath)
        } else {
            // No arguments provided - might be called via openFile delegate
            shouldTerminate = false
            let waitMessage = "\(Date()): Waiting for openFile delegate call...\n"
            try? waitMessage.write(to: URL(fileURLWithPath: "/tmp/openinfinder.log"), atomically: true, encoding: .utf8)
            
            // Set a timer to terminate after 2 seconds if no file is opened
            Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
                if self.shouldTerminate {
                    let timeoutMessage = "\(Date()): No file received, terminating with usage info\n"
                    let usageMessage = "Usage: \(args[0]) <file_path>\n"
                    try? (timeoutMessage + usageMessage).write(to: URL(fileURLWithPath: "/tmp/openinfinder.log"), atomically: true, encoding: .utf8)
                    NSApplication.shared.terminate(nil)
                }
            }
        }
        
        if shouldTerminate {
            NSApplication.shared.terminate(nil)
        }
    }
    
    func application(_ sender: NSApplication, openFile filename: String) -> Bool {
        // This method is called when a file is opened with the app
        let logMessage = "\(Date()): Swift app openFile called with: \(filename)\n"
        try? logMessage.write(to: URL(fileURLWithPath: "/tmp/openinfinder.log"), atomically: true, encoding: .utf8)
        
        shouldTerminate = false
        revealInFinder(filePath: filename)
        NSApplication.shared.terminate(nil)
        return true
    }
    
    func revealInFinder(filePath: String) {
        let logMessage = "\(Date()): Revealing file: \(filePath)\n"
        try? logMessage.write(to: URL(fileURLWithPath: "/tmp/openinfinder.log"), atomically: false, encoding: .utf8)
        
        let url = URL(fileURLWithPath: filePath)
        NSWorkspace.shared.selectFile(filePath, inFileViewerRootedAtPath: url.deletingLastPathComponent().path)
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()