#!/bin/bash
set -e

if [ ${#} -lt 1 ]; then
  echo "OpenSSL version required." 1>&2
  exit 1
fi

OPENSSL_VERSION="${1}"
OPENSSL_DIR="$(pwd)/vendor/openssl-${OPENSSL_VERSION}"
TMP_DIR="/tmp/openssl"
JOBS="-j$(nproc || echo 1)"

if [ -d "${TMP_DIR}" ]; then
  rm -rf "${TMP_DIR}"
fi
mkdir -p "${TMP_DIR}"

curl https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz | \
  tar -C "${TMP_DIR}" -xzf -

cd "${TMP_DIR}/openssl-${OPENSSL_VERSION}"

if [ -d "${OPENSSL_DIR}" ]; then
  rm -rf "${OPENSSL_DIR}"
fi
mkdir -p $OPENSSL_DIR

./config \
  --prefix=${OPENSSL_DIR} \
  enable-crypto-mdebug enable-crypto-mdebug-backtrace

make -s $JOBS
make install_sw

export PATH="${OPENSSL_DIR}/bin:${PATH}"
export CFLAGS="-I${OPENSSL_DIR}/include"
export LDFLAGS="-L${OPENSSL_DIR}/lib"
export LD_LIBRARY_PATH="${OPENSSL_DIR}/lib"
export PKG_CONFIG_PATH="${OPENSSL_DIR}/lib/pkgconfig"

ls -lah $OPENSSL_DIR