# Unitree-Go2-Dockerfile
Dockerfile built to support the use of https://github.com/abizovnuralem/go2_ros2_sdk

## Usage

### Step 1: Install Docker 
https://docs.docker.com/engine/install/


### Step 2: Clone this repository and build the docker container
```
git clone https://github.com/BenCaunt/Unitree-Go2-Dockerfile.git
cd Unitree-Go2-Dockerfile/
docker build -t unitree-go2-dockerfile . --ulimit nofile=1024
```

Note: the --ulimit flag was used to help dependency install performance on my machine, it might not be necessary.  

### Step 3: Start Container

First launch the docker engine, then run this command to start the container and VNC:
```
docker run -p 5901:5901 -p 6080:6080 unitree-go2-dockerfile
```

### Step 4: Gain access to the desktop enviornment

Use a VNC client to connect to `localhost:5901`

OR 

Open a web browser and go to `http://localhost:6080/vnc.html`

### Step 5: Follow Steps from the original repository (Terminal INSIDE container)

```
source install/setup.bash
export ROBOT_IP="robot_ip"
export CONN_TYPE="webrtc"
ros2 launch go2_robot_sdk robot.launch.py
```

Complete info can be found here
https://github.com/abizovnuralem/go2_ros2_sdk

### Architecture Considerations 
This project has been tested on Arm64 (Apple Silicon) systems only so far, if it successfully builds on x86 please let me know and I will update this! 



