import Foundation

// Simple Swift version that uses Foundation only
class OpenInFinder {
    static func main() {
        let args = CommandLine.arguments
        
        // Log the call
        let logMessage = "\(Date()): Swift app called with args: \(args)\n"
        let pwdMessage = "\(Date()): PWD: \(FileManager.default.currentDirectoryPath)\n"
        
        let fullLog = logMessage + pwdMessage
        try? fullLog.write(to: URL(fileURLWithPath: "/tmp/openinfinder.log"), atomically: true, encoding: .utf8)
        
        if args.count > 1 {
            let filePath = args[1]
            revealInFinder(filePath: filePath)
        } else {
            let usageMessage = "Usage: \(args[0]) <file_path>\n"
            try? usageMessage.write(to: URL(fileURLWithPath: "/tmp/openinfinder.log"), atomically: true, encoding: .utf8)
        }
    }
    
    static func revealInFinder(filePath: String) {
        let logMessage = "\(Date()): Revealing file: \(filePath)\n"
        try? logMessage.write(to: URL(fileURLWithPath: "/tmp/openinfinder.log"), atomically: true, encoding: .utf8)
        
        // Use NSTask to run 'open -R' command
        let task = Process()
        task.launchPath = "/usr/bin/open"
        task.arguments = ["-R", filePath]
        task.launch()
        task.waitUntilExit()
        
        let completedMessage = "\(Date()): open -R completed with exit code: \(task.terminationStatus)\n"
        try? completedMessage.write(to: URL(fileURLWithPath: "/tmp/openinfinder.log"), atomically: true, encoding: .utf8)
    }
}

OpenInFinder.main()