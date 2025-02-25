# DotEnvTest

A simple Swift terminal application that demonstrates loading environment variables from a `.env` file using the [swift-dotenv](https://github.com/thebarndog/swift-dotenv) package.

## Requirements

- macOS 13.0 or later
- Swift 6.0 or later

## Setup

1. Clone this repository
2. Make sure you have a `.env` file in the root directory of the project with your environment variables. Example:

```
# IMAP Server Credentials
IMAP_HOST=mail.example.com
IMAP_PORT=993
IMAP_USERNAME=user@example.com
IMAP_PASSWORD=secret
```

## Building and Running

To build and run the application:

```bash
# Build the package
swift build

# Run the application
swift run
```

### Debugging with Xcode

If you're debugging the application in Xcode, you need to set a custom working directory to ensure the `.env` file is found correctly:

1. Open the project in Xcode by either:
   - Opening the Package.swift file directly with Xcode
   - Opening the project folder in Xcode (File > Open... and select the folder)
   - Using "Open with Xcode" from Finder context menu on the project folder
2. Xcode will automatically create a project and schemes for the Swift package
3. Select the scheme for your executable target
4. Choose "Edit Scheme..." from the scheme dropdown menu
5. In the "Run" section, go to the "Options" tab
6. Check "Use custom working directory" and set it to the directory containing your `.env` file (typically the project root directory)
7. Click "Close" to save the changes

While our application includes logic to find the project root by looking for Package.swift, setting the working directory explicitly in Xcode ensures the most reliable behavior during debugging.

## How It Works

The application:

1. Determines the current working directory using a multi-step approach:
   - First tries to find the project root by looking for the Package.swift file
   - Then tries to get it from the ProcessInfo "PWD" environment variable
   - Finally falls back to FileManager.default.currentDirectoryPath if all else fails
2. Loads the environment variables from the `.env` file in the determined directory
3. Displays the loaded environment variables (with password masked for security)

### Finding the Project Root Directory

The application includes a helper method to find the project root directory by looking for the Package.swift file:

```swift
func findProjectRootDirectory() -> String? {
    // Start with the current directory
    var currentPath = FileManager.default.currentDirectoryPath
    
    // Check if Package.swift exists in the current directory
    let packageSwiftPath = URL(fileURLWithPath: currentPath).appendingPathComponent("Package.swift").path
    if FileManager.default.fileExists(atPath: packageSwiftPath) {
        return currentPath
    }
    
    // If not found, try to navigate up the directory tree
    // Get the executable path and work backwards
    let executablePath = URL(fileURLWithPath: CommandLine.arguments[0]).deletingLastPathComponent().path
    currentPath = executablePath
    
    // Try up to 5 parent directories
    for _ in 0..<5 {
        let packageSwiftPath = URL(fileURLWithPath: currentPath).appendingPathComponent("Package.swift").path
        if FileManager.default.fileExists(atPath: packageSwiftPath) {
            return currentPath
        }
        
        // Move up one directory
        currentPath = URL(fileURLWithPath: currentPath).deletingLastPathComponent().path
    }
    
    return nil
}
```

This is particularly useful when running the application from different contexts (e.g., Xcode, terminal, etc.) as it ensures the `.env` file is always found correctly.

### Accessing Environment Variables

The swift-dotenv package (version 2.1.0 or higher) provides two ways to access environment variables:

1. **Configure and access directly from Dotenv**:
   ```swift
   // Configure the environment with values from .env file in the current directory
   try Dotenv.configure()
   
   // Or specify a custom path
   try Dotenv.configure(atPath: "/path/to/.env")
   
   // Access values using subscript notation
   if let value = Dotenv["IMAP_HOST"] {
       // value is an Environment.Value object
       print("IMAP_HOST: \(value)")
       // or use stringValue to get the string representation
       print("IMAP_HOST: \(value.stringValue)")
   }
   ```

2. **Using dynamic member lookup with camelCase**:
   ```swift
   // Configure the environment with values from .env file in the current directory
   try Dotenv.configure()
   
   // Note: Use camelCase for the property names
   if let value = Dotenv.imapHost {
       // value is an Environment.Value object
       // Use stringValue to get the string representation
       print("IMAP_HOST: \(value.stringValue)")
   }
   ```

## Notes

- Make sure the `.env` file is in the root directory of your project (where Package.swift is located)
- For security reasons, never commit your actual `.env` file with sensitive information to version control
- The application will exit with an error if the `.env` file cannot be found or loaded 