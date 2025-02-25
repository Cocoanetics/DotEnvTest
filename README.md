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

## How It Works

The application:

1. Determines the current working directory:
   - First tries to get it from the ProcessInfo "PWD" environment variable
   - Falls back to FileManager.default.currentDirectoryPath if PWD is not set
2. Loads the environment variables from the `.env` file in the determined directory
3. Displays the loaded environment variables (with password masked for security)

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

- Make sure the `.env` file is in the same directory where you run the application
- For security reasons, never commit your actual `.env` file with sensitive information to version control
- The application will exit with an error if the `.env` file cannot be found or loaded 