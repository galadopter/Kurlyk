import Foundation
import PackagePlugin

@main
struct SwiftGenPlugin: BuildToolPlugin {
    
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        return try commands(implementationTarget: target, in: context)
    }
}

// MARK: - Plugin setup
private extension SwiftGenPlugin {
    
    func commands(implementationTarget target: Target, in context: PluginContext) throws -> [Command] {
        let isImplementationModule = target.name == context.package.displayName
        guard isImplementationModule else { return [] }

        let executable = try context.tool(named: "swiftgen").path
        let inputFilesPath = target.directory.appending("Resources")
        let configPath = inputFilesPath.appending("swiftgen.yml")
        let outputFilesPath = context.pluginWorkDirectory.appending("Generated")
        
        try FileManager.default.createDirectory(
            atPath: outputFilesPath.string,
            withIntermediateDirectories: true
        )
        
        return [
            .prebuildCommand(
                displayName: "Running SwiftGen",
                executable: executable,
                arguments: [
                    "config", "run", "--verbose",
                    "--config", configPath
                ],
                environment: [
                    "INPUT_DIR": inputFilesPath,
                    "OUTPUT_DIR": outputFilesPath
                ],
                outputFilesDirectory: outputFilesPath
            )
        ]
    }
}
