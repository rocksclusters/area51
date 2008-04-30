#!/bin/sh
# $Log: twsetup.sh,v $
# Revision 1.1  2004/04/20 00:35:12  mjk
# more pmp'n tripwire
#
# Revision 1.6  2004/04/13 00:46:05  phil
# Added md5 sum printout of config policy and tripwire exec.
# Added example cron file
# Fixed file permissions
#
# Revision 1.5  2004/04/12 17:48:12  phil
#
# Added check and print-report targets for Makefile
#
# Revision 1.4  2004/04/12 15:28:27  phil
# Small syntax errors. Also Tripwire doesn't understand macro macros
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

#########################################################
#########################################################
##
## Tripwire Setup Script -- Assumes
## Binary files are already installed
## twcfg.txt is already made
## twpol.txt is already made 
## configuration parameters are in ./config.tw
## 
##
#########################################################
#########################################################
#########################################################
##
## Adapted from:
## Tripwire(R) 2.3 Open Source for LINUX install script
##
#########################################################
#########################################################

##=======================================================
## Setup
##=======================================================

## Read Configuration Parameters
. ./config.tw
TRIPWIRE=${TWBIN}/tripwire

USAGE="twsetup.sh [-n] [-f] [-i] [-s <sitepassphrase>] \
[-l <localpassphrase>]  \n \
-i initialize tripwire database \n \
-f force \n \
-n no prompting (site and local passphrase must be specified
-u recreate (update) the signed policy file contents twpol.txt"

INITDB=false
UPDATEONLY=false

##-------------------------------------------------------
## Parse the command line.
##-------------------------------------------------------

while getopts uinfs:l: opt
do	case "$opt" in
	n) PROMPT=false; xCLOBBER=true; INITDB=true ;;
	f) xCLOBBER=true ;;
	i) INITDB=true ;;
	u) UPDATEONLY=true; INITDB=true ;;
	l) TW_LOCAL_PASS=$OPTARG;;
	s) TW_SITE_PASS=$OPTARG;;
	*) echo -e "$USAGE"
		exit -1;;
	esac
done

##-------------------------------------------------------
## Print the sign-on banner here before the first
## non-error message is displayed.
##-------------------------------------------------------

cat << END_OF_TEXT

Tripwire Setup (Rocks) 

Adapted from: 
Installer program for:
Tripwire(R) 2.3 Open Source for LINUX

Copyright (C) 1998-2000 Tripwire (R) Security Systems, Inc.  Tripwire (R)
is a registered trademark of the Purdue Research Foundation and is
licensed exclusively to Tripwire (R) Security Systems, Inc.

END_OF_TEXT

##-------------------------------------------------------
## Value on command line, if present, overrides value in
## config file.  Value must either be "true" or "false"
## exactly; if it's not the former, make it the latter.
##-------------------------------------------------------

CLOBBER=${xCLOBBER-$CLOBBER}
if [ ! "$CLOBBER" = "true" ] ; then
	CLOBBER="false"
fi

##-------------------------------------------------------
## If no prompting was selected, both site and local
## passphrases must be specified on the command line.
##-------------------------------------------------------

if [ "$PROMPT" = "false" ] ; then
	if [ -z "$TW_SITE_PASS" ] || [ -z "$TW_LOCAL_PASS" ] ; then
		echo "Error: You must specify site and local passphrase" 1>&2
		echo "if no prompting is chosen." 1>&2
		echo -e "$USAGE"
		exit 1
    fi
fi

#%%%% ONLY DO THIS SECTION IF UPDATEONLY is FALSE
if [ "$UPDATEONLY"=false ]; then 

##-------------------------------------------------------
## If user has to enter a passphrase, give some
## advice about what is appropriate.
##-------------------------------------------------------


if [ -z "$TW_SITE_PASS" ] || [ -z "$TW_LOCAL_PASS" ]; then
cat << END_OF_TEXT

----------------------------------------------
The Tripwire site and local passphrases are used to
sign a variety of files, such as the configuration,
policy, and database files.

Passphrases should be at least 8 characters in length
and contain both letters and numbers.

See the Tripwire manual for more information.
END_OF_TEXT
fi

##=======================================================
## Generate keys.
##=======================================================

echo
echo "----------------------------------------------"
echo "Creating key files..."

##-------------------------------------------------------
## Site key file.
##-------------------------------------------------------

# If clobber is true, and prompting is off (unattended operation)
# and the key file already exists, remove it.  Otherwise twadmin
# will prompt with an "are you sure?" message.

if [ "$CLOBBER" = "true" ] && [ "$PROMPT" = "false" ] && [ -f "$SITE_KEY" ] ; then
        rm -f "$SITE_KEY"
fi

if [ -f "$SITE_KEY" ] && [ "$CLOBBER" = "false" ] ; then
	echo "The site key file \"$SITE_KEY\""
	echo 'exists and will not be overwritten.'
else
	cmdargs="--generate-keys --site-keyfile \"$SITE_KEY\""
	if [ -n "$TW_SITE_PASS" ] ; then
		cmdargs="$cmdargs --site-passphrase \"$TW_SITE_PASS\""
     	fi
	eval "\"$TWADMIN\" $cmdargs"
	if [ $? -ne 0 ] ; then
		echo "Error: site key generation failed"
		exit 1
        else chmod 640 "$SITE_KEY"
	logger -s  "Tripwire (twsetup.sh): Site Key Generated Successfully"
	fi
fi

##-------------------------------------------------------
## Local key file.
##-------------------------------------------------------

