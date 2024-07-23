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
docker run -p 5901:5901 -p 6080:6080 go2-ros2
```

Use a VNC client to connect to `localhost:5901`

OR 

Open a web browser and go to `http://localhost:6080/vnc.html`



