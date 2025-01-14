FROM python:3.8.10

WORKDIR /python-docker
RUN apt-get update && apt-get install ffmpeg libsm6 libxext6  -y

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt


COPY . .


#CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0", "-p", PORT]
CMD make run
