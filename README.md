# Thronglets

[![Gem Version](https://img.shields.io/gem/v/thronglets)](https://rubygems.org/gems/thronglets)
[![Gem Downloads](https://img.shields.io/gem/dt/thronglets)](https://www.ruby-toolbox.com/projects/thronglets)
[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/kkdoo/thronglets/ci.yml)](https://github.com/kkdoo/thronglets/actions/workflows/ci.yml)
[![Maintainability](https://qlty.sh/badges/18c6dc12-d7e9-454b-99db-c8214708efb3/maintainability.svg)](https://qlty.sh/gh/kkdoo/projects/thronglets)

---

- [Why Use Thronglets?](#why-use-thronglets)
- [Use Cases](#use-cases)
- [Overview](#overview)
- [Key Features](#key-features)
- [Installation](#installation)
- [Directory Structure](#directory-structure)
- [Core Components](#core-components)
  - [Workflows](#1-workflows)
  - [Activities](#2-activities)
  - [Command Line Interface](#3-command-line-interface)
- [Input/Output Validation](#inputoutput-validation)
- [Development Mode](#development-mode)
- [Error Handling](#error-handling)
- [Best Practices](#best-practices)
- [Support](#support)
- [License](#license)
- [Code of conduct](#code-of-conduct)
- [Contribution guide](#contribution-guide)

## Why Use Thronglets?

Decoupling a monolith is complex and risky without the right tools. Thronglets gives you insight into your codebase, helps you plan a phased decomposition strategy, and reduces the cognitive and operational overhead of large-scale refactoring efforts.

## Use Cases

- Legacy systems modernization
- Microservice migration strategies
- Technical debt management
- Domain-driven design alignment

## Overview

Thronglets is an open-source Ruby toolkit designed to help engineering teams modernize and decompose monolithic applications into modular, scalable services. Built on top of [Temporal](https://temporal.io), it provides a structured approach to breaking down legacy Ruby applications, with a particular focus on Ruby on Rails monoliths.

## Key Features

1. **Workflow Management**
   - Built-in workflow orchestration using Temporal
   - Support for long-running processes
   - Automatic workflow registration and management

2. **Activity Management**
   - Structured activity definitions
   - Input/Output validation
   - Automatic activity registration

3. **Code Organization**
   - Conventional directory structure
   - Automatic code loading with Zeitwerk
   - Hot-reloading capabilities

## Installation

```ruby
gem 'thronglets'
```

Or install via command line:
```bash
gem install thronglets
```

Requirements:
- Ruby >= 3.2
- Temporal server running

## Directory Structure

Thronglets expects the following directory structure:
```
app/
├── activities/     # Activity definitions
├── actors/        # Actor classes
├── workflows/     # Workflow definitions
├── models/        # Domain models
└── models/concerns/  # Shared concerns
```

## Core Components

### 1. Workflows

Workflows are the core orchestration units in Thronglets. They inherit from `Thronglets::Workflow`:

```ruby
class MyWorkflow < Thronglets::Workflow
  input do
    # Define input schema using dry-schema
  end

  output do
    # Define output schema using dry-schema
  end

  def call
    # Implement workflow logic
  end
end
```

### 2. Activities

Activities are the individual units of work, inheriting from `Thronglets::Activity`:

```ruby
class MyActivity < Thronglets::Activity
  input do
    # Define input schema
  end

  output do
    # Define output schema
  end

  def call
    # Implement activity logic
  end
end
```

### 3. Command Line Interface

Thronglets provides a CLI with several commands:

```bash
# Display version
thronglets -v

# Start worker
thronglets -w

# Start in listen mode (auto-reload)
thronglets -l

# Start console
thronglets -c
```

## Input/Output Validation

Thronglets uses `dry-schema` for input/output validation:

```ruby
class MyWorkflow < Thronglets::Workflow
  input do
    required(:name).filled(:string)
    required(:age).filled(:integer)
  end

  output do
    required(:success).filled(:bool)
    required(:data).hash
  end
end
```

## Development Mode

For development:
1. Start in listen mode: `thronglets -l`
2. Make code changes
3. Automatic reload happens on file changes
4. Use console mode for exploration: `thronglets -c`

## Error Handling

Thronglets provides structured error handling:
- `InputValidationError` for invalid inputs
- `OutputValidationError` for invalid outputs
- Automatic error formatting to JSON
- Standardized error responses

## Best Practices

1. **Code Organization**
   - Keep activities atomic and focused
   - Use workflows for orchestration
   - Leverage input/output schemas

2. **Development Workflow**
   - Use listen mode during development
   - Implement proper input/output validation
   - Follow the directory structure conventions

3. **Error Handling**
   - Always validate inputs and outputs
   - Use proper error classes
   - Implement proper error recovery in workflows

## Support and Contributing

- GitHub Issues: [https://github.com/kkdoo/thronglets/issues](https://github.com/kkdoo/thronglets/issues)
- License: MIT
- Author: Artem Mashchenko

## Support

If you want to report a bug, or have ideas, feedback or questions about the gem, [let me know via GitHub issues](https://github.com/kkdoo/thronglets/issues/new) and I will do my best to provide a helpful answer. Happy hacking!

## License

The gem is available as open source under the terms of the [MIT License](LICENSE.txt).

## Code of conduct

Everyone interacting in this project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](CODE_OF_CONDUCT.md).

## Contribution guide

Pull requests are welcome!
