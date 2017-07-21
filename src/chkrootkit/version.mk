NAME		= chkrootkit

VERSION		= 0.52
RELEASE		= 1

PKGROOT		= /opt/chkrootkit
CHKFILES	= chkwtmp ifpromisc chkutmp check_wtmpx chklastlog \
			chkproc chkdirs chkrootkit strings-static
RPM.FILES	= $(PKGROOT)
RPM.DESCRIPTION = This program locally checks for signs of a rootkit.  chkrootkit is available at: http://www.chkrootkit.org/
