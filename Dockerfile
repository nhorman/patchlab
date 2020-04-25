#NEEDED ENVIRONMENT VARIABLES
#AMQP_BROKER
#WEBHOOK_PORT
# The uri of the amqp broker for this instance

FROM python:3
RUN pip install --upgrade django-filter djangorestframework psycopg2 vcrpy backoff celery django requests python-gitlab

RUN git clone https://github.com/getpatchwork/patchwork.git

ENV PYTHONPATH=/usr/local/lib/python3.8/site-packages:/patchwork

RUN mkdir patchlab
COPY . /patchlab/
RUN cd patchlab && python ./setup.py build
RUN cd patchlab && python ./setup.py install

ENTRYPOINT cd patchlab && python ./manage.py runserver 0.0.0.0:8888

EXPOSE 8888/tcp 

