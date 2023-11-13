FROM python:3-alpine
WORKDIR /src
ENV FLASK_APP="/src/backend/app"
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_DEBUG=1
RUN apk add --no-cache gcc musl-dev linux-headers 
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
EXPOSE 5000
COPY . .
CMD ["flask", "run", "--debug"]