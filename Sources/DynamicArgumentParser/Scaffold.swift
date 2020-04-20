import ArgumentParser
import Foundation

struct Scaffold: ParsableCommand {
    @Argument()
    var template: String
    
    func run() throws {
        print(template)
        print(attributes)
    }
    
    enum CodingKeys: CodingKey {
        case template
        case dynamic(String)
        
        init?(stringValue: String) {
            switch stringValue {
            case "template":
                self = .template
            case stringValue where Scaffold.attributes.contains(stringValue):
                self = .dynamic(stringValue)
            default:
                return nil
            }
        }
        
        var stringValue: String {
            switch self {
            case .template:
                return "template"
            case let .dynamic(name):
                return name
            }
        }

        // Not used
        var intValue: Int? { nil }
        init?(intValue _: Int) { nil }
    }
    
    // #1
    var attributes: [String: String] = [:]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        template = try container.decode(String.self, forKey: .template)
        // #2
        try Scaffold.attributes.forEach { name in
            attributes[name] = try container.decode(String.self, forKey: .dynamic(name))
        }
    }

    // Necessary for conforming `ParsableArguments`
    init() {}
    
    static var attributes: [String] = []
    
    static func preprocess(_ arguments: [String]) throws {
        // Obtaining template name
        let templateName = arguments[1]
        // Based on template name find its manifest
        let manifestPath = FileManager.default.currentDirectoryPath + "/\(templateName)/manifest.json"
        // Obtain data
        let data = try Data(contentsOf: URL(fileURLWithPath: manifestPath))
        // Parse the attributes
        let attributes: [String] = try JSONDecoder().decode([String].self, from: data)
        Scaffold.attributes = attributes
    }
}

extension Scaffold: CustomReflectable {
    var customMirror: Mirror {
        // #1
        let attributesChildren: [Mirror.Child] = Scaffold.attributes
            // #2
            .map {
                (name: $0, option: Option<String>(name: .shortAndLong))
            }
            // #3
            .map {
                Mirror.Child(label: $0.name, value: $0.option)
            }
        // #4
        let children = [
            Mirror.Child(label: "template", value: _template),
        ]
        // #5
        return Mirror(Scaffold(), children: children + attributesChildren)
    }
}

