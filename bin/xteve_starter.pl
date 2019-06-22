#!/usr/bin/perl
$XTEVE_HOME = $ENV{'XTEVE_HOME'};
$XTEVE_BIN  = $ENV{'XTEVE_BIN'};
$XTEVE_CONF = $ENV{'XTEVE_CONF'};
$XTEVE_PORT = $ENV{'XTEVE_PORT'};

if ( !-e "$XTEVE_HOME/.xteve.run") {
	print "Executing: Installation of Perl Modules...\n";
	system("/usr/bin/perl -MCPAN -e \"install JSON::XS\" >/var/log/xteve_start.log 2>&1");
	system("/bin/touch $XTEVE_HOME/.xteve.run");
}
print "Executing: Starting xTeVe and crond services...\n";
print "Executing: Info: For support come see us in our Discord channel: https://discord.gg/eWYquha\n";
system("/usr/sbin/crond -l 2 -f -L /var/log/cron.log &");
system("$XTEVE_BIN/xteve -config=$XTEVE_CONF -port=$XTEVE_PORT");
