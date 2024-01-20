FROM python:3.8-alpine

WORKDIR /app
COPY app.py .

RUN pip install Flask requests

CMD ["python", "app.py"]
