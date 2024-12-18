#!/bin/bash

docker build -t ros-humble-turtlebot-3 .
docker run -it --net=host --privileged --volume /dev:/dev ros-humble-turtlebot-3