#!/usr/bin/perl
############################################################################
# ; Program: guide2conf.pl
# ; Author : LeeD <hostmaster@dnsforge.com>
# ; Rev    : v1.0.2
# ; Date   : 5/9/2020
# ; Last Modification: 10/22/2020
# ;
# ; Desc   : Perl wrapper for dnsforge/xteve Guide2go & zap2it configuration.
# ;
# ;	Copyright (c) 2020, Dnsforge Internet Inc.
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
use Getopt::Long;
use Digest::SHA qw(sha1_hex);
use File::Path qw(mkpath);

$XTEVE_USER      = $ENV{'XTEVE_USER'};
$XTEVE_UID       = $ENV{'XTEVE_UID'};
$XTEVE_GID       = $ENV{'XTEVE_GID'};
$XTEVE_HOME      = $ENV{'XTEVE_HOME'};
$XTEVE_TEMP      = $ENV{'XTEVE_TEMP'};
$XTEVE_BIN       = $ENV{'XTEVE_BIN'};
$XTEVE_CACHE     = $ENV{'XTEVE_CACHE'};
$XTEVE_CONF      = $ENV{'XTEVE_CONF'};
$XTEVE_TEMPLATES = $ENV{'XTEVE_TEMPLATES'};
$XTEVE_PORT      = $ENV{'XTEVE_PORT'};
$XTEVE_LOG       = $ENV{'XTEVE_LOG'};
$XTEVE_BRANCH    = $ENV{'XTEVE_BRANCH'};
$XTEVE_DEBUG     = $ENV{'XTEVE_DEBUG'};
$XTEVE_API       = $ENV{'XTEVE_API'};
$XTEVE_VERSION   = $ENV{'XTEVE_VERSION'};
$GUIDE2GO_HOME   = $ENV{'GUIDE2GO_HOME'};
$GUIDE2GO_CONF   = $ENV{'GUIDE2GO_CONF'};

$PATH            = $ENV{'PATH'};
$TZ              = $ENV{'TZ'};
$CRONBIN         = "/usr/bin/crontab";
$CRONDIR         = "/etc/crontabs";
$XTEVE_CRONDIR   = "$XTEVE_CONF/cron";
$GUIDE2CONF_UID  = getpwuid($<);

GetOptions(
  'username=s' => \my $GUIDE2GO_UID,
  'password=s' => \my $GUIDE2GO_PASSWD,
  'name=s'     => \my $GUIDE2GO_CONFIG_NAME,
  'config=s'   => \my $GUIDE2GO_XMLTV_PATH,
  'max-days=i' => \my $GUIDE2CONF_MAX_DAYS,
  'refresh=i'  => \my $XTEVE_XMLTV_REFRESH,
) or &help and exit(1);

$GUIDE2GO_CONFIG_NAME=~ s/.yaml//;
$GUIDE2GO_CONFIG_NAME=~ s/.json//;
$GUIDE2GO_CONFIG_NAME=~ s/.xml//;


if (defined $GUIDE2GO_XMLTV_PATH) {
if (defined $GUIDE2GO_UID || $GUIDE2GO_PASSWD || $GUIDE2GO_CONFIG_NAME || $GUIDE2CONF_MAX_DAYS ) {
	&help and exit(1);
}
if (! -e $GUIDE2GO_XMLTV_PATH ) {
	&help and exit(1);
}
	&update_xmltv($GUIDE2GO_XMLTV_PATH);

if ( $XTEVE_XMLTV_REFRESH == 1 ) {
	if ( $XTEVE_API == 1 ) {
	&refresh_xmltv;
}
elsif ( $XTEVE_API == 0 ) {
	print "\nExecuting: Update xTeVe XMLTV and XEPG data...\n";
	print "You must enable xTeVe API in \'docker run\' to enable this feature.\n";

	}
  }
	exit(1);
}


if (defined $GUIDE2GO_XMLTV_PATH || $XTEVE_XMLTV_REFRESH) {
	&help and exit(1);
}
if ((!defined $GUIDE2GO_UID) || ($GUIDE2GO_UID eq '')) {
	&help and exit(1);
}
if ((!defined $GUIDE2GO_PASSWD) || ($GUIDE2GO_PASSWD eq '')) {
	&help and exit(1);
}
if ((!defined $GUIDE2GO_CONFIG_NAME) || ($GUIDE2GO_CONFIG_NAME eq '')) {
	&help and exit(1);
}
if ( $GUIDE2CONF_MAX_DAYS !~ /^(1[0-4]|[1-9])$/) {
	$GUIDE2CONF_MAX_DAYS = 7;
}
if ( $GUIDE2CONF_UID !~ /root/ ) {
	print "Sorry, guide2conf configure mode must run as the root user!!\n";
	&help and exit(1);
}
if ( $GUIDE2GO_UID =~ m/^[\w\.\-]+\@[\w\.\-]+\.\w{2,3}$/ ) {
	&create_zapconf($GUIDE2GO_UID,$GUIDE2GO_PASSWD,$GUIDE2GO_CONFIG_NAME);
	exit(1);
}

# Hash password (SHA1)
$GUIDE2GO_HPASSWD = &create_passwd($GUIDE2GO_PASSWD);

# Build config
my $GUIDE2GO_CONFIG_PATH = "$GUIDE2GO_CONF/" . "$GUIDE2GO_CONFIG_NAME" . ".yaml";

if ( -e "$GUIDE2GO_CONFIG_PATH") {
	print "This lineup already exists, Do you want to replace this lineup?\n";
	print "Enter Y|N: ";
	chomp(my $reader = <STDIN>);
if ($reader =~ /^[Y]?$/i) {
	unlink("$GUIDE2GO_CONFIG_PATH");
	unlink("$XTEVE_CONF/data/$GUIDE2GO_CONFIG_NAME.xml");
	unlink("$XTEVE_CACHE/guide2go/$GUIDE2GO_CONFIG_NAME.json");
	&create_conf($GUIDE2GO_UID,$GUIDE2GO_HPASSWD,$GUIDE2GO_CONFIG_PATH);
	system("$XTEVE_BIN/guide2go -configure $GUIDE2GO_CONFIG_PATH");
}
elsif ($reader =~ /^[N]$/i) {
	system("$XTEVE_BIN/guide2go -configure $GUIDE2GO_CONFIG_PATH");
	}
}
else {
	&create_conf($GUIDE2GO_UID,$GUIDE2GO_HPASSWD,$GUIDE2GO_CONFIG_PATH);
	system("$XTEVE_BIN/guide2go -configure $GUIDE2GO_CONFIG_PATH");
}

print "\n\n";
print "Do you want to download the guide data for this lineup?\n";
print "Enter Y|N|Q: ";
chomp(my $reader = <STDIN>);

if ($reader =~ /^[Y]?$/i) {
	system("/bin/chown -R $XTEVE_USER:$XTEVE_USER $XTEVE_CACHE/guide2go/$GUIDE2GO_CONFIG_NAME.json");
	&update_xmltv($GUIDE2GO_CONFIG_PATH);
} elsif ($reader =~ /^[N]$/i) {
	system("/bin/chown -R $XTEVE_USER:$XTEVE_USER $XTEVE_CACHE/guide2go/$GUIDE2GO_CONFIG_NAME.json");
	print "\nYou can manually download the guide data with the following command: \"guide2conf -config $GUIDE2GO_CONFIG_PATH\"\n";
	print "No Guide data was downloaded.\n";
} elsif ($reader =~ /^[Q]$/i) {
	print "Exiting..\n";
	exit(1);
} else {
	print "Sorry, You did not provide a valid option.\n";
	exit(1);
}

print "\n\n";
print "Do you want to add a crontab for this lineup?\n";
print "Enter Y|N|Q: ";
chomp( $reader = <STDIN>);
 
if ($reader =~ /^[Y]?$/i) {
	print "What time would you like to Schedule this cron?\n";
	print "Enter [00:00-23:59]: ";
	chomp(my $reader = <STDIN>);

if ( $reader !~ /^(\d+):(\d+)/) {
	$reader = "01:15";
	print "Invalid time format, setting cron for [$reader] ...\n";
}
	($CRON_INT_HOUR,$CRON_INT_MINS) = split /\:/,$reader;
	print "Adding Crontab for lineup [ $GUIDE2GO_CONFIG_PATH ] ...\n";
	&create_cron($GUIDE2GO_CONFIG_PATH,$CRON_INT_HOUR,$CRON_INT_MINS);
} elsif ($reader =~ /^[N]$/i) {
        print "\nOK, You can manually add a crontab for this lineup with the command \"crontab -e -u xteve\"\n";
        print "No cron was added.\n";
} elsif ($reader =~ /^[Q]$/i) {
        print "Exiting..\n";
        exit(1);
} else {
        print "Sorry, You did not provide a valid option.\n";
        exit(1);
}

##################################################################################################################
# ;
# ; guide2conf.pl: Program Subroutines
# ;
# ;
##################################################################################################################

sub create_passwd {
		my ( $l_STR_PASSWD ) = @_;
		$l_STR_PASSWD_HASH = sha1_hex($l_STR_PASSWD);

		return $l_STR_PASSWD_HASH;
}

