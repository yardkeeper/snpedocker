#Snapdragon Neural Processing Engine SDK Dockerfile
FROM ubuntu:18.04

ARG GID=1000
ARG UID=1000
#ENV PATH="/home/user/miniconda3/bin:${PATH}"
#ARG PATH="/home/user/miniconda3/bin:${PATH}"
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Jerusalem
#add new sudo user

ENV USERNAME user
ENV HOME /home/$USERNAME
RUN useradd -m $USERNAME && \
        echo "$USERNAME:$USERNAME" | chpasswd && \
        usermod --shell /bin/bash $USERNAME && \
        usermod -aG sudo $USERNAME && \
        mkdir /etc/sudoers.d && \
        echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME && \
        chmod 0440 /etc/sudoers.d/$USERNAME && \
        # replace 1000 with your user/group id
        usermod  --uid ${UID} $USERNAME && \
        groupmod --gid ${GID} $USERNAME

#software installation
RUN  apt update && apt install  apt-utils -y
RUN  apt install sudo mc  wget mlocate unzip xauth wget dialog libc++-9-dev libcanberra-gtk-module libcanberra-gtk3-module libx11-xcb1 net-tools libcanberra-gtk-module build-essential  python3.6 python3-mako python-protobuf python3-skimage  python3-matplotlib python3-scipy python-sphinx python3-mako -y
RUN  rm -f /usr/bin/python && ln -s /usr/bin/python3.6 /usr/bin/python
RUN  sudo apt install python3-pip -y  && sudo -u  user python -m pip install --upgrade pip
#RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && sudo -u  user mkdir /home/user/.conda && sudo -u bash Miniconda3-latest-Linux-x86_64.sh -b  && rm -f Miniconda3-latest-Linux-x86_64.sh
RUN  sudo -u  user python -m pip install torch==1.8.1+cu102 torchvision==0.9.1+cu102 torchaudio==0.8.1 -f https://download.pytorch.org/whl/torch_stable.html
RUN  sudo -u  user python -m pip install sphinx scipy matplotlib scikit-image protobuf pyyaml mako attrs pytest
#sphinx scipy matplotlib scikit-image protobuf pyyaml mako
COPY --chown=user:user android-ndk-r17c-linux-x86_64.zip /home/${USERNAME}/
COPY --chown=user:user snpe-1.61.0.zip /home/${USERNAME}/
WORKDIR /home/${USERNAME}
RUN unzip /home/${USERNAME}/android-ndk-r17c-linux-x86_64.zip && unzip /home/${USERNAME}/snpe-1.61.0.zip && \
    rm /home/${USERNAME}/android-ndk-r17c-linux-x86_64.zip && rm /home/${USERNAME}/snpe-1.61.0.zip
RUN chown user:user -R /home/${USERNAME}/android-ndk-r17c && chown user:user -R /home/${USERNAME}/snpe-1.61.0.3358
RUN bash /home/user/snpe-1.61.0.3358/bin/dependencies.sh
RUN echo "export ANDROID_NDK_ROOT=/home/user/android-ndk-r17c" >> /home/user/.bashrc
RUN echo "export SNPE_ROOT=/home/user/snpe-1.61.0.3358" >> /home/user/.bashrc
RUN echo "export PYTHONPATH=/usr/bin/python:/home/user/snpe-1.61.0.3358/lib/python" >> /home/user/.bashrc

