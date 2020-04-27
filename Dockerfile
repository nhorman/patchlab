#NEEDED ENVIRONMENT VARIABLES
#AMQP_BROKER
#WEBHOOK_PORT
# The uri of the amqp broker for this instance

FROM python:3
ARG DJANGO_SUPERUSER_PASSWORD=admin
RUN pip install vcrpy django-six

ENV PYTHONPATH=/usr/local/lib/python3.8/site-packages:/patchwork

RUN git clone https://github.com/jeremycline/patchwork.git
RUN cd patchwork && python ./setup.py build
RUN cd patchwork && python ./setup.py install

RUN mkdir patchlab
COPY . /patchlab/
RUN cd patchlab && python ./setup.py build
RUN cd patchlab && python ./setup.py install
RUN cd patchlab && python ./manage.py migrate
RUN cd patchlab && python ./manage.py shell -c "from django.contrib.auth.models import User; u = User.objects.get(username='admin'); u.set_password('admin'); u.save()"
ENTRYPOINT cd patchlab && python ./manage.py migrate && python ./manage.py runserver 0.0.0.0:8888

EXPOSE 8888/tcp 

