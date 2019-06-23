<h1 id="xTeVe><a href="https://xteve.de/">xTeVe v2.0 / Guide2go / Zap2XML</a></h1>
<a href="https://xteve.de/"><p><b>https://www.xteve.de</b?</p></a>


Image Maintainer:  <b>LeeD </b>\<hostmaster@dnsforge.com\></a>

For support come visit us at our xTeVe Discord channel!:
https://discord.gg/eWYquha

<h2 id="descrption">Description</h2>

xTeVe is a M3U proxy server for Plex, Emby and any client and provider which supports the .TS and .M3U8 streaming formats.

xTeVe emulates a SiliconDust HDHomeRun OTA tuner which allows it to expose IPTV style channels to software which would not normally support it.  This image includes the following packages:

                    *    xTeVe v2.0 x86 64 bit
                    *    Guide2go x86 64 bit  (a Schedules Direct XMLTV grabber)
                    *    Zap2XML (a Perl based Zap2it XMLTV grabber)
                    *    CROND
                    *    Perl

The recommended settings are listed in the docker run command listed below:

<p><b> docker run -it -d --name=xteve --network=host --restart=always -e TZ=America/New_York -p 127.0.0.1:34400:34400 -v ~/xteve:/home/xteve/conf -v ~/xteve_tmp:/tmp/xteve dnsforge/xteve:latest </b></p>

<h2 id="parameters">Parameters</h2>

<table class="paleBlueRows">
<thead>
<tr>
<th>Parameter</th>
<th>Description</th>
</tr>
</thead>
<tfoot>
<tr>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>
</tfoot>
<tbody>
<tr>
<td>--name</td>
<td>Name of container image</td>
</tr>
<tr>
<td>--network</td>
<td>Set network type</td>
</tr>
<tr>
<td>--restart</td>
<td>Enable auto restart for this container</td>
</tr>
<tr>
<td>-p 38400</td>
<td>Default container port mapping (ie; 127.0.0.1:38400:38400)</td>
</tr>
<tr>
<td>-e XTEVE_PORT=8080</td>
<td>Set custom xTeVe Port</td>
</tr>
<tr>
<td>-e TZ=America/Los_Angeles</td>
<td>Set custom Locale</td>
</tr>
<tr>
<td>-v</td>
<td>Set container mappings (ie; ~xteve:/home/xteve/conf/)</td>
</tr>
<tr>
<td>dnsforge/xteve:latest</td>
<td>Docker image</td>
</tr>
<tr>
<td>-e GUIDE2GO_CONFIG=/path/to/config</td>
<td>Not yet Implemented</td>
</tbody>
</table>

<p><b>Linux:</b></p>

mkdir -p ~/xteve

mkdir -p ~/xteve_tmp

docker run -it -d --name=xteve --network=host --restart=always -e TZ=America/New_York -p 127.0.0.1:34400:34400 -v ~/xteve:/home/xteve/conf -v ~/xteve_tmp:/tmp/xteve dnsforge/xteve:latest


<p><b>Synology:</b></p>


mkdir /volume1/docker/xteve

mkdir /volume1/docker/xteve_tmp

docker run -it -d --name=xteve --network=host --restart=always -e TZ=America/New_York -p 127.0.0.1:34400:34400 -v /volume1/docker/xteve:/home/xteve/conf -v /volume1/docker/xteve_tmp:/tmp/xteve dnsforge/xteve:latest

<h2 id="Guide2go Configuration">Guide2go Configuration</h2>

A sample guide2go configuration file has been provided in /home/xteve/guide2go/guide2go.json which can be configured using the
following command:

<p><b>guide2go -configure $GUIDE2GO_CONF/guide2go.json</b></p>

<h2 id="Guide2go Crontab">Guide2go Crontab</h2>

Additionally a sample crontab has been created to run the guide2go configuration on a weekly basis. To modify the crontab run 'crontab -e"
from a command prompt terminal inside the container.  You will need to add the guide2go XML file in XMLTV->Add in xTeVe.

<p><b>guide2go -config $GUIDE2GO_CONF/guide2go.json</p\b></p>


<h2 id="Zap2XML Crontab">Zap2XML Crontab</h2>

Also a sample crontab has been created to run the Zap2XML configuration on a weekly basis. To modify the crontab run 'crontab -e"
from a command prompt terminal inside the container. You will need to add the Zap2XML XML file in XMLTV->Add in xTeVe.

<p><b>/usr/bin/perl $XTEVE_BIN/zap2xml.pl -u username -p password -o $XTEVE_CONF/data/zap2xml.xml</p\b></p>


Enjoy!









