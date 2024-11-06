# Use Red Hat UBI 9 minimal as the base image
FROM registry.access.redhat.com/ubi9/ubi-minimal:9.4

# Set environment variables
ENV PATH=/opt/conda/bin:$PATH \
    CONDA_PKGS_DIRS=/app/conda_pkgs \
    CONDA_ENVS_DIRS=/app/conda_envs \
    CONDA_CACHE_DIR=/app/conda_cache \
    KAGGLE_CONFIG_DIR=/app/kaggle

# Install necessary packages, download Miniconda, and clean up in one layer
RUN microdnf install -y wget bzip2 && \
    wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /miniconda.sh && \
    bash /miniconda.sh -b -p /opt/conda && \
    rm /miniconda.sh && \
    microdnf clean all && \
    /opt/conda/bin/conda clean -afy

# Create cache directories in a single layer to reduce image size
RUN mkdir -p /app/conda_pkgs /app/conda_envs /app/conda_cache && \
    chmod -R 777 /app

# Set the working directory
WORKDIR /app

# Copy the application code
COPY . /app

# Set default environment and path
ENV CONDA_DEFAULT_ENV=triton_example \
    PATH=/opt/conda/envs/$CONDA_DEFAULT_ENV/bin:$PATH

# Expose a port if necessary
EXPOSE 8080

# Keep the container running (or replace with desired command)
CMD ["tail", "-f", "/dev/null"]