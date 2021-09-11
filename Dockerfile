# For more information, please refer to https://aka.ms/vscode-docker-python
FROM python:3.8-slim-buster

RUN  sudo apt-get sudo update && apt-get install -y wget && sudo rm -rf /var/lib/apt/lists/*
# SET TIME ZONE AND LOCAL TIME
RUN echo "Europe/Dublin" > /etc/timezone
RUN ln -fs /usr/share/zoneinfo/UTC /etc/localtime
# Install pip requirements
COPY ./requirements.txt /app/requirements.txt
WORKDIR /app

RUN  pip install -r requirements.txt
COPY . /app
# Switching to a non-root user, please refer to https://aka.ms/vscode-docker-python-user-rights

CMD [ "python","./main.py" ]