Steps for setting up the project and running the flask app in simulator


1.  goto flask_app and do "docker build -t flask_api_app ."
2. "docker save -o flask_api_app.tar flask_api_app"
3. "move flask_api_app.tar ..\edge-flask-simulator\
4.  go to edge-flask-simulator and run "docker build -t qemu-edge-flask-simulator ."
5. docker run -d --privileged --name edge_flask_simulator -p 5000:5000 qemu-edge-flask-simulator

OR simply run docker-compose up -d
