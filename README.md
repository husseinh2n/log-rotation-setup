# Log Rotation Setup 🪵🔄

Welcome! If you've ever worked on a server that ran out of disk space because a log file grew to 500GB, you already know why this project exists. 

This repository is a hands-on, beginner-friendly DevOps playground for mastering **Logrotate**—the standard Linux utility for managing automatic rotation, compression, and cleanup of system logs. Best of all, it includes automated validation scripts and CI/CD tests so you can experiment safely inside Docker.

---

## What this project does
This project provides a complete, containerized environment to configure, test, and validate `logrotate` rules before they ever touch a production server. It includes automated syntax checks and testing tools to ensure your log rotation policies won't fail silently when you need them most. By combining Docker and GitHub Actions, it bridges the gap between local system administration and automated CI/CD pipelines.

---

## What you will learn
* How to write and structure a secure, production-ready `logrotate` configuration file with proper permissions and rotation cycles.
* How to use automated testing (`bats-core`) to verify your log rotation behavior works as expected under different scenarios.
* How to containerize system-level utilities using Docker for consistent cross-platform testing without risking your host machine.
* How to set up Continuous Integration (CI) with GitHub Actions to test your configuration automatically on every push.

---

## Prerequisites

Before diving in, make sure you have the following tools installed on your machine:

* **Docker & Docker Compose** (for running the containerized test environment)
* **Git** (for cloning the repository and managing your code)

### Installation Commands

**macOS** (using Homebrew):