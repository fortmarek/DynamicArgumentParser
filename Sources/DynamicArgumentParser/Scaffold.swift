import ArgumentParser
import Foundation

struct Scaffold: ParsableCommand {
    @Argument()
    var templateName: String
    
    func run() throws {
        
    }
    
    static func preprocess(_ arguments: [String]) throws {
        // Obtaining template name
        let templateName = arguments[1]
        // Based on template name find its manifest
        let manifestPath = FileManager.default.currentDirectoryPath + "/\(templateName)/manifest.json"
        // Obtain data
        let data = try Data(contentsOf: URL(fileURLWithPath: manifestPath))
        // Parse the attributes
        let attributes: [String] = try JSONDecoder().decode([String].self, from: data)
        print(attributes)
    }
}
