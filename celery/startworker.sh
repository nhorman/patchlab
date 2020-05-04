#!/bin/sh
celery -A patchlab worker --loglevel=info &

