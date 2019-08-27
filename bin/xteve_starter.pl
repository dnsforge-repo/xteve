#!/usr/bin/perl
############################################################################
# ; Program: xteve_starter.pl
# ; Author : LeeD <hostmaster@dnsforge.com>
# ; Rev    : v1.0.3
# ; Date   : 6/25/2019
# ; Last Modification: 8/24/2019
# ;
# ; Desc   : ENTRYPOINT & init script for the xTeVe docker container.
# ;
# ;	Copyright (c) 2019, Dnsforge Internet Inc.
# ;
# ;	This program is free software: you can redistribute it and/or modify
# ;	it under the terms of the GNU General Public License as published by
# ;	the Free Software Foundation, either version 3 of the License, or
# ;	(at your option) any later version.
# ;
# ;	This program is distributed in the hope that it will be useful,
# ;	but WITHOUT ANY WARRANTY; without even the implied warranty of
# ;	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# ;	GNU General Public License for more details.
# ;
# ;	You should have received a copy of the GNU General Public License
# ;	along with this program.  If not, see <http://www.gnu.org/licenses/>.
# ;
############################################################################

use File::Copy;

$XTEVE_USER      = $ENV{'XTEVE_USER'};
$XTEVE_UID       = $ENV{'XTEVE_UID'};
$XTEVE_GID       = $ENV{'XTEVE_GID'};
$XTEVE_HOME      = $ENV{'XTEVE_HOME'};
$XTEVE_TEMP      = $ENV{'XTEVE_TEMP'};
$XTEVE_BIN       = $ENV{'XTEVE_BIN'};
$XTEVE_CONF      = $ENV{'XTEVE_CONF'};
$XTEVE_TEMPLATES = $ENV{'XTEVE_TEMPLATES'};
$XTEVE_PORT      = $ENV{'XTEVE_PORT'};
$XTEVE_LOG       = $ENV{'XTEVE_LOG'};
$XTEVE_DEBUG     = $ENV{'XTEVE_DEBUG'};
$GUIDE2GO_HOME   = $ENV{'GUIDE2GO_HOME'};
$GUIDE2GO_CONF   = $ENV{'GUIDE2GO_CONF'};

$PATH            = $ENV{'PATH'};
$TZ              = $ENV{'TZ'};
$PROFILE         = "/etc/profile";
$CRONDIR         = "/etc/crontabs";
$XTEVE_CRONDIR   = "$XTEVE_CONF/cron";

