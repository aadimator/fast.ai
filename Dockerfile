FROM nvidia/cuda:latest

LABEL com.nvidia.volumes.needed="nvidia_driver"
RUN apt-get update && apt-get install -y --no-install-recommends \
         build-essential \
         git \
         curl \
         ca-certificates \
         libjpeg-dev \
         libsm6 \
         libxrender1 \
         libfontconfig1 \
         libpng-dev \
         python-qt4 && \
     rm -rf /var/lib/apt/lists/*

RUN curl -o ~/miniconda.sh -O  https://repo.continuum.io/miniconda/Miniconda3-4.2.12-Linux-x86_64.sh  && \
     chmod +x ~/miniconda.sh && \
     ~/miniconda.sh -b -p /opt/conda && \
     rm ~/miniconda.sh && \
     /opt/conda/bin/conda install conda-build

RUN mkdir workspace
RUN git clone https://github.com/fastai/fastai.git /workspace/fastai
RUN cd /workspace/fastai/ && /opt/conda/bin/conda env create
RUN /opt/conda/bin/conda clean -ya

ENV PATH /opt/conda/envs/fastai/bin:$PATH
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64
ENV USER fastai

WORKDIR /workspace

RUN chmod -R a+w /workspace
RUN cd /workspace
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--no-browser", "--allow-root"]
