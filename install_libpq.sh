#!/bin/bash
set -e

POSTGRES_VERSION="11.3"
POSTGRES_DIR="${pwd}/vendor/postgres-${POSTGRES_VERSION}"
OPENSSL_DIR="${pwd}/vendor/openssl-${OPENSSL_VERSION}"
TMP_DIR="/tmp/postgres"
JOBS="-j$(nproc || echo 1)"

if [ -d "${TMP_DIR}" ]; then
  rm -rf "${TMP_DIR}"
fi

mkdir -p "${TMP_DIR}"

curl https://ftp.postgresql.org/pub/source/v${POSTGRES_VERSION}/postgresql-${POSTGRES_VERSION}.tar.gz | \
  tar -C "${TMP_DIR}" -xzf -

ls -lah $TMP_DIR
cd "${TMP_DIR}/postgres-${POSTGRES_VERSION}"

if [ -d "${POSTGRES_DIR}" ]; then
  rm -rf "${POSTGRES_DIR}"
fi

mkdir -p $POSTGRES_DIR
./configure --prefix=$POSTGRES_DIR --with-openssl --without-readline

cd src/interfaces/libpq; make; make install; cd -
cd src/bin/pg_config; make install; cd -
cd src/backend; make generated-headers; cd -
cd src/include; make install; cd -
