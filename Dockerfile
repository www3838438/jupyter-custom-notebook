FROM jupyter/base-notebook:latest

MAINTAINER maxmtmn@gmail.com

USER root

RUN apt-get -y update && apt-get install -y build-essential git

USER $NB_USER

RUN wget https://bootstrap.pypa.io/get-pip.py && python get-pip.py && unlink get-pip.py

RUN git clone https://github.com/semeyon/route4me-python-sdk.git /home/jovyan/route4me-python-sdk

RUN ipython profile create

RUN echo "c.InteractiveShellApp.exec_lines = ['import sys; sys.path.append(\"/home/jovyan/work/\")', 'import sys; sys.path.append(\"/home/jovyan/route4me-python-sdk\")', ]" >> /home/jovyan/.ipython/profile_default/ipython_config.py

ADD requirements*.txt ./

RUN pip install -r requirements-charts.txt
RUN pip install -r requirements-heavy.txt
RUN pip install -r requirements.txt
RUN pip install -r requirements-dev.txt

USER root

RUN apt-get remove -y build-essential git && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /usr/share/locale/* && \
    rm -rf /var/cache/debconf/*-old && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/share/doc/*

USER $NB_USER