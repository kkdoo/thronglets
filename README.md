# Thronglets

[![Gem Version](https://img.shields.io/gem/v/thronglets)](https://rubygems.org/gems/thronglets)
[![Gem Downloads](https://img.shields.io/gem/dt/thronglets)](https://www.ruby-toolbox.com/projects/thronglets)
[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/kkdoo/thronglets/ci.yml)](https://github.com/kkdoo/thronglets/actions/workflows/ci.yml)
[![Maintainability](https://qlty.sh/badges/18c6dc12-d7e9-454b-99db-c8214708efb3/maintainability.svg)](https://qlty.sh/gh/kkdoo/projects/thronglets)

**Thronglets** is an open source toolkit designed to assist engineering teams in systematically breaking down and decoupling monolithic applications into modular, scalable services. Whether you're targeting microservices, modular monoliths, or service-oriented architectures, Thronglets provides a set of practical tools and patterns to analyze dependencies, extract business domains, and incrementally refactor legacy codebases with minimal risk.

Built on top of [Temporal](https://temporal.io) to orchestrate long-running workflows and service boundaries, Thronglets seamlessly integrates with existing **Ruby on Rails** applications, making it ideal for teams modernizing legacy Rails monoliths.

---

- [Why Use Thronglets?](#why-use-thronglets)
- [Use Cases](#use-cases)
- [Quick start](#quick-start)
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

## Quick start

```
gem install thronglets
```

```ruby
require "thronglets"
```

## Support

If you want to report a bug, or have ideas, feedback or questions about the gem, [let me know via GitHub issues](https://github.com/kkdoo/thronglets/issues/new) and I will do my best to provide a helpful answer. Happy hacking!

## License

The gem is available as open source under the terms of the [MIT License](LICENSE.txt).

## Code of conduct

Everyone interacting in this project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](CODE_OF_CONDUCT.md).

## Contribution guide

Pull requests are welcome!
