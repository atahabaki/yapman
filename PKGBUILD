# Maintainer A. Taha Baki
pkgname=yapman
pkgver=2.0.0
pkgdesc="Yet Another AUR Package Manager. Lightweight and powerful."
arch=('any')
url="https://github.com/atahabaki/yapman"
license="MIT"
depends=(
    'pacman',
    'sudo',
    'git',
    'curl',
    'jq'
)
source=("$pkgname-$pkgver.tar.xz::$url/releases/download/$pkgver/v$pkgver.tar.xz")
sha256sums=("f2f00262f5ccf248b91921eb80c84288350d29a420c874590dc3f211777385ef"
            "SKIP")
build() {
    cd "$pkgname-$pkgver"
    make
}

package() {
    cd "$pkgname-$pkgver"
    make DESTDIR="$pkgdir" install
}