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
	// First try to get the current working directory from ProcessInfo "PWD" environment variable
	let currentDirectory: String
	if let pwd = ProcessInfo.processInfo.environment["PWD"] {
		currentDirectory = pwd
		print("Current directory from ProcessInfo PWD: \(currentDirectory)")
	} else {
		// Fallback to FileManager.default.currentDirectoryPath if PWD is not set
		currentDirectory = FileManager.default.currentDirectoryPath
		print("Current directory from FileManager: \(currentDirectory)")
	}
	
	// Construct the path to the .env file
	let dotEnvURL = URL(fileURLWithPath: currentDirectory).appendingPathComponent(".env")
	print("Looking for .env file at: \(dotEnvURL.path)")
	
	// Load the .env file from the determined path
	try Dotenv.configure(atPath: dotEnvURL.path)
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
			let displayValue = varName == "IMAP_PASSWORD" ? "********" : value.stringValue
			print("\(varName): \(displayValue)")
		} else {
			print("\(varName): Not found")
		}
	}
	
	// Using dynamic member lookup with camelCase
	print("\nLoaded Environment Variables (using dynamic member lookup):")
	print("------------------------------------------------------")
	
	// Note: Dynamic member lookup uses camelCase property names
	print("IMAP_HOST: \(Dotenv.imapHost?.stringValue ?? "Not found")")
	print("IMAP_PORT: \(Dotenv.imapPort?.stringValue ?? "Not found")")
	print("IMAP_USERNAME: \(Dotenv.imapUsername?.stringValue ?? "Not found")")
	print("IMAP_PASSWORD: \(Dotenv.imapPassword != nil ? "********" : "Not found")")
	
} catch {
	print("❌ Error loading .env file: \(error)")
	exit(1)
}

print("\nDotEnvTest completed successfully!")
