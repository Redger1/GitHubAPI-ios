# GitHubAPI-ios

A modular iOS project built around the GitHub REST API with a separated architecture for UI and networking logic.

The repository is split into two parts:

- main branch — iOS application and UI layer
- package branch — reusable Swift Package containing networking, models, repositories, and view models

## Architecture

The project follows a modular approach where the core API layer is extracted into a standalone Swift Package.

The package contains:

- API client implementation
- endpoint management
- repository layer
- models
- dependency injection
- view models

The UI application consumes the package independently, keeping presentation logic separated from networking and business logic.

## Features

- GitHub repositories search
- Combine-based networking
- Diffable Data Source
- Modular architecture
- Reusable Swift Package
- UIKit-based interface
- Dependency injection via Service Locator

## Tech Stack

- Swift
- UIKit
- Combine
- URLSession
- Swift Package Manager
- GitHub REST API

## Project Structure
main branch
└── GitHub UI application

package branch
└── Reusable GitHub API package## Current Status

The project is functional and demonstrates the complete interaction flow between the UI layer and a reusable API package.

At the same time, it is still evolving and some parts are intentionally left open for future improvements, including:

- advanced error handling
- pagination
- caching
- request optimization
- test coverage
- richer UI states