sub create_conf {
my ( $l_STR_USERNAME,$l_STR_PASSWD,$l_GUIDE2GO_CONFIG ) = @_;
		open  G2GCONF, ">$l_GUIDE2GO_CONFIG" or die "Unable to open $l_GUIDE2GO_CONFIG $!";
		print G2GCONF "Account:\n";
		print G2GCONF "    Username: $l_STR_USERNAME\n";
		print G2GCONF "    Password: $l_STR_PASSWD\n";
		print G2GCONF "Files:\n";
		print G2GCONF "    Cache: $XTEVE_CACHE/guide2go/$GUIDE2GO_CONFIG_NAME.json\n";
		print G2GCONF "    XMLTV: $XTEVE_CONF/data/$GUIDE2GO_CONFIG_NAME.xml\n";
		print G2GCONF "Options:\n";
		print G2GCONF "    Poster Aspect: all\n";
		print G2GCONF "    Schedule Days: $GUIDE2CONF_MAX_DAYS\n";
		print G2GCONF "    Subtitle into Description: false\n";
		print G2GCONF "    Insert credits tag into XML file: true\n";
		print G2GCONF "Rating:\n";
		print G2GCONF "    Insert rating tag into XML file: true\n";
		print G2GCONF "    Maximum rating entries. 0 for all entries: 1\n";
		print G2GCONF "    Preferred countries. ISO 3166-1 alpha-3 country code. Leave empty for all systems: []\n";
		print G2GCONF "    Use country code as rating system: false\n";
		print G2GCONF "    Show download errors from Schedules Direct in the log: false\n";
		print G2GCONF "Station: []\n";
}

sub create_zapconf {
        my ( $l_STR_USERNAME,$l_STR_PASSWD,$l_GUIDE2GO_CONFIG ) = @_;

	$l_GUIDE2GO_CONFIG_NAME = "$l_GUIDE2GO_CONFIG";
	$l_GUIDE2GO_CONFIG = "$l_GUIDE2GO_CONFIG" . ".xml";

        print "\n\n";
        print "Do you want to download guide data for zap2it or TVGuide?\n";
        print "Enter Z|T|Q: ";
        chomp(my $reader = <STDIN>);

        if ($reader =~ /^[Z]?$/i) {
		$ZAPMODE = 0;
		mkpath("$XTEVE_CACHE/zap2xml/$l_GUIDE2GO_CONFIG_NAME");
		system("/bin/chown -R $XTEVE_USER:$XTEVE_USER $XTEVE_CACHE/zap2xml");
		system("/sbin/su-exec $XTEVE_USER $XTEVE_BIN/zap2xml.pl -u $l_STR_USERNAME -p $l_STR_PASSWD -U -c $XTEVE_CACHE/zap2xml/$l_GUIDE2GO_CONFIG_NAME -d $GUIDE2CONF_MAX_DAYS -o $XTEVE_CONF/data/$l_GUIDE2GO_CONFIG");
		} elsif ($reader =~ /^[T]$/i) {
		$ZAPMODE = 1;
		mkpath("$XTEVE_CACHE/tvguide/$l_GUIDE2GO_CONFIG_NAME");
		system("/bin/chown -R $XTEVE_USER:$XTEVE_USER $XTEVE_CACHE/tvguide");
		system("/sbin/su-exec $XTEVE_USER $XTEVE_BIN/zap2xml.pl -z -u $l_STR_USERNAME -p $l_STR_PASSWD -U -c $XTEVE_CACHE/tvguide/$l_GUIDE2GO_CONFIG_NAME -d $GUIDE2CONF_MAX_DAYS -o $XTEVE_CONF/data/$l_GUIDE2GO_CONFIG");
        } elsif ($reader =~ /^[Q]$/i) {
                print "Exiting..\n";
                exit(1);
        } else {
                print "Sorry, You did not provide a valid option.\n";
                exit(1);
        }


        print "\n\n";
        print "Do you want to add a crontab for this lineup?\n";
        print "Enter Y|N|Q: ";
        chomp( $reader = <STDIN>);
 
        if ($reader =~ /^[Y]?$/i) {
		print "What time would you like to Schedule this cron?\n";
		print "Enter [00:00-23:59]: ";
		chomp(my $reader = <STDIN>);

	if ( $reader !~ /^(\d+):(\d+)/) {
		$reader = "01:15";
		print "Invalid time format, setting cron for [$reader]\n";
	}
		($CRON_INT_HOUR,$CRON_INT_MINS) = split /\:/,$reader;
		print "Adding Crontab for lineup [ $XTEVE_CONF/data/$l_GUIDE2GO_CONFIG ] ...\n";
		&create_zapcron($l_STR_USERNAME,$l_STR_PASSWD,$l_GUIDE2GO_CONFIG_NAME,$ZAPMODE,$CRON_INT_HOUR,$CRON_INT_MINS);
        } elsif ($reader =~ /^[N]$/i) {
                print "\nYou can manually add a crontab for this lineup with the command \"crontab -e -u xteve\"\n";
                print "No cron was added.\n";
        } elsif ($reader =~ /^[Q]$/i) {
                print "Exiting..\n";
                exit(1);
        } else {
                print "Sorry, You did not provide a valid option.\n";
                exit(1);

        }
}

sub create_cron {
my ( $l_GUIDE2GO_CONFIG,$l_CRON_INT_HOUR,$l_CRON_INT_MINS ) = @_;

        open CRONFILE, "$CRONDIR/$XTEVE_USER";
        open T_CRONFILE, ">>$XTEVE_CRONDIR/$XTEVE_USER.tmp" or die "Unable to write $XTEVE_CRONDIR/$XTEVE_USER.tmp!: $!";

        while ( $reader = <CRONFILE> ) {
                chomp $reader;
                print T_CRONFILE "$reader\n"

        unless ($reader =~ /$l_GUIDE2GO_CONFIG/);

        if ($reader =~ /$l_GUIDE2GO_CONFIG/) {
                        $GUIDE2CONF_CRON_EXIST = 1;
                        print T_CRONFILE "$l_CRON_INT_MINS  $l_CRON_INT_HOUR  *  *  *   $XTEVE_BIN/guide2conf --config $l_GUIDE2GO_CONFIG\n";
        }

}
        print T_CRONFILE "# Run Schedules Direct crontab daily at $l_CRON_INT_HOUR:$l_CRON_INT_MINS EST\n$l_CRON_INT_MINS  $l_CRON_INT_HOUR  *  *  *   $XTEVE_BIN/guide2conf --config $l_GUIDE2GO_CONFIG\n" if $GUIDE2CONF_CRON_EXIST==0;
        close CRONFILE;
        close T_CRONFILE;
	system("$CRONBIN $XTEVE_CRONDIR/$XTEVE_USER.tmp -u $XTEVE_USER") if $GUIDE2CONF_UID =~ /root/;
	system("$CRONBIN $XTEVE_CRONDIR/$XTEVE_USER.tmp") if $GUIDE2CONF_UID =~ /xteve/;
	unlink("$XTEVE_CRONDIR/$XTEVE_USER.tmp");
}

sub create_zapcron {
my ( $l_STR_USERNAME,$l_STR_PASSWD,$l_GUIDE2GO_CONFIG,$ZAPMODE,$l_CRON_INT_HOUR,$l_CRON_INT_MINS ) = @_;

	$l_GUIDE2GO_CONFIG_NAME = "$l_GUIDE2GO_CONFIG";
        $l_GUIDE2GO_CONFIG = "$l_GUIDE2GO_CONFIG" . ".xml";

        open CRONFILE, "$CRONDIR/$XTEVE_USER";
        open T_CRONFILE, ">>$XTEVE_CRONDIR/$XTEVE_USER.tmp" or die "Unable to write $XTEVE_CRONDIR/$XTEVE_USER.tmp!: $!";

        while ( $reader = <CRONFILE> ) {
                chomp $reader;
                print T_CRONFILE "$reader\n"

        unless ($reader =~ /$l_GUIDE2GO_CONFIG/);

        if ($reader =~ /$l_GUIDE2GO_CONFIG/) {
                        $GUIDE2CONF_CRON_EXIST = 1;

	if ( $ZAPMODE == 0 ) {
		print T_CRONFILE "$l_CRON_INT_MINS  $l_CRON_INT_HOUR  *  *  * $XTEVE_BIN/zap2xml.pl -u $l_STR_USERNAME -p $l_STR_PASSWD -U -c $XTEVE_CACHE/zap2xml/$l_GUIDE2GO_CONFIG_NAME -d $GUIDE2CONF_MAX_DAYS -o $XTEVE_CONF/data/$l_GUIDE2GO_CONFIG\n";
	}
	elsif ($ZAPMODE ==1 ) {
		print T_CRONFILE "$l_CRON_INT_MINS  $l_CRON_INT_HOUR  *  *  * $XTEVE_BIN/zap2xml.pl -z -u $l_STR_USERNAME -p $l_STR_PASSWD -U -c $XTEVE_CACHE/tvguide/$l_GUIDE2GO_CONFIG_NAME -d $GUIDE2CONF_MAX_DAYS -o $XTEVE_CONF/data/$l_GUIDE2GO_CONFIG\n";
	}
     }

}

        if ( $ZAPMODE == 0 ) {
			print T_CRONFILE "# Run zap2it crontab daily at $l_CRON_INT_HOUR:$l_CRON_INT_MINS EST\n$l_CRON_INT_MINS  $l_CRON_INT_HOUR  *  *  * $XTEVE_BIN/zap2xml.pl -u $l_STR_USERNAME -p $l_STR_PASSWD -U -c $XTEVE_CACHE/zap2xml/$l_GUIDE2GO_CONFIG_NAME -d $GUIDE2CONF_MAX_DAYS -o $XTEVE_CONF/data/$l_GUIDE2GO_CONFIG\n" if $GUIDE2CONF_CRON_EXIST==0;
        }
        elsif ($ZAPMODE ==1 ) {
			print T_CRONFILE "# Run TVGuide crontab daily at $l_CRON_INT_HOUR:$l_CRON_INT_MINS EST\n$l_CRON_INT_MINS   $l_CRON_INT_HOUR  *  *  * $XTEVE_BIN/zap2xml.pl -z -u $l_STR_USERNAME -p $l_STR_PASSWD -U -c $XTEVE_CACHE/tvguide/$l_GUIDE2GO_CONFIG_NAME -d $GUIDE2CONF_MAX_DAYS -o $XTEVE_CONF/data/$l_GUIDE2GO_CONFIG\n" if $GUIDE2CONF_CRON_EXIST==0;
        }

        close CRONFILE;
        close T_CRONFILE;
	system("$CRONBIN $XTEVE_CRONDIR/$XTEVE_USER.tmp -u $XTEVE_USER") if $GUIDE2CONF_UID =~ /root/;
	system("$CRONBIN $XTEVE_CRONDIR/$XTEVE_USER.tmp") if $GUIDE2CONF_UID =~ /xteve/;
	unlink("$XTEVE_CRONDIR/$XTEVE_USER.tmp");
}

sub update_xmltv {
my ( $l_GUIDE2GO_CONFIG_PATH ) = @_;
	if ( $GUIDE2CONF_UID =~ /root/ ) {
		system("/sbin/su-exec $XTEVE_USER $XTEVE_BIN/guide2go -config $l_GUIDE2GO_CONFIG_PATH");
		system("/bin/chown -R $XTEVE_USER:$XTEVE_USER $l_GUIDE2GO_CONFIG_PATH");
	} else {
	system("$XTEVE_BIN/guide2go -config $l_GUIDE2GO_CONFIG_PATH");
	}
}

sub refresh_xmltv {
if ( $XTEVE_API ==1 ) {
	print "\nExecuting: Update xTeVe XMLTV and XEPG data...\n";
	system("/usr/bin/curl -X POST -H \"Content-Type: application/json\" -d \'{\"cmd\":\"update.xmltv\"}\' http://localhost:$XTEVE_PORT/api/");
	system("/usr/bin/curl -X POST -H \"Content-Type: application/json\" -d \'{\"cmd\":\"update.xepg\"}\' http://localhost:$XTEVE_PORT/api/");
	exit(1);
	}
}

sub help() {
	print "$0: XMLTV wrapper for Schedules Direct & zap2it.\n";

	print "\n\t\tVersion: Guide2conf $XTEVE_VERSION\n\n";

	print "\t\t$0 --username\t\t\t[ Provider username ]\n";
	print "\t\t$0 --password\t\t\t[ Provider password ]\n";
	print "\t\t$0 --name\t\t\t[ ie; USA-DIRECTV7, USA-ZAP7, USA-TVG7 .. ]\n";
	print "\t\t$0 --max-days\t\t\t[ Max days of guide data to download [1-14] ]\n";

	print "\t\t$0 --config\t\t\t[ Update XMLTV file ]\n";
	print "\t\t$0 --config --refresh=1\t\t[ Refresh xTeVe XMLTV & XEPG ]\n";
	print "\n";
	print "\t\tUsage:\n";
	print "\t\t$0 --username <username> --password <password> --max-days=7 --name USA-DIRECTV7\n";
	print "\t\t$0 --username <username\@domain.com> --password <password> --max-days=7 --name USA-ZAP7\n";
	print "\t\t$0 --username <username\@domain.com> --password <password> --max-days=7 --name USA-TVG7\n";
	print "\n";
	print "\t\t$0 --config $GUIDE2GO_CONF/guide2go.yaml\n";
	print "\t\t$0 --config $GUIDE2GO_CONF/guide2go.yaml --refresh=1\n";
	print " -h This help screen\n";
}
