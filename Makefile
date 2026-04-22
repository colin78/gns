# Use bash
SHELL := /bin/bash

# Config
PYTHON := python3.11
VENV := .venv
VENV_BIN := $(VENV)/bin

SRC_DIR := src
TEST_DIR := tests
FORMAT_LINT_TARGETS := scripts # notebooks dual_recordings filter_settings whaleteq_data_reader mayo_cdap config_generator

# Default target
.DEFAULT_GOAL := help

# -------------------
# Environment setup
# -------------------

venv: ## Create virtual environment
	$(PYTHON) -m venv $(VENV)

install: venv ## Install dependencies into venv
	$(VENV_BIN)/pip install --upgrade pip
	$(VENV_BIN)/pip install -r requirements.txt

# -------------------
# Core targets
# -------------------

test: ## Run tests
	$(VENV_BIN)/pytest $(TEST_DIR)

lint: ## Run lint checks
	$(VENV_BIN)/pylint --disable=R,C $(FORMAT_LINT_TARGETS)

format: ## Run black auto-formatting
	$(VENV_BIN)/black $(FORMAT_LINT_TARGETS)

# -------------------
# Cleanup
# -------------------

clean: ## Remove build artifacts
	rm -rf build dist *.egg-info .pytest_cache __pycache__

clean-venv: ## Remove virtual environment
	rm -rf $(VENV)

# -------------------
# Utility
# -------------------

help: ## Show available commands
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?##' Makefile | \
		awk 'BEGIN {FS = ":.*?##"}; {printf "  %-15s %s\n", $$1, $$2}'

.PHONY: venv install test lint format clean clean-venv help
