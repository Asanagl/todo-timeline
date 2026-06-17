# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

If you discover a security vulnerability in Todo Timeline, please report it responsibly.

### How to Report

1. **Do NOT** create a public GitHub issue for security vulnerabilities
2. **Email** the maintainers directly at [security@example.com]
3. **Include** the following information:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

### What to Expect

- **Acknowledgment** within 48 hours
- **Status update** within 1 week
- **Fix timeline** depending on severity

### Severity Levels

| Severity | Description | Response Time |
|----------|-------------|---------------|
| Critical | Remote code execution, data breach | 24-48 hours |
| High | Privilege escalation, data exposure | 1 week |
| Medium | Denial of service, information leak | 2 weeks |
| Low | Minor issues, best practices | 1 month |

## Security Best Practices

### For Users

1. **Keep updated** to the latest version
2. **Download** only from official sources
3. **Verify** checksums when available
4. **Report** suspicious behavior immediately

### For Developers

1. **Follow** secure coding practices
2. **Validate** all user inputs
3. **Sanitize** data before storage
4. **Use** parameterized queries
5. **Encrypt** sensitive data
6. **Audit** dependencies regularly

## Known Security Considerations

### Data Storage

- Task data is stored locally in JSON format
- No encryption is applied to local storage
- Users should protect their device physically

### Network Communication

- This version does not include network features
- No data is transmitted over the network
- No telemetry or analytics collection

### Third-Party Dependencies

- Qt 6.x framework
- CMake build system
- No other external dependencies

## Security Updates

Security updates will be released as:

- **Patch versions** (1.0.x) for critical fixes
- **Minor versions** (1.x.0) for security improvements
- **Major versions** (x.0.0) for breaking changes

## Disclosure Policy

1. **Private disclosure** to maintainers first
2. **Coordinated disclosure** with affected parties
3. **Public disclosure** after fix is available
4. **Credit** to reporters (unless anonymous)

## Contact

For security-related inquiries:

- **Email**: [security@example.com]
- **PGP Key**: [Available on request]
- **Response time**: 48 hours maximum

---

Thank you for helping keep Todo Timeline secure! 🔒
