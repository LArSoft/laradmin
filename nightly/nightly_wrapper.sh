#!/bin/bash
#
# nightly_wrapper.sh <arguments for nightly.sh>
#
# This script performs a kinit for the principal set by $PRINCIPAL using
# the keytab specified by $KEYTAB, then calls the script specified by 
# $NIGHTLY_SCRIPT located in $NIGHTLY_DIR with all command line arguments.
#
# See nightly.sh for the list of allowed arguments.
#
# The value of PRINCIPAL is set to a /cron principal for the 
# node on which nightly.sh is run. This can either be created by
# running krconinit, in which case it will be the /cron principal
# for the user who ran kcroninit, or a special /cron principal,
# which is created via a General Request to the service desk,
# followed by running /usr/krb5/config/make-cron-keytab. (See
# Knowledge Base article KR0010954 in Service-Now (keywords
# "special principal") for details on requesting and using 
# special cron principals.)
#
# If using kcroninit to create a user's cron keytab file:
# o  Log in as user 'larsoft' to the node where nightly.sh will run
# o  kcroninit
#    Respond "y" to the prompt:
#      "What is your kerberos principal (default = <your username>@FNAL.GOV):"
# o  Add the user's cron principal to the ~larsoft/.k5login file. The
#    principal will be of the form <user>/cron/<node>.fnal.gov@FNAL.GOV.
#
# If using make-cron-keytab to create a cron keytab file from
# a special principal:
# o  Log in as user 'larsoft' to the node where nightly.sh will run
# o  /usr/krb5/bin/make-cron-keytab
#    Respond to the password prompt with the single-use password provided
#    by the service desk
# o  Add the special principal to the ~larsoft/.k5login file
#
# To delete the keytab file
# o  Log in as user 'larsoft' to the node where nightly.sh is running.
# o  rm /var/adm/krb5/`kcron -f`
#
# NOTES:
# 1) The special principal solution will *not* work if the 'larsoft' 
#    account needs to submit grid jobs due to security policies
#    that require a personal grid certificate for grid jobs.
# 2) The special principal solution in principle makes this
#    wrapper script unnecessary, since the kcron command can
#    be used to create the necessary kerberos ticket automatically
#    from the keytab file.
#
# Erica Snider
# 1-Feb-2014

PRINCIPAL=larsoft/cron/`hostname`@FNAL.GOV
KEYTAB=/var/adm/krb5/`/usr/krb5/bin/kcron -f`

/usr/krb5/bin/kinit -kt ${KEYTAB} ${PRINCIPAL}
/usr/krb5/bin/klist

~larsoft/code/laradmin/nightly/nightly.sh $*
(( $? )) && exit 1
exit 0
