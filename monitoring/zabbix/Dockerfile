FROM python:3.11-alpine

RUN pip install requests

COPY setup-host.py /setup-host.py
RUN chmod +x /setup-host.py

CMD ["python3", "/setup-host.py"]
