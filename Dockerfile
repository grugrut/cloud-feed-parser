FROM python:3.9

RUN pip install -r requirements.txt

CMD python feed.py