FROM nvidia/cuda:8.0-cudnn5-devel
LABEL mantainer Paweł Kędra <pawelkedraa@gmail.com>

USER root

RUN apt-get update -y && apt-get upgrade -y && apt-get install -y \
	apt-utils \
	git \
	graphviz \
	nano \
	python3-dev \
	python3-pip \
	python3-numpy \
	python3-scipy

RUN pip3 install --upgrade pip

# Theano 0.9 (faster on new CUDA 8.0 than stable version from pip) CURRENTLY BROKEN
# RUN pip3 install --no-deps git+git://github.com/Theano/Theano.git
RUN pip3 install theano

RUN pip3 install keras h5py pydot-ng scikit-learn jupyter

# Theano config
RUN echo "[global]\ndevice = gpu\nfloatX = float32\n\n[cuda]\nroot = /usr/local/cuda" > ~/.theanorc

# Keras config
RUN mkdir ~/.keras
RUN echo "{\n\t\"image_dim_ordering\": \"th\",\n\t\"floatx\": \"float32\",\n\t\"backend\": \"theano\",\n\t\"epsilon\": 1e-07\n}" > ~/.keras/keras.json

# Jupyter config
RUN mkdir ~/.jupyter
RUN openssl req -x509 -nodes -days 9999 -newkey rsa:2048 -keyout ~/.jupyter/jupyter_SSL_cert.pem -out ~/.jupyter/jupyter_SSL_cert.pem -subj "/C=PL/ST=anystate/L=anycity/O=anyorganization/CN=Jupyter Server"
COPY jupyter_notebook_config.py /root/.jupyter
COPY set_jupyter_password.py /root
COPY run_secured_jupyter.sh /root

ENV PATH $PATH:/root

# From http://jupyter-notebook.readthedocs.io/en/latest/public_server.html:
# Add Tini. Tini operates as a process subreaper for jupyter. This prevents kernel crashes.
ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]