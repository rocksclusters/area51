# $Id: Makefile,v 1.20 2012/05/06 05:48:05 phil Exp $
#
# Moved over from contrib area into the area51 roll.  This move makes the
# Make and Spec files simpler. (Rolls still Rock)
#
# @Copyright@
# 
# 				Rocks(r)
# 		         www.rocksclusters.org
# 		         version 5.5 (Mamba)
# 		         version 6.0 (Mamba)
# 
# Copyright (c) 2000 - 2012 The Regents of the University of California.
# All rights reserved.	
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
# 
# 1. Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright
# notice unmodified and in its entirety, this list of conditions and the
# following disclaimer in the documentation and/or other materials provided 
# with the distribution.
# 
# 3. All advertising and press materials, printed or electronic, mentioning
# features or use of this software must display the following acknowledgement: 
# 
# 	"This product includes software developed by the Rocks(r)
# 	Cluster Group at the San Diego Supercomputer Center at the
# 	University of California, San Diego and its contributors."
# 
# 4. Except as permitted for the purposes of acknowledgment in paragraph 3,
# neither the name or logo of this software nor the names of its
# authors may be used to endorse or promote products derived from this
# software without specific prior written permission.  The name of the
# software includes the following terms, and any derivatives thereof:
# "Rocks", "Rocks Clusters", and "Avalanche Installer".  For licensing of 
# the associated name, interested parties should contact Technology 
# Transfer & Intellectual Property Services, University of California, 
# San Diego, 9500 Gilman Drive, Mail Code 0910, La Jolla, CA 92093-0910, 
# Ph: (858) 534-5815, FAX: (858) 534-7345, E-MAIL:invent@ucsd.edu
# 
# THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS''
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# 
# @Copyright@
#
# $Log: Makefile,v $
# Revision 1.20  2012/05/06 05:48:05  phil
# Copyright Storm for Mamba
#
# Revision 1.19  2011/07/23 02:30:13  phil
# Viper Copyright
#
# Revision 1.18  2010/09/07 23:52:46  bruno
# star power for gb
#
# Revision 1.17  2010/08/25 19:38:07  bruno
# touch up the area51 roll for the 5.4 beta
#
# Revision 1.16  2009/05/01 19:06:46  mjk
# chimi con queso
#
# Revision 1.15  2008/10/18 00:55:44  mjk
# copyright 5.1
#
# Revision 1.14  2008/03/06 23:41:29  mjk
# copyright storm on
#
# Revision 1.13  2007/06/23 04:03:17  mjk
# mars hill copyright
#
# Revision 1.12  2006/09/11 22:46:54  mjk
# monkey face copyright
#
# Revision 1.11  2006/08/10 00:09:18  mjk
# 4.2 copyright
#
# Revision 1.10  2005/10/15 20:31:29  phil
# Tell user what's going on. Properly build the md5 sums
#
# Revision 1.9  2005/10/15 16:26:17  phil
# Add md5 check at startup. Need to do some macro mashing, so make
# post-99-tripwire an "in" file
#
# Revision 1.8  2005/10/15 16:21:09  phil
# Make a reasonable tripwire homepage
#
# Revision 1.7  2005/10/12 18:08:23  mjk
# final copyright for 4.1
#
# Revision 1.6  2005/09/16 01:02:03  mjk
# updated copyright
#
# Revision 1.5  2005/05/24 21:21:37  mjk
# update copyright, release is not any closer
#
# Revision 1.4  2004/04/30 21:22:53  mjk
# missed rc.d in install path
#
# Revision 1.3  2004/04/30 18:36:08  mjk
# - move post section from RPM to Graph
# - build database on system startup
#
# Revision 1.2  2004/04/29 00:59:41  mjk
# add cron job
#
# Revision 1.1  2004/04/29 00:53:51  mjk
# *** empty log message ***
#
# Revision 1.2  2004/04/22 06:01:48  mjk
# still doesn't build, blah
#
# Revision 1.1  2004/04/19 23:09:27  mjk
# *** empty log message ***


REDHAT.ROOT     = $(CURDIR)/../../

-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk

SEDTRIP = \
	-e 's%@TWOPTDIR@%$(PKGROOT)%g' \
	-e 's%@TWCONFIGDIR@%$(PKGROOT)/etc%g' \
	-e 's%@WWWTWROOT@%/var/www/html/tripwire%g'


tripwire.cron: tripwire.cron.in
	$(SED) $(SEDTRIP) $^ > $@

post-99-tripwire: post-99-tripwire.in
	$(SED) $(SEDTRIP) $^ > $@

build: tripwire.cron post-99-tripwire
	(								\
		cd etc;							\
		for file in `find -name "*.in"`; do			\
			outfile=`dirname $$file`/`basename $$file .in`;	\
			$(SED) $(SEDTRIP) $$file > $$outfile;		\
		done;							\
	)



install:: 
	mkdir -p $(ROOT)/$(PKGROOT)/etc
	mkdir -p $(ROOT)/etc/cron.daily
	mkdir -p $(ROOT)/etc/rc.d/rocksconfig.d
	install -m 700 tripwire.cron $(ROOT)/etc/cron.daily/tripwire
	install -m 755 post-99-tripwire $(ROOT)/etc/rc.d/rocksconfig.d/
	cd etc && find . -type f | cpio -pduv $(ROOT)/$(PKGROOT)/etc/
	find $(ROOT)/$(PKGROOT)/etc/ -name "CVS"  -type d | xargs rm -rf 
	find $(ROOT)/$(PKGROOT)/etc/ -name "*.in" -type f | xargs rm -f 


clean::
	rm -rf $(NAME)-$(VERSION)


