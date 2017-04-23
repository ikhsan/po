import Foundation

func portFromEnv() -> Int? {
    guard let envPort = ProcessInfo.processInfo.environment["PORT"] else { return nil }
    return Int(envPort)
}
