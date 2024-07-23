# Use ROS2 Humble base image
FROM ros:humble-ros-base

# Set environment variables
ENV ROS_DISTRO=humble
ENV DEBIAN_FRONTEND=noninteractive
ENV USER=root
ENV HOME=/root

# Install system dependencies and VNC-related packages
RUN apt-get update && apt-get install -y \
    git \
    python3-pip \
    clang \
    curl \
    build-essential \
    gnupg2 \
    lsb-release \
    libavutil-dev \
    libavformat-dev \
    libavcodec-dev \
    libswscale-dev \
    libavdevice-dev \
    ffmpeg \
    pkg-config \
    xfce4 \
    xfce4-goodies \
    tightvncserver \
    novnc \
    websockify \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustup default stable

# Set up ROS2 workspace
WORKDIR /ros2_ws
RUN mkdir -p /ros2_ws/src

# Clone and set up go2_ros2_sdk
WORKDIR /ros2_ws/src
RUN git clone --recurse-submodules https://github.com/abizovnuralem/go2_ros2_sdk.git \
    && cp -a go2_ros2_sdk/. . \
    && rm -rf go2_ros2_sdk

# Install Python dependencies
WORKDIR /ros2_ws/src
RUN pip install -r requirements.txt || \
    (pip install virtualenv && \
    virtualenv -p python3.11 venv && \
    . venv/bin/activate && \
    pip install -r requirements.txt && \
    deactivate)

# Source ROS2 setup script
RUN /bin/bash -c "source /opt/ros/humble/setup.bash"

RUN /bin/bash -c "apt-get update && apt-get install -y \
ros-humble-foxglove-bridge \
ros-humble-rviz2"

# Install ROS2 dependencies
WORKDIR /ros2_ws
RUN /bin/bash -c "source /opt/ros/humble/setup.bash && rosdep update && rosdep install --from-paths src --ignore-src -r -y"

# Build the ROS2 workspace
RUN /bin/bash -c "source /opt/ros/humble/setup.bash && colcon build"

# Source the workspace in .bashrc
RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc
RUN echo "source /ros2_ws/install/setup.bash" >> /root/.bashrc

# Set up VNC server
RUN mkdir ~/.vnc
RUN echo "123456" | vncpasswd -f > ~/.vnc/passwd
RUN chmod 600 ~/.vnc/passwd
RUN echo "#!/bin/sh\nxrdb $HOME/.Xresources\nstartxfce4 &" > ~/.vnc/xstartup
RUN chmod +x ~/.vnc/xstartup

# Expose VNC and noVNC ports
EXPOSE 5901 6080

# Create a startup script
RUN echo '#!/bin/bash\nVNCPORT=1\nBROWSERPORT=6080\nvncserver :${VNCPORT} -geometry 1280x800 -depth 24 && websockify --web /usr/share/novnc/ ${BROWSERPORT} localhost:590${VNCPORT}' > /startup.sh
RUN chmod +x /startup.sh

# Start VNC server and noVNC
CMD ["/startup.sh"]
