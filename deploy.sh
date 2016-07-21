#!/bin/sh
#
# deploy.sh: Idempotent script for building and deploying Malcom Robb's
#            adaption of Antirez's 'dump1090' application and Elias Oenal's
#            'multimonNG' within a Vagrant VM.
#

set -e

PREFIX="/usr/local"

build_application () {
     [ -d "/vagrant/dump1090" ] || exit 1

     cd "/vagrant/dump1090"
     make clean
     make

    [ -d "/vagrant/multimon-ng" ] || exit 1

    if [ ! -d "/vagrant/multimon-ng/build" ]; then
        mkdir "/vagrant/multimon-ng/build"
    fi
    cd "/vagrant/multimon-ng/build"
    qmake ../"multimon-ng.pro" PREFIX="$PREFIX"
    make
    make install
}

clone_application () {
    if [ ! -d "/vagrant/dump1090" ]; then
        git clone http://github.com/MalcolmRobb/dump1090.git "/vagrant/dump1090"
    fi

    if [ ! -d "/vagrant/multimon-ng" ]; then
        git clone http://github.com/EliasOenal/multimon-ng.git "/vagrant/multimon-ng"
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
    SCRIPT="$PREFIX/bin/$1"
    printf "Installing %s...\n" "$SCRIPT" >&2
    cat > "$SCRIPT"
    chmod 755 "$SCRIPT"
}

main () {
    install_script redeploy <<'EOF'
#!/bin/sh
sudo sh /vagrant/deploy.sh
EOF

    install_script start-dump1090.sh <<'EOF'
#!/bin/sh
"/usr/local/bin/dump1090" --net --interactive
EOF

    install_script start-multimon-ng-POCSAG-NL.sh <<'EOF'
#!/bin/sh
"/usr/bin/rtl_fm" -f 172.45e6 -s 22050 -g 100 - | \
    "/usr/local/bin/multimon-ng" -c -a POCSAG512 -a POCSAG1200 -a POCSAG2400 -t raw -
EOF

    apt-get update -y

    install_packages \
        airspy \
        alsa-utils \
        build-essential \
        git \
        libpulse-dev \
        librtlsdr-dev \
        libusb-1.0-0 \
        libusb-1.0-0-dev \
        pkg-config \
        qt5-default \
        rtl-sdr

    clone_application

    build_application

    link_application
}

main
