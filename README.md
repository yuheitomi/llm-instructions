# LLM Instructions for Claude Code

A comprehensive collection of framework documentation and development setup guides optimized for use with [Claude Code](https://claude.ai/code).

## Overview

This repository contains carefully crafted instruction sets and documentation for modern frontend frameworks and development tools. These documents are designed to provide Claude Code with detailed context and best practices for building applications with various technologies.

## Structure

### 📚 [Framework Documentation](frameworks/)
Comprehensive guides for popular frontend frameworks:

- **[Next.js v15](frameworks/nextjs-v15.md)** - TypeScript, RSC, and performance optimization
- **[React Router v7](frameworks/react-router-v7.md)** - Framework mode best practices and type safety
- **[React Router v7 Advanced](frameworks/react-router-v7-advanced.md)** - Authentication, forms, and advanced patterns
- **[daisyUI v5](frameworks/daisyui-v5.md)** - Complete component library and Tailwind CSS integration
- **[Svelte 5](frameworks/svelte-v5.md)** - Runes system and modern Svelte development

### 🔧 [Setup Guides](setup/)
Configuration and development environment setup:

- **[Prettier Setup](setup/setup-prettier.md)** - Code formatting and editor integration
- **[Svelte 5 Setup](setup/setup-svelte5.md)** - Complete development environment configuration

### ⚡ Claude Code Commands
Ready-to-use slash commands for Claude Code:

- **/download-llm** - Download framework documentation to your project
- **/setup-framework** - Execute setup guides for development environments
- **/commit** - Smart git commit with conventional commit format
- **/create-pr** - Create pull requests with proper formatting

## Usage with Claude Code

### Quick Start

1. **Download documentation to your project:**
   ```bash
   /download-llm react
   /download-llm nextjs
   /download-llm svelte
   ```

2. **Setup your development environment:**
   ```bash
   /setup-framework prettier
   /setup-framework svelte5
   ```

3. **Commit your changes:**
   ```bash
   /commit
   ```

### Integration Examples

These documents work best when:
- Referenced at the start of development sessions
- Used as context for framework-specific questions
- Applied during code reviews and refactoring
- Consulted for best practices and patterns

## Document Features

- ✅ **Framework-specific best practices** and anti-patterns
- ✅ **TypeScript-first** approach with proper type safety
- ✅ **Performance optimization** guidelines
- ✅ **Security considerations** and secure coding practices
- ✅ **Accessibility standards** and inclusive design
- ✅ **Modern tooling** integration and configuration
- ✅ **Real-world examples** and common use cases

## Contributing

When contributing to these documents:

1. Follow the established documentation patterns
2. Include practical examples and code snippets
3. Focus on real-world scenarios and common pitfalls
4. Maintain framework version specificity
5. Test instructions with actual projects

## Repository Conventions

- Documents use conventional commit format
- All framework docs include version numbers
- Setup guides are executable and tested
- Code examples follow each framework's best practices

## License

This project is open source and available under the [MIT License](LICENSE).

---

**Built for Claude Code** - Enhancing AI-assisted development with comprehensive, contextual documentation.