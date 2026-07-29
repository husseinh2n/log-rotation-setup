#!/usr/bin/env bats

# ==============================================================================
# Test Suite: log-rotation-setup
# Framework: BATS (Bash Automated Testing System)
# Description: Tests configuration validation, logrotate execution, and script logic.
# ==============================================================================

# Setup run before each test
setup() {
    # Create temporary directories for testing to avoid touching system logs
    TEST_DIR="$(mktemp -d)"
    export TEST_DIR
    
    # Create mock directory structures required by logrotate and scripts
    mkdir -p "${TEST_DIR}/etc/logrotate.d"
    mkdir -p "${TEST_DIR}/var/log/app"
    mkdir -p "${TEST_DIR}/scripts"

    # Copy actual scripts and configs into our test environment for validation
    cp config/logrotate.conf "${TEST_DIR}/etc/logrotate.conf"
    cp scripts/validate.sh "${TEST_DIR}/scripts/validate.sh"
    cp scripts/entrypoint.sh "${TEST_DIR}/scripts/entrypoint.sh"
    
    # Make scripts executable
    chmod +x "${TEST_DIR}/scripts/*.sh"
}

# Teardown run after each test
teardown() {
    # Clean up temporary test directory
    rm -rf "${TEST_DIR}"
}

# ==============================================================================
# Configuration Validation Tests (validate.sh)
# ==============================================================================

@test "validate.sh succeeds with a valid logrotate configuration" {
    # Verify that the default configuration passes logrotate's syntax check
    run "${TEST_DIR}/scripts/validate.sh" "${TEST_DIR}/etc/logrotate.conf"
    
    # Assert that the command succeeded (exit code 0)
    [ "$status" -eq 0 ]
}

@test "validate.sh fails with a malformed logrotate configuration" {
    # Introduce a syntax error into the config (unclosed bracket/invalid directive)
    echo "invalid_directive_syntax_test" >> "${TEST_DIR}/etc/logrotate.conf"

    # Run validation against the broken configuration
    run "${TEST_DIR}/scripts/validate.sh" "${TEST_DIR}/etc/logrotate.conf"
    
    # Assert that the command failed (non-zero exit code)
    [ "$status" -ne 0 ]
}

# ==============================================================================
# Log Rotation Execution Tests
# ==============================================================================

@test "logrotate successfully rotates target log files" {
    # Create a dummy log file inside our test directory
    echo "Sample log entry 1" > "${TEST_DIR}/var/log/app/app.log"

    # Create a temporary test-specific logrotate configuration pointing to our test log
    cat <<EOF > "${TEST_DIR}/etc/test_app.conf"
    ${TEST_DIR}/var/log/app/*.log {
        size 1k
        rotate 3
        missingok
        notifempty
        copytruncate
    }
EOF

    # Force logrotate to run using our test config and state file
    run logrotate -s "${TEST_DIR}/var/log/status" -f "${TEST_DIR}/etc/test_app.conf"

    # Assert that logrotate executed successfully
    [ "$status" -eq 0 ]
}

# ==============================================================================
# Entrypoint Script Tests
# ==============================================================================

@test "entrypoint script exists and is executable" {
    # Verify the entrypoint script has execution permissions
    [ -x "${TEST_DIR}/scripts/entrypoint.sh" ]
}