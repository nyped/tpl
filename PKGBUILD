# Maintainer: lennypeers <lennypeers+git at protonmail>
pkgname=tpl
pkgver=0.2
pkgrel=1
pkgdesc="template creator"
arch=(x86_64)
url="https://github.com/lennypeers/tpl"
license=(MIT)
depends=(bash)
makedepends=(git)
source=("git+https://github.com/lennypeers/tpl.git")
md5sums=('SKIP')

package() {
	cd "$srcdir/$pkgname"
	install -v -d $pkgdir/usr/share/tpl/templates
	install -vDm0644 src/templates/* $pkgdir/usr/share/tpl/templates
	install -vDm0644 src/config $pkgdir/usr/share/tpl/config
	install -vDm0755 src/tpl.sh $pkgdir/usr/bin/tpl
}
