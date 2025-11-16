# Contributing to Kubernetes Grafana Dashboards

Thank you for your interest in contributing! This document provides guidelines for contributing to this project.

## Code of Conduct

Be respectful and constructive in your interactions with other contributors.

## How to Contribute

### Reporting Issues

- Use the GitHub issue tracker
- Check if the issue already exists
- Include:
  - Dashboard name and version
  - Kubernetes version
  - Prometheus version
  - Expected vs actual behavior
  - Screenshots if applicable

### Submitting Changes

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/my-new-dashboard
   ```

3. **Make your changes**
   - Follow the dashboard structure guidelines
   - Validate JSON syntax
   - Test with actual data

4. **Commit your changes**
   - Use conventional commits format:
     - `feat:` for new features
     - `fix:` for bug fixes
     - `docs:` for documentation
     - `refactor:` for refactoring
     - `test:` for tests
     - `chore:` for maintenance
   
   Example:
   ```bash
   git commit -m "feat: add ingress controller dashboard"
   ```

5. **Push to your fork**
   ```bash
   git push origin feature/my-new-dashboard
   ```

6. **Create a Pull Request**

## Dashboard Guidelines

### Structure

- Use modern time series panels (not deprecated graph panels)
- Include template variables for datasource and cluster
- Use `$__rate_interval` for rate() functions
- Add meaningful panel titles and descriptions
- Use appropriate units for metrics

### Template Variables

All dashboards should include:
```json
{
  "templating": {
    "list": [
      {
        "name": "datasource",
        "type": "datasource",
        "query": "prometheus"
      },
      {
        "name": "cluster",
        "type": "query",
        "query": "label_values(up, cluster)"
      }
    ]
  }
}
```

### Query Best Practices

- Use recording rules when available
- Avoid overly complex queries
- Add comments for complex PromQL
- Test queries with production-like data volumes
- Consider query performance impact

### Panel Configuration

- Use gradient mode for time series
- Set appropriate thresholds
- Configure legend with useful calculations (mean, max, last)
- Use table format for detailed views
- Add drill-down links between related dashboards

## Testing

Before submitting:

1. **Validate JSON**
   ```bash
   jq empty dashboards/**/*.json
   ```

2. **Test Kustomize build**
   ```bash
   kustomize build .
   ```

3. **Test in Grafana**
   - Import dashboard
   - Verify all panels load
   - Test with different time ranges
   - Verify template variables work

## Documentation

Update documentation when:
- Adding new dashboards
- Changing metrics
- Adding new features
- Updating compatibility requirements

Include:
- Dashboard description
- Required metrics/exporters
- Configuration examples
- Screenshots

## Versioning

This project uses [Semantic Versioning](https://semver.org/):
- **MAJOR**: Incompatible changes
- **MINOR**: New features (backwards compatible)
- **PATCH**: Bug fixes

## Release Process

Releases are automated via semantic-release:
1. Merge PR to main branch
2. CI validates changes
3. Semantic-release analyzes commits
4. Version is bumped automatically
5. Changelog is updated
6. GitHub release is created

## Questions?

Open an issue for questions or discussion.
