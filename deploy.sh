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
    if [ ! -d /vagrant/dump1090 ]; then
        git clone http://github.com/MalcolmRobb/dump1090.git /vagrant/dump1090
    fi
}

link_application () {
    for binary in dump1090 view1090; do
        if [ ! -L "$PREFIX/bin/$binary" ]; then
            ln -s "/vagrant/dump1090/$binary" "$PREFIX/bin/$binary"
        fi
    done

    if [ ! -L "/home/vagrant/public_html" ]; then
        ln -s "/vagrant/dump1090/public_html" "/home/vagrant/public_html"
    fi
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

main () {
    install_script redeploy <<'EOF'
#!/bin/sh
sudo sh /vagrant/deploy.sh
EOF

    apt-get update -y

    install_packages \
        airspy \
        alsa-utils \
        build-essential \
        git \
        pkg-config \
        rtl-sdr \
        librtlsdr-dev \
        libusb-1.0-0 \
        libusb-1.0-0-dev \

    clone_application

    build_application

    link_application
}

main
