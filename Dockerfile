# This is an auto generated Dockerfile for ros:ros-base
# generated from docker_images_ros2/create_ros_image.Dockerfile.em
FROM ros:humble-ros-core-jammy

# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    git \
    python3-colcon-common-extensions \
    python3-colcon-mixin \
    python3-rosdep \
    python3-vcstool \
    && rm -rf /var/lib/apt/lists/*

# bootstrap rosdep
RUN rosdep init && \
  rosdep update --rosdistro $ROS_DISTRO

# setup colcon mixin and metadata
RUN colcon mixin add default \
      https://raw.githubusercontent.com/colcon/colcon-mixin-repository/master/index.yaml && \
    colcon mixin update && \
    colcon metadata add default \
      https://raw.githubusercontent.com/colcon/colcon-metadata-repository/master/index.yaml && \
    colcon metadata update

# install ros2 packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-humble-ros-base=0.10.0-1* \
    && rm -rf /var/lib/apt/lists/*

RUN locale
RUN apt update && sudo apt install locales -y
RUN locale-gen en_US en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
RUN LANG=en_US.UTF-8

RUN locale

RUN apt install software-properties-common -y
RUN add-apt-repository universe -y

RUN apt upgrade -y

RUN apt install python3-argcomplete python3-colcon-common-extensions libboost-system-dev build-essential -y
RUN apt install ros-humble-hls-lfcd-lds-driver -y
RUN apt install ros-humble-turtlebot3-msgs -y
RUN apt install ros-humble-dynamixel-sdk -y
RUN apt install libudev-dev -y

RUN mkdir -p ~/turtlebot3_ws/src && cd ~/turtlebot3_ws/src && \
    git clone -b humble https://github.com/ROBOTIS-GIT/turtlebot3.git && \
    git clone -b humble https://github.com/ROBOTIS-GIT/ld08_driver.git && \
    cd ~/turtlebot3_ws/src/turtlebot3 && \
    rm -r turtlebot3_cartographer turtlebot3_navigation2

RUN rm -rf /usr/src/gmock /usr/src/gtest

RUN . /opt/ros/$ROS_DISTRO/setup.sh && \
    cd ~/turtlebot3_ws/ && \
    colcon build \
        --symlink-install

RUN apt -y install udev
RUN service udev start

RUN . ~/turtlebot3_ws/install/setup.sh && \
    cp `ros2 pkg prefix turtlebot3_bringup`/share/turtlebot3_bringup/script/99-turtlebot3-cdc.rules /etc/udev/rules.d/

ENV ROS_DOMAIN_ID=30
ENV LDS_MODEL=LDS-01
ENV TURTLEBOT3_MODEL=burger

RUN touch /entrypoint.sh && \
    echo "cd ~/turtlebot3_ws" && \
    echo "source /opt/ros/humble/setup.bash" >> /entrypoint.sh && \
    echo "source install/setup.bash" >> /entrypoint.sh && \
    echo "ros2 launch turtlebot3_bringup robot.launch.py"

RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
