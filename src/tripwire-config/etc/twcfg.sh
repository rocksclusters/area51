#!/bin/sh
# $Log: twcfg.sh,v $
# Revision 1.1  2004/04/20 00:35:12  mjk
# more pmp'n tripwire
#
# Revision 1.1  2004/04/09 06:50:05  phil
# Closer to a configuration setup for tripwire
#
##=======================================================
## Generate tripwire configuration file.
##=======================================================

echo
echo "----------------------------------------------"
echo "Generating Tripwire configuration file..."

# Read configuration Parameters
. ./config.tw

cat << END_OF_TEXT > "$TXT_CFG"
ROOT          =$TWOPTROOT
POLFILE       =$POLICY_FILE
DBFILE        =$TWDB/\$(HOSTNAME).twd
REPORTFILE    =$TWREPORT/\$(HOSTNAME)-\$(DATE).twr
SITEKEYFILE   =$SITE_KEY
LOCALKEYFILE  =$LOCAL_KEY
EDITOR        =$TWEDITOR
LATEPROMPTING =${TWLATEPROMPTING:-false}
LOOSEDIRECTORYCHECKING =${TWLOOSEDIRCHK:-false}
MAILNOVIOLATIONS =${TWMAILNOVIOLATIONS:-true}
EMAILREPORTLEVEL =${TWEMAILREPORTLEVEL:-3}
REPORTLEVEL   =${TWREPORTLEVEL:-3}
MAILMETHOD    =${TWMAILMETHOD:-SENDMAIL}
SYSLOGREPORTING =${TWSYSLOG:=true}
END_OF_TEXT

if [ "$TWMAILMETHOD" = "SMTP" ] ; then
cat << SMTP_TEXT >> "$TXT_CFG"
SMTPHOST      =${TWSMTPHOST:-mail.domain.com}
SMTPPORT      =${TWSMTPPORT:-"25"}
SMTP_TEXT
else
cat << SENDMAIL_TEXT >> "$TXT_CFG"
MAILPROGRAM   =$TWMAILPROGRAM
SENDMAIL_TEXT
fi

if [ ! -s "$TXT_CFG" ] ; then
	echo "Error: unable to create $TXT_CFG"
	exit 1
fi

chmod 640 "$TXT_CFG"
logger -s "Tripwire (twcfg.sh): $TXT_CFG Generated Successfully"
