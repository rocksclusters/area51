# $Log: Makefile,v $
# Revision 1.16  2012/05/06 05:48:05  phil
# Copyright Storm for Mamba
#
# Revision 1.15  2011/07/23 02:30:13  phil
# Viper Copyright
#
# Revision 1.14  2010/09/07 23:52:46  bruno
# star power for gb
#
# Revision 1.13  2009/05/01 19:06:46  mjk
# chimi con queso
#
# Revision 1.12  2008/10/18 00:55:44  mjk
# copyright 5.1
#
# Revision 1.11  2008/03/06 23:41:29  mjk
# copyright storm on
#
# Revision 1.10  2007/06/23 04:03:17  mjk
# mars hill copyright
#
# Revision 1.9  2006/09/11 22:46:54  mjk
# monkey face copyright
#
# Revision 1.8  2006/08/10 00:09:19  mjk
# 4.2 copyright
#
# Revision 1.7  2005/10/15 16:21:11  phil
# Make a reasonable tripwire homepage
#
# Revision 1.6  2005/10/15 04:51:11  phil
# Add Tripwire to wordpress.
#
# Revision 1.5  2005/10/12 18:08:23  mjk
# final copyright for 4.1
#
# Revision 1.4  2005/09/16 01:02:04  mjk
# updated copyright
#
# Revision 1.3  2005/05/24 21:21:37  mjk
# update copyright, release is not any closer
#
# Revision 1.2  2004/04/30 22:24:00  mjk
# ignore tw return code on reports
#
# Revision 1.1  2004/04/20 00:35:12  mjk
# more pmp'n tripwire
#
# Revision 1.8  2004/04/18 21:44:43  phil
#
# Typo
#
# Revision 1.7  2004/04/15 06:21:11  phil
# Tripwire now compiles under GCC3 -- compat libs no longer needed
#
# Revision 1.6  2004/04/13 01:22:41  phil
# oops. Forgot md5 of POLICY FILE
#
# Revision 1.5  2004/04/13 00:46:05  phil
# Added md5 sum printout of config policy and tripwire exec.
# Added example cron file
# Fixed file permissions
#
# Revision 1.4  2004/04/12 17:48:12  phil
#
# Added check and print-report targets for Makefile
#
# Revision 1.3  2004/04/12 06:05:28  phil
#
# Config and Tripwire RPM now build properly. Need to adjust permissions
# and create cron files.
#
# Revision 1.2  2004/04/10 00:26:04  phil
#
# Almost completed
#
# Revision 1.1  2004/04/09 06:50:05  phil
# Closer to a configuration setup for tripwire
#
#
#@Copyright@
#
#				Rocks(r)
#		         www.rocksclusters.org
#		         version 5.5 (Mamba)
#		         version 6.0 (Mamba)
#
#Copyright (c) 2000 - 2012 The Regents of the University of California.
#All rights reserved.	
#
#Redistribution and use in source and binary forms, with or without
#modification, are permitted provided that the following conditions are
#met:
#
#1. Redistributions of source code must retain the above copyright
#notice, this list of conditions and the following disclaimer.
#
#2. Redistributions in binary form must reproduce the above copyright
#notice unmodified and in its entirety, this list of conditions and the
#following disclaimer in the documentation and/or other materials provided 
#with the distribution.
#
#3. All advertising and press materials, printed or electronic, mentioning
#features or use of this software must display the following acknowledgement: 
#
#	"This product includes software developed by the Rocks(r)
#	Cluster Group at the San Diego Supercomputer Center at the
#	University of California, San Diego and its contributors."
#
#4. Except as permitted for the purposes of acknowledgment in paragraph 3,
#neither the name or logo of this software nor the names of its
#authors may be used to endorse or promote products derived from this
#software without specific prior written permission.  The name of the
#software includes the following terms, and any derivatives thereof:
#"Rocks", "Rocks Clusters", and "Avalanche Installer".  For licensing of 
#the associated name, interested parties should contact Technology 
#Transfer & Intellectual Property Services, University of California, 
#San Diego, 9500 Gilman Drive, Mail Code 0910, La Jolla, CA 92093-0910, 
#Ph: (858) 534-5815, FAX: (858) 534-7345, E-MAIL:invent@ucsd.edu
#
#THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS''
#AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
#THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
#PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS
#BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
#CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
#SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
#BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
#WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
#OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
#IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#@Copyright@
#
#
# Read the TripWire Parameters
include ./config.tw

SHELL = /bin/bash
COMPONENTS = 	admin appinfo binaries bootfiles boot-volatile config \
		data devctl devices invariants kadmin libs network \
		osbin osutils profiles root-home sadmin security \
		shellbin sinfo symlinks tmpdirs userbin
OUTLINEDIR = twpol-parts
OUTLINE = twpol-outline 

ONETIMEPASS=`dd if=/dev/random count=32 bs=1 | tr -d -c [:alnum:]`  

help:
	/bin/more ./README

initialize-interactive: policy config 
	${SHELL} ./twsetup.sh -i
	touch ./initialized
	make -s md5

initialize-batch: policy config 
	${SHELL} ./twsetup.sh -n -s ${ONETIMEPASS} -l ${ONETIMEPASS}
	touch ./initialized
	make -s md5

policy: addons
	cd ${OUTLINEDIR}; m4 ${OUTLINE} > ${TXT_POL}
	chmod 640 ${TXT_POL}

updatedb: policy
	${SHELL} ./twsetup.sh -u

update: 
	REPORT=`ls -t ${TWREPORT}/*.twr | /bin/sed -e '1q'`; \
	${TWBIN}/tripwire --update --cfgfile ${CONFIG_FILE} --twrfile "$$REPORT"
md5:
	logger -s "Tripwire: MD5 : " `/usr/bin/md5sum ${POLICY_FILE}`
	logger -s "Tripwire: MD5 : " `/usr/bin/md5sum ${CONFIG_FILE}`
	logger -s "Tripwire: MD5 : " `/usr/bin/md5sum ${TWBIN}/tripwire`


check: 
	if [ ! -f ./initialized ]; then \
		echo "Please setup Tripwire first." ;\
		echo "Try 'make initialize-interactive' to get started" ;\
		exit -1; \
	fi
	make -s md5
	-${TWBIN}/tripwire --check --cfgfile ${CONFIG_FILE}

html:
	./html-headers head
	make -s print-report 
	./html-headers tail 

recent-report:
	REPORT=`ls -t ${TWREPORT}/*.twr | /bin/sed -e '1q'`; \
	echo -n `basename $$REPORT` 

print-report:
	make -s md5
	REPORT=`ls -t ${TWREPORT}/*.twr | /bin/sed -e '1q'`; \
	${TWBIN}/twprint --print-report --cfgfile ${CONFIG_FILE} --twrfile "$$REPORT"
	
index-page:
	./tripwire-www-index ${WWWTWROOT} 
	
config:
	${SHELL} ./twcfg.sh
	chmod 640 ${TXT_CFG}
	
addons: 
	cd ${OUTLINEDIR}; for f in ${COMPONENTS}; do /bin/touch addon/$$f; done


	
