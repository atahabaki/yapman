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
sha256sums=("d760b80d83ab9bfbf3ce4fee2b7fd552cd87d6ed882d5bea8db20c1326447c98"
            "SKIP")
build() {
    cd "$pkgname-$pkgver"
    make
}

package() {
    cd "$pkgname-$pkgver"
    make DESTDIR="$pkgdir" install
}