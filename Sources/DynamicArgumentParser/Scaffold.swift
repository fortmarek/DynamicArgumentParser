import ArgumentParser
import Foundation

struct Scaffold: ParsableCommand {
    @Argument()
    var templateName: String
    
    func run() throws {
        
    }
    
    static func preprocess(_ arguments: [String]) throws {
        let templateName = arguments[1]
        let manifestPath = FileManager.default.currentDirectoryPath + "/\(templateName)/manifest.json"
        let data = try Data(contentsOf: URL(fileURLWithPath: manifestPath))
        let attributes: [String] = try JSONDecoder().decode([String].self, from: data)
        print(attributes)
    }
}
