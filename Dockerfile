FROM ubuntu:20.04

# MAINTAINER ahmet <cahmet644@gmail.com>

MAINTAINER ahmet

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt install -y tcl

RUN apt-get update -y && apt-get upgrade -y

RUN apt-get install lsb-core -y

RUN apt-get update && apt-get install -y lsb-release && apt-get clean all

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

RUN apt-get install curl -y 

RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc |  apt-key add -

RUN apt-get update -y && apt-get upgrade -y

RUN apt-get install ros-noetic-desktop-full -y 

RUN echo "source /opt/ros/noetic/setup.bash" >>/root/.bashrc

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y apt-utils 2>&1 | \
    grep -v "^debconf: delaying package configuration, since apt-utils.*"


RUN apt-get install python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential -y

RUN apt-get install python3-rosdep -y 

RUN rosdep init

RUN sudo rosdep fix-permissions

RUN sudo rosdep update

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && sudo apt-get upgrade -y

RUN apt-get update && apt-get install --yes \
    build-essential \
    software-properties-common \
    pkg-config \
    cmake \
    g++

RUN set -xe \
    && apt-get update -y \
    && apt-get install -y python3-pip

RUN sudo pip install -U rosdep rosinstall_generator vcstool rosinstall

COPY /image_undistorted_cpp_pkg/ home/ros_docker/src/image_undistorted_cpp_pkg/

WORKDIR /home/ros_docker

RUN /bin/bash -c 'source /opt/ros/noetic/setup.bash &&\
    mkdir -p ~/docker_ros/src &&\
    cd ~/docker_ros/src &&\
    #catkin_init_workspace &&\
    cd ~/docker_ros &&\
    catkin_make'

RUN /bin/bash -c "source /opt/ros/noetic/setup.bash && \
    catkin_make"

RUN apt-get install ros-noetic-usb-cam -y

RUN echo "source devel/setup.bash" >>/root/.bashrc

# RUN echo "roslaunch image_undistorted_cpp_pkg image_undistortedex.launch" >>/root/.bashrc
