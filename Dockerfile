FROM python:3.12-alpine

ENV FLASK_APP="/src/backend/app"
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_DEBUG=1
ENV PYTHONDONTWRITEBYTECODE=1

RUN apk add --no-cache --update \
    python3 python3-dev gcc \
    gfortran musl-dev g++ \
    libffi-dev openssl-dev \
    libxml2 libxml2-dev \
    libxslt libxslt-dev \
    libjpeg-turbo-dev zlib-dev

RUN python3 -m pip install --upgrade pip

ADD requirements.txt .
RUN  python3 -m pip install -r requirements.txt

EXPOSE 5000

WORKDIR /src

ADD datasets/sentieri-storico-culturali.xls /assets/datasets/

COPY backend/ .

CMD [ "flask", "run" ]