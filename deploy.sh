#!/bin/sh
#
# deploy.sh: Idempotent script for building and deploying Malcom Robb's
#            adaption of Antirez's 'dump1090' application within a Vagrant VM.
#

set -e

PREFIX="/usr/local"

build_application () {
    cd /vagrant/dump1090
    make clean && make
}

clone_application () {
    cd /vagrant
    git clone git@github.com:MalcomRobb/dump1090.git
}

link_application () {
    for binary in dump1090 view1090; do
        if [ ! -L "$PREFIX/bin/$binary" ]; then
            ln -s "/vagrant/dump1090/$binary" "$PREFIX/bin/$binary"
        fi
    done
}

install_packages () {
    while [ $# -ne 0 ] ; do
        if [ -e /usr/share/doc/"$1" ] ; then
            printf 'Package already installed: %s\n' "$1" >&2
            shift
        else
            apt-get install -y "$@"
            break
        fi
    done
}

install_script () {
    SCRIPT="$PREFIX/$1"
    printf "Installing %s...\n" "$SCRIPT" >&2
    cat > "$SCRIPT"
    chmod 755 "$SCRIPT"
}

install_script redeploy <<'EOF'
#!/bin/sh
sudo sh /vagrant/deploy.sh
EOF

apt-get update -y

install_packages \
    airspy \
    alsa-utils \
    build-essential \
    librtlsdr \
    librtlsdr-dev \
    libusb-1.0-0 \
    libusb-1.0-0-dev \

clone_application

build_application

link_application
