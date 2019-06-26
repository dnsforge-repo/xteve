#!/usr/bin/perl
####################################################################
# ; Program: xteve_starter.pl
# ; Author : LeeD <hostmaster@dnsforge.com>
# ; Rev    : v1.0.1
# ; Date   : 6/25/2019
# ; Last Modification: 6/25/2019
# ;
# ; Desc   : ENTRYPOINT & init script for the xTeVe docker container.
# ;
# ;  Copyright (c) 2019, Dnsforge Internet Inc.
# ;  All rights reserved.
# ;
# ;
####################################################################

$XTEVE_USER = $ENV{'XTEVE_USER'};
$XTEVE_UID  = $ENV{'XTEVE_UID'};
$XTEVE_GID  = $ENV{'XTEVE_GID'};
$XTEVE_HOME = $ENV{'XTEVE_HOME'};
$XTEVE_TEMP = $ENV{'XTEVE_TEMP'};
$XTEVE_BIN  = $ENV{'XTEVE_BIN'};
$XTEVE_CONF = $ENV{'XTEVE_CONF'};
$XTEVE_PORT = $ENV{'XTEVE_PORT'};
$GUIDE2GO_HOME = $ENV{'GUIDE2GO_HOME'};
$GUIDE2GO_CONF = $ENV{'GUIDE2GO_CONF'};

if ( !-e "$XTEVE_HOME/.xteve.run") {
	print "Executing: Installation of Perl Modules...\n";
	system("/usr/bin/perl -MCPAN -e \"install JSON::XS\" >/var/log/xteve_start.log 2>&1");
	print "Executing: Add xTeVe user and group...\n";
	system("/usr/sbin/addgroup -g \"$XTEVE_GID\" \"$XTEVE_USER\"");
	sleep (1);
	system("/usr/sbin/adduser -H -h \"$XTEVE_HOME\" -s /bin/bash -D -u \"$XTEVE_UID\" -G \"$XTEVE_USER\" \"$XTEVE_USER\"");
	system("/bin/chown -R $XTEVE_USER:$XTEVE_USER $XTEVE_HOME");
	system("/bin/chown -R $XTEVE_USER:$XTEVE_USER $XTEVE_TEMP");
	system("/bin/touch $XTEVE_HOME/.xteve.run");
}
print "Executing: Starting xTeVe and crond services...\n";
print "Executing: Info: For support come see us in our Discord channel: https://discord.gg/eWYquha\n";
system("/usr/sbin/crond -l 2 -f -L /var/log/cron.log &");
system("/bin/su -c \"$XTEVE_BIN/xteve -config=$XTEVE_CONF -port=$XTEVE_PORT\" - $XTEVE_USER");