if ( !-e "$XTEVE_HOME/.xteve.run") {
	print "Executing: Installation of Perl Modules...\n";
	system("/usr/bin/perl -MCPAN -e \"install JSON::XS\" >/var/log/xteve_start.log 2>&1");
	print "Executing: Add xTeVe user and group...\n";
	system("/usr/sbin/addgroup -g \"$XTEVE_GID\" \"$XTEVE_USER\"");
	sleep (1);
	system("/usr/sbin/adduser -H -h \"$XTEVE_HOME\" -s /bin/bash -D -u \"$XTEVE_UID\" -G \"$XTEVE_USER\" \"$XTEVE_USER\"");
	system("/bin/chown -R $XTEVE_USER:$XTEVE_USER $XTEVE_HOME");
	system("/bin/chown -R $XTEVE_USER:$XTEVE_USER $XTEVE_TEMP");
	system("/bin/chmod -R g+s $XTEVE_HOME");
	system("/bin/chmod -R g+s $XTEVE_TEMP");
	system("/bin/touch $XTEVE_HOME/.xteve.run");

if ( $XTEVE_DEBUG > 3 ) {
	$XTEVE_DEBUG = 3;
}

if ( $TZ !~ /America\/New_York/ ) {
	unlink("/etc/localtime","/etc/timezone");
	system("/bin/ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone");
}

copy ("$XTEVE_TEMPLATES/guide2go.json","$GUIDE2GO_CONF/guide2go.json");

if ( !-e "$XTEVE_CRONDIR" ) {
	mkdir $XTEVE_CRONDIR, 0755;
}
else {
	chmod 0755, $XTEVE_CRONDIR;
}

open CRONFILE, ">>$CRONDIR/root" or die "Unable to open $CRONFILE: $!";
	print CRONFILE "# Run xTeVe cron sync every 59 minutes\n*/59  *  *  *  *  /bin/cp $CRONDIR/$XTEVE_USER -Rf $XTEVE_CRONDIR/$XTEVE_USER\n";
close CRONFILE;

if ( !-e "$XTEVE_CRONDIR/$XTEVE_USER" ) {
open CRONFILE, ">>$XTEVE_CRONDIR/$XTEVE_USER" or die "Unable to open $CRONFILE: $!";
	print CRONFILE "#\n";
	print CRONFILE "# * * * * *\n";
	print CRONFILE "# | | | | |\n";
	print CRONFILE "# | | | | +- - - - day of week (0 - 6) (Sunday=0)\n";
	print CRONFILE "# | | | +- - - - - month (1 - 12)\n";
	print CRONFILE "# | | +- - - - - - day of month (1 - 31)\n";
	print CRONFILE "# | +- - - - - - - hour (0 - 23)\n";
	print CRONFILE "# +- - - - - - - - minute (0 - 59)\n";
	print CRONFILE "#\n";
	print CRONFILE "# Run Schedules Direct crontab every Sunday at 1:15 AM EST\n15  1  *  *  0   $XTEVE_BIN/guide2go -config $GUIDE2GO_CONF/guide2go.json\n";
	print CRONFILE "# Run Zap2XML crontab every Sunday at 1:15 AM EST\n15  1  *  *  0   /usr/bin/perl $XTEVE_BIN/zap2xml.pl -u username\@domain.com -p ******** -U -c $XTEVE_HOME/cache/zap2xml -o $XTEVE_CONF/data/zap2xml.xml\n";
	print CRONFILE "# Run TVGuide crontab every Sunday at 1:15 AM EST\n15  1  *  *  0   /usr/bin/perl $XTEVE_BIN/zap2xml.pl -z -u username\@domain.com -p ******** -U -c $XTEVE_HOME/cache/tvguide -o $XTEVE_CONF/data/tvguide.xml\n";
close CRONFILE;
	chmod 0600, "$XTEVE_CRONDIR/$XTEVE_USER";
	copy ("$XTEVE_CRONDIR/$XTEVE_USER","$CRONDIR/$XTEVE_USER");
}
else {
	chmod 0600, "$XTEVE_CRONDIR/$XTEVE_USER";
	print "Executing: Restoring Existing xTeVe crond Configuration...\n";
	copy ("$XTEVE_CRONDIR/$XTEVE_USER","$CRONDIR/$XTEVE_USER");
}

open PROFILE, ">>$PROFILE" or die "Unable to open $PROFILE: $!";
	print PROFILE "\n# Set custom \$USER Environment\n";
	print PROFILE "export PATH=$PATH\n";
	print PROFILE "export TZ=$TZ\n";
	print PROFILE "export XTEVE_BIN=$XTEVE_BIN\n";
	print PROFILE "export XTEVE_CONF=$XTEVE_CONF\n";
	print PROFILE "export XTEVE_HOME=$XTEVE_HOME\n";
	print PROFILE "export GUIDE2GO_HOME=$GUIDE2GO_HOME\n";
	print PROFILE "export GUIDE2GO_CONF=$GUIDE2GO_CONF\n";
close PROFILE;
}
print "Executing: Starting xTeVe and crond services...\n";
print "Executing: Info: For support come see us in our Discord channel: https://discord.gg/eWYquha\n";
print "Executing: Info: xTeVe DEBUG mode [$XTEVE_DEBUG] initilized..\n" if $XTEVE_DEBUG > 0;
print "[xTeVe]: Log File: $XTEVE_LOG\n";
system("/bin/chown -R $XTEVE_USER:$XTEVE_USER $XTEVE_HOME");
system("/bin/chown -R $XTEVE_USER:$XTEVE_USER $XTEVE_TEMP");
system("/usr/sbin/crond -l 2 -f -L /var/log/cron.log &");
exec("/sbin/su-exec $XTEVE_USER $XTEVE_BIN/xteve -config=$XTEVE_CONF -port=$XTEVE_PORT -debug=$XTEVE_DEBUG >> $XTEVE_LOG 2>&1");

