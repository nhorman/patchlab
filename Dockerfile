#NEEDED ENVIRONMENT VARIABLES
#AMQP_BROKER
#WEBHOOK_PORT
# The uri of the amqp broker for this instance
FROM fedora:latest

RUN dnf install -y python3 fetchmail python3-pip git-core python3-celery
ARG DJANGO_SUPERUSER_PASSWORD=admin

RUN pip install vcrpy django-six

ENV PYTHONPATH=/usr/local/lib/python3.8/site-packages:/patchwork

RUN useradd -r -u 1001 -g root appuser
RUN mkdir /etc/fetchmail
RUN chmod 777 /etc/fetchmail
COPY fetchmail/fetchmailrc /etc/fetchmail/fetchmailrc
RUN chmod 666 /etc/fetchmail/fetchmailrc
COPY fetchmail/poll_fetchmail.sh /usr/bin/poll_fetchmail.sh
RUN chmod 755 /usr/bin/poll_fetchmail.sh
RUN chmod g=u /etc/passwd
RUN echo "nameserver 10.11.5.19" >> /etc/resolv.conf

COPY config/python-gitlab.cfg /etc/
RUN chmod 666 /etc/python-gitlab.cfg
RUN chmod 777 /etc

RUN git clone https://github.com/jeremycline/patchwork.git
RUN cd patchwork && python3 ./setup.py build
RUN cd patchwork && python3 ./setup.py install

RUN mkdir patchlab
COPY . /patchlab/
RUN cd patchlab && python3 ./setup.py build
RUN cd patchlab && python3 ./setup.py install
RUN cd patchlab && python3 ./manage.py migrate
RUN cd patchlab && python3 ./manage.py loaddata default_tags default_states
RUN cd patchlab && python3 ./manage.py shell < ./scripts/createadminuser.py
ENTRYPOINT cd patchlab && sed -i -e"s/PUT_API_TOKEN_HERE/$GITLAB_API_TOKEN/" /etc/python-gitlab.cfg && celery -A patchlab worker --loglevel=info && python3 ./manage.py migrate && /usr/bin/poll_fetchmail.sh && python3 ./manage.py runserver 0.0.0.0:8888
USER appuser
EXPOSE 8888/tcp 

