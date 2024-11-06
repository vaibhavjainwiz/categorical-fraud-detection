# Use Red Hat UBI 9 minimal as the base image
FROM registry.access.redhat.com/ubi9/ubi-minimal:9.4

# Set environment variables
ENV PATH=/opt/conda/bin:$PATH \
    KAGGLE_CONFIG_DIR=/app/kaggle

# Install necessary packages, download Miniconda, and clean up in one layer
RUN microdnf install -y wget bzip2 && \
    wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /miniconda.sh && \
    bash /miniconda.sh -b -p /opt/conda && \
    rm /miniconda.sh && \
    microdnf clean all && \
    /opt/conda/bin/conda clean -afy

# Set the working directory
WORKDIR /app

# Copy the application code
COPY . /app

# Create and activate a conda environment with dependencies from environment.yml
RUN conda env create -f environment.yml && \
    conda clean -afy

# Activate environment and set it as default for the container
ENV CONDA_DEFAULT_ENV=triton_example
ENV PATH /opt/conda/envs/$CONDA_DEFAULT_ENV/bin:$PATH

# Expose a port if necessary
EXPOSE 8080

# Set the default command to run Jupyter Notebook
CMD ["bash", "-c", "source activate triton_example && jupyter notebook --ip=0.0.0.0 --port=8080 --no-browser --allow-root"]
