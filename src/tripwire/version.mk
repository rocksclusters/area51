NAME		= tripwire

VERSION		= 2.4.3.5
RELEASE		= 1
TARBALL_POSTFIX = .tar.gz
TAROPTS		= xzvf
SUBDIR		= tripwire-open-source-$(VERSION)


PKGROOT		= /opt/tripwire
RPM.FILES	= $(PKGROOT) 
