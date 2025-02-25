// The Swift Programming Language
// https://docs.swift.org/swift-book

// DotEnvTest - A demonstration of loading environment variables from .env files
// Using the swift-dotenv package: https://github.com/thebarndog/swift-dotenv

import Foundation
import SwiftDotenv

print("DotEnvTest - Demonstrating .env file loading")
print("--------------------------------------------")

// Try to load the .env file from the current directory
do {
	try Dotenv.configure()
	print("✅ Successfully loaded environment variables from .env file")
	
	// Display the loaded environment variables
	print("\nLoaded Environment Variables (using subscript):")
	print("--------------------------------------------")
	
	// List of environment variables we expect to find in the .env file
	let expectedVars = ["IMAP_HOST", "IMAP_PORT", "IMAP_USERNAME", "IMAP_PASSWORD"]
	
	for varName in expectedVars {
		// Access environment variables directly from Dotenv
		if let value = Dotenv[varName] {
			// Mask the password for security
			if varName == "IMAP_PASSWORD" {
				print("\(varName): ********")
			} else if case let .string(stringValue) = value {
				print("\(varName): \(stringValue)")
			} else if case let .integer(intValue) = value {
				print("\(varName): \(intValue)")
			} else {
				print("\(varName): \(value.stringValue)")
			}
		} else {
			print("\(varName): Not found")
		}
	}
	
	// Using dynamic member lookup with camelCase
	print("\nLoaded Environment Variables (using dynamic member lookup):")
	print("------------------------------------------------------")
	
	// Note: Dynamic member lookup uses camelCase property names
	if case let .string(host) = Dotenv.imapHost {
		print("IMAP_HOST: \(host)")
	} else {
		print("IMAP_HOST: Not found")
	}
	
	if case let .integer(port) = Dotenv.imapPort {
		print("IMAP_PORT: \(port)")
	} else {
		print("IMAP_PORT: Not found")
	}
	
	if case let .string(username) = Dotenv.imapUsername {
		print("IMAP_USERNAME: \(username)")
	} else {
		print("IMAP_USERNAME: Not found")
	}
	
	if Dotenv.imapPassword != nil {
		print("IMAP_PASSWORD: ********")
	} else {
		print("IMAP_PASSWORD: Not found")
	}
	
} catch let error as Dotenv.LoadingFailure {
	switch error {
		case .environmentFileIsMissing:
			print("❌ Error: .env file not found!")
			print("\nPossible solutions:")
			print("1. Make sure the .env file exists in the project root directory")
			print("2. If running from Xcode, did you set a custom working directory in the scheme?")
			print("   - Edit Scheme > Run > Options > Check 'Use custom working directory'")
			print("   - Set it to the directory containing your .env file (project root)")
		case .unableToReadEnvironmentFile:
			print("❌ Error: Unable to read the .env file!")
			print("\nPossible solutions:")
			print("1. Check the file permissions")
			print("2. Make sure the file is not corrupted")
			print("3. Verify the file is a valid text file")
	}
	exit(1)
} catch let error as Dotenv.DecodingFailure {
	switch error {
		case .malformedKeyValuePair:
			print("❌ Error: Malformed key-value pair in .env file!")
			print("\nPossible solutions:")
			print("1. Check the format of your .env file")
			print("2. Each line should be in the format KEY=VALUE")
			print("3. Make sure there are no spaces around the equals sign")
		case .emptyKeyValuePair(let pair):
			print("❌ Error: Empty key or value in .env file: \(pair)")
			print("\nPossible solutions:")
			print("1. Make sure neither the key nor the value is empty")
			print("2. If you need an empty value, use KEY=\"\" format")
	}
	exit(1)
} catch {
	print("❌ Unexpected error loading .env file: \(error)")
	exit(1)
}

print("\nDotEnvTest completed successfully!")