# If clobber is true, and prompting is off (unattended operation)
# and the key file already exists, remove it.  Otherwise twadmin
# will prompt with an "are you sure?" message.

if [ "$CLOBBER" = "true" ] && [ "$PROMPT" = "false" ] && [ -f "$LOCAL_KEY" ] ; then
        rm -f "$LOCAL_KEY"
fi

if [ -f "$LOCAL_KEY" ] && [ "$CLOBBER" = "false" ] ; then
	echo "The site key file \"$LOCAL_KEY\""
	echo 'exists and will not be overwritten.'
else
	cmdargs="--generate-keys --local-keyfile \"$LOCAL_KEY\""
	if [ -n "$TW_LOCAL_PASS" ] ; then
		cmdargs="$cmdargs --local-passphrase \"$TW_LOCAL_PASS\""
        fi
	eval "\"$TWADMIN\" $cmdargs"
	if [ $? -ne 0 ] ; then
		echo "Error: local key generation failed"
		exit 1
        else chmod 640 "$LOCAL_KEY"
	logger -s  "Tripwire (twsetup.sh): Local Key Generated Successfully"
	fi
fi

##=======================================================
## Create signed tripwire configuration file.
##=======================================================

echo
echo "----------------------------------------------"
echo "Creating signed configuration file..."

##-------------------------------------------------------
## If noclobber, then backup any existing config file.
##-------------------------------------------------------

if [ "$CLOBBER" = "false" ] && [ -s "$CONFIG_FILE" ] ; then
	backup="${CONFIG_FILE}.$$.bak"
	echo "Backing up $CONFIG_FILE"
	echo "        to $backup"
	`mv "$CONFIG_FILE" "$backup"`
	if [ $? -ne 0 ] ; then
		echo "Error: backup of configuration file failed."
		exit 1
	fi
fi

##-------------------------------------------------------
## Build command line.
##-------------------------------------------------------

cmdargs="--create-cfgfile"
cmdargs="$cmdargs --cfgfile \"$CONFIG_FILE\""
cmdargs="$cmdargs --site-keyfile \"$SITE_KEY\""
if [ -n "$TW_SITE_PASS" ] ; then
	cmdargs="$cmdargs --site-passphrase \"$TW_SITE_PASS\""
fi

##-------------------------------------------------------
## Sign the file.
##-------------------------------------------------------

eval "\"$TWADMIN\" $cmdargs \"$TXT_CFG\""
if [ $? -ne 0 ] ; then
	echo "Error: signing of configuration file failed."
	exit 1
fi

# Set the rights properly
chmod 640 "$CONFIG_FILE"
logger -s  "Tripwire (twsetup.sh): Configuration File Signed"

fi 
#%%%% END OF SECTION IF UPDATEONLY FALSE

##=======================================================
## Create signed tripwire policy file.
##=======================================================

echo
echo "----------------------------------------------"
echo "Creating signed policy file..."

##-------------------------------------------------------
## If noclobber, then backup any existing policy file.
##-------------------------------------------------------

if [ "$CLOBBER" = "false" ] && [ -s "$POLICY_FILE" ] ; then
	backup="${POLICY_FILE}.$$.bak"
	echo "Backing up $POLICY_FILE"
	echo "        to $backup"
	mv "$POLICY_FILE" "$backup"
	if [ $? -ne 0 ] ; then
		echo "Error: backup of policy file failed."
		exit 1
	fi
fi

##-------------------------------------------------------
## Build command line.
##-------------------------------------------------------

cmdargs="--create-polfile"
cmdargs="$cmdargs --cfgfile \"$CONFIG_FILE\""
cmdargs="$cmdargs --site-keyfile \"$SITE_KEY\""
if [ -n "$TW_SITE_PASS" ] ; then
	cmdargs="$cmdargs --site-passphrase \"$TW_SITE_PASS\""
fi

##-------------------------------------------------------
## Sign the file.
##-------------------------------------------------------

eval "\"$TWADMIN\" $cmdargs \"$TXT_POL\""
if [ $? -ne 0 ] ; then
	echo "Error: signing of policy file failed."
	exit 1
fi

# Set the proper rights on the newly signed policy file.
chmod 0640 "$POLICY_FILE"
logger -s  "Tripwire (twsetup.sh): Policy File Signed"

##-------------------------------------------------------
## Build command line to initialize DB.
##-------------------------------------------------------
if [ $INITDB = "true" ]; then
	cmdargs="--init"
	cmdargs="$cmdargs --cfgfile \"$CONFIG_FILE\""
	cmdargs="$cmdargs --site-keyfile \"$SITE_KEY\""
	if [ -n "$TW_SITE_PASS" ] ; then
		cmdargs="$cmdargs --local-passphrase \"$TW_LOCAL_PASS\""
	fi
	
##-------------------------------------------------------
## Sign the file.
##-------------------------------------------------------

	eval "\"$TRIPWIRE\" $cmdargs"
	if [ $? -ne 0 ] ; then
		echo "Error: Initializing Tripwire Database Failed"
		exit 1
	fi

	logger -s  "Tripwire (twsetup.sh): Tripwire Database Initialized"
fi
##=======================================================
## Clean-up.
##=======================================================

logger -s  "Tripwire (twsetup.sh): Completed Successfully"
cd "$START_DIR"

##############################################################################
# Copyright (C) 1998-2000 Tripwire (R) Security Systems, Inc.  Tripwire (R)
# is a registered trademark of the Purdue Research Foundation and is
# licensed exclusively to Tripwire (R) Security Systems, Inc.
##############################################################################
