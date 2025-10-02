# Contributing Guide

Thank you for your interest in contributing to Disk Usage Alert! This guide will help you get started.

## Ways to Contribute

### 1. Report Bugs

If you find a bug:

1. Check [existing issues](https://github.com/BlediN/disk-usage-alert/issues) to avoid duplicates
2. Create a new issue with:
   - Clear, descriptive title
   - Steps to reproduce
   - Expected vs actual behavior
   - System information (Ubuntu version, script version)
   - Relevant logs or error messages

### 2. Suggest Features

Have an idea for improvement?

1. Check existing issues and discussions
2. Create a new issue with the `enhancement` label
3. Describe:
   - The problem you're trying to solve
   - Your proposed solution
   - Alternative solutions you've considered
   - How it would benefit other users

### 3. Improve Documentation

Documentation improvements are always welcome:

- Fix typos or clarify instructions
- Add examples
- Translate documentation
- Create tutorials or guides
- Update this wiki

### 4. Submit Code

Ready to write code? Great!

## Development Setup

### Prerequisites

- Ubuntu 18.04 LTS or later (or similar Linux distribution)
- Git
- Bash 4.0 or later
- Text editor or IDE

### Getting Started

1. **Fork the repository**:
   - Visit [https://github.com/BlediN/disk-usage-alert](https://github.com/BlediN/disk-usage-alert)
   - Click "Fork" button

2. **Clone your fork**:
   ```bash
   git clone https://github.com/YOUR_USERNAME/disk-usage-alert.git
   cd disk-usage-alert
   ```

3. **Add upstream remote**:
   ```bash
   git remote add upstream https://github.com/BlediN/disk-usage-alert.git
   ```

4. **Create a branch**:
   ```bash
   git checkout -b feature/your-feature-name
   # or
   git checkout -b fix/bug-description
   ```

## Coding Guidelines

### Bash Style

Follow these conventions for consistent code:

```bash
#!/bin/bash

# Use meaningful variable names
disk_usage=85
warning_threshold=80

# Use functions for reusable code
function check_disk_usage() {
    local mount_point="$1"
    # function code
}

# Add comments for complex logic
# Calculate percentage: (used / total) * 100
percentage=$((used * 100 / total))

# Use quotes around variables
echo "Usage: ${percentage}%"

# Check command success
if df -h > /dev/null 2>&1; then
    echo "Success"
fi
```

### Code Standards

1. **Indentation**: 4 spaces (no tabs)
2. **Line length**: Maximum 100 characters
3. **Functions**: Use `function name()` format
4. **Variables**: 
   - Local variables: lowercase with underscores
   - Global/config variables: UPPERCASE
5. **Error handling**: Always check command exit codes
6. **Comments**: Explain "why", not "what"

### ShellCheck

Run ShellCheck before submitting:

```bash
# Install shellcheck
sudo apt-get install shellcheck

# Check your script
shellcheck disk-usage-alert.sh
```

Fix any warnings or errors before submitting.

## Testing

### Manual Testing

Test your changes thoroughly:

```bash
# Test basic functionality
./disk-usage-alert.sh

# Test with debug output
./disk-usage-alert.sh --debug

# Test configuration options
./disk-usage-alert.sh --config test-config.conf

# Test edge cases
# - Very high disk usage
# - Empty filesystems
# - Network filesystems
# - Permission issues
```

### Test Checklist

Before submitting:

- [ ] Script runs without errors
- [ ] All command-line options work
- [ ] Configuration file is parsed correctly
- [ ] Alerts are sent properly
- [ ] No ShellCheck warnings
- [ ] Code follows style guidelines
- [ ] Changes don't break existing functionality
- [ ] Tested on Ubuntu 18.04 and/or 20.04

### Creating Test Cases

If adding new features, document test cases:

```bash
# Test Case: Check specific path
# Setup: Create test directory with known usage
# Execute: ./disk-usage-alert.sh --check-path /test
# Expected: Reports correct usage percentage
# Cleanup: Remove test directory
```

## Pull Request Process

### Before Submitting

1. **Update from upstream**:
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

2. **Test your changes**:
   ```bash
   shellcheck disk-usage-alert.sh
   ./disk-usage-alert.sh --test
   ```

3. **Commit your changes**:
   ```bash
   git add .
   git commit -m "Add feature: description"
   ```

   Commit message format:
   ```
   Type: Short description (50 chars max)
   
   Longer explanation if needed (wrap at 72 chars).
   
   Fixes #123
   ```
   
   Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

4. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```

### Creating the Pull Request

1. Go to your fork on GitHub
2. Click "Compare & pull request"
3. Fill out the PR template:
   - **Title**: Clear, concise description
   - **Description**: 
     - What changes were made
     - Why they were made
     - How to test them
   - **Related issues**: Link any related issues

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Performance improvement

## Testing
How did you test this?

## Checklist
- [ ] Code follows project style guidelines
- [ ] Tested on Ubuntu
- [ ] ShellCheck passes
- [ ] Documentation updated
- [ ] No breaking changes
```

### Review Process

1. **Automated checks**: Wait for CI/CD (if configured)
2. **Code review**: Maintainers will review your code
3. **Address feedback**: Make requested changes
4. **Approval**: Once approved, maintainer will merge

### After Your PR is Merged

1. **Update your fork**:
   ```bash
   git checkout main
   git fetch upstream
   git merge upstream/main
   git push origin main
   ```

2. **Delete your branch**:
   ```bash
   git branch -d feature/your-feature-name
   git push origin --delete feature/your-feature-name
   ```

## Areas Needing Help

Current priorities (as of last update):

1. **Alert integrations**:
   - PagerDuty integration
   - Microsoft Teams webhook
   - Custom webhook support

2. **Features**:
   - Historical tracking
   - Trend analysis
   - Web dashboard
   - Docker support

3. **Documentation**:
   - Video tutorials
   - More examples
   - Translations

4. **Testing**:
   - Automated test suite
   - CI/CD pipeline
   - Integration tests

## Community Guidelines

### Code of Conduct

- Be respectful and inclusive
- Welcome newcomers
- Focus on constructive feedback
- Assume good intentions
- Keep discussions on-topic

### Communication

- **GitHub Issues**: Bug reports, feature requests
- **Pull Requests**: Code contributions, documentation
- **Discussions**: General questions, ideas

### Response Time

- We aim to respond to issues within 48 hours
- PRs typically reviewed within 1 week
- Be patient, this is maintained by volunteers

## Recognition

Contributors will be:
- Listed in the project README
- Mentioned in release notes
- Credited in commit history

## License

By contributing, you agree that your contributions will be licensed under the same license as the project.

## Questions?

If you have questions about contributing:

1. Check this guide first
2. Look through existing issues
3. Create a new issue with the `question` label
4. Be specific about what you need help with

## Resources

### Bash Resources

- [Bash Guide](https://mywiki.wooledge.org/BashGuide)
- [ShellCheck](https://www.shellcheck.net/)
- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)

### Git Resources

- [Git Documentation](https://git-scm.com/doc)
- [GitHub Flow](https://guides.github.com/introduction/flow/)
- [How to Write a Git Commit Message](https://chris.beams.io/posts/git-commit/)

### Testing

- [BATS (Bash Automated Testing System)](https://github.com/bats-core/bats-core)
- [ShellSpec](https://shellspec.info/)

## Thank You!

Your contributions make this project better for everyone. Whether you're fixing a typo, reporting a bug, or implementing a major feature, every contribution is valuable.

Happy coding! 🚀
