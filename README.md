# ML environment Docker image

Docker image with CUDA 8, cuDNN 5.1.10, Python 3, Theano, Keras and Jupyter Notebook installed. GPU acceleration available if you use [nvidia-docker](https://github.com/NVIDIA/nvidia-docker).

## Requirements
* Installed Docker
* If want to use GPU: installed [nvidia-docker](https://github.com/NVIDIA/nvidia-docker) plugin for Docker and NVIDIA GPU drivers

## Building image

```docker build -t ml-env .```

where ```ml-env``` can be replaced with any other name.

## Running container

```nvidia-docker run -it --rm -p 8888:8888 --volume $(pwd):/host_dir --workdir /host_dir ml-env bash```

This command creates and starts container from previously built image (```ml-env```) with current host directory mounted as /host_dir () and set as working directory.

### What does this weird parameters mean?

* ```-it``` - redirects std and stdout from container to your terminal.
* ```--rm``` - removes container after exit.
* ```-p 8888:8888``` - exposes port 8888 (in:out) from container to host. Required by Jupyter Notebook.
* ```--volume $(pwd):/host_dir``` - mounts current host directory (```$(pwd)```) in container in ```/host_dir```. Instead of ```$(pwd)``` you can put any other path.
* ```--workdir /host_dir``` - sets current directory in container to previously mounted.
* ```ml-env``` - name of image to create container from.

### Running directly Python or Jupyter

```nvidia-docker run -it --rm -p 8888:8888 --volume $(pwd):/host_dir --workdir /host_dir ml-env python3 /host_dir/hello_world.py```

or

```nvidia-docker run -it --rm -p 8888:8888 --volume $(pwd):/host_dir --workdir /host_dir ml-env jupyter notebook```

or any other command at the end instead of python3 or jupyter.

If you need Jupyter secured by password, run command below and enter password:

```nvidia-docker run -it --rm -p 8888:8888 --volume $(pwd):/host_dir --workdir /host_dir ml-env run_secured_jupyter.sh```