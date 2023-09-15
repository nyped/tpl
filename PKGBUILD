# Maintainer: lennypeers <lennypeers+git at gmail>
pkgname=tpl
pkgver=0.5.0
pkgrel=1
pkgdesc="template creator"
arch=('any')
url="https://github.com/nyped/tpl"
license=(MIT)
depends=(bash gettext)
makedepends=(git)
source=("git+https://github.com/nyped/tpl.git")
sha512sums=('SKIP')

package() {
	cd "$srcdir/$pkgname"
	install -v -d $pkgdir/usr/share/tpl/templates
	install -vDm0644 src/templates/* $pkgdir/usr/share/tpl/templates
	install -vDm0644 src/config $pkgdir/usr/share/tpl/config
	install -vDm0755 src/tpl.sh $pkgdir/usr/bin/tpl
}
