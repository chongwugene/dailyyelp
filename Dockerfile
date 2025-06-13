# Use official Ubuntu 24.04 image as base
FROM ubuntu:24.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies: git, python3, pip, venv, build tools, and libraries needed for dbt
RUN apt-get update && apt-get install -y \
    git \
    python3 \
    python3-pip \
    python3-venv \
    build-essential \
    libffi-dev \
    libssl-dev \
    python3-dev \
    curl \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user to avoid running everything as root inside container (safer)
RUN useradd -ms /bin/bash devuser

# Switch to the new user
USER devuser

# Set working directory inside container to user's home folder
WORKDIR /home/devuser

# Create a Python virtual environment named "dbt-venv"
# Then activate it, upgrade pip inside it, and install dbt packages inside the venv
RUN python3 -m venv dbt-venv && \
    . dbt-venv/bin/activate && \
    pip install --upgrade pip && \
    pip install dbt-core dbt-postgres

# Add the virtual environment's bin directory to PATH so commands like 'dbt' work directly
ENV PATH="/home/devuser/dbt-venv/bin:$PATH"

# When the container starts, open a bash shell (you can run commands inside the container)
CMD ["bash"]
