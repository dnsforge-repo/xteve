<br>

<h1 id="xTeVe><a href="https://xteve.de/">xTeVe Docker Edition</a></h1>
<a href="https://github.com/xteve-project/xTeVe"><p><b>Recommended by xTeVe</b></p></a>
<tr>

Image Maintainer:  <b>LeeD </b>\<hostmaster@dnsforge.com\></a>

<br>

<h2>Buy us a Frosty Beverage!!</h2><a href="https://www.paypal.com/donate/?hosted_button_id=9YFANKSM3FW58"><img src="https://raw.githubusercontent.com/xteve-repo/images/master/dnsforge_QR.png"></a>

<p><b>If you enjoy our docker image and would like to buy us a beer, well.. we're not going to stop you!! <a href="https://www.paypal.com/donate/?hosted_button_id=9YFANKSM3FW58"><b>click here</b></b></p>

<br>

<br>

For support click <b>below</b> to visit our xTeVe <b>Discord</b> server:

<a href="https://discord.gg/Up4ZsV6"><img alt="Discord" src="https://img.shields.io/discord/465222357754314767?color=%2367E3FB&style=for-the-badge"></a>

<br>

<br>

<h2 id="description">Description</h2>

xTeVe is a M3U proxy server for Plex, Emby and any client and provider which supports the .TS and .M3U8 (HLS) streaming formats.

<p>xTeVe emulates a SiliconDust HDHomeRun OTA tuner, which allows it to expose IPTV style channels to software, which would not normally support it.  This Docker image includes the following packages and features:

<br>

<br>

<h2 >Docker 'run' Configuration & container mappings</h2>

The recommended <b>default</b> container settings are listed in the docker run command listed below:


<p><b> docker run -it -d --name=xteve --network=host --restart=always -v $PATH/xteve:/home/xteve/conf dnsforge/xteve:latest</b></p>


<br>

<br>

<h2 >Isolated (bridge) mode</h2>
<p>To isolate the container in bridge mode use 'docker run' as follows.  **Only use bridge mode if you fully understand its use**  Generally for most users we recommend host mode. 

<br>

In bridge mode the docker container will assign it's own dockernet ip address (usually in the 172.17.x network).</p>

<p><b>docker run -it -d --name=xteve -p 34400:34400 --restart=always -v $PATH/xteve:/home/xteve/conf dnsforge/xteve:latest</b></p>

<br>

<br>

<h2 >Docker 'run' Configuration with Guide2go</h2>

If you plan to use guide2go simply, include the GUIDE2GO Volume to be able to access your files directly from the host.  Existing users can also copy their existing <b>.yaml</b> configuration files in to this location.

<p><b>docker run -it -d --name=xteve --network=host --restart=always -v $PATH/xteve:/home/xteve/conf -v $PATH/guide2go:/home/xteve/guide2go/conf dnsforge/xteve:latest</b></p>

<br>

The default Locale is configured as: <b>America/New_York (EST) </b> and the Web UI can be accessed at <b>http://\$HOST_IP:34400/web/ </b>

<br>

<br>

<h2 >Custom Configuration</h2>

You can  customize the container installation by passing options with <b> 'docker run'</b> or by selecting the "Environment" tab in your docker GUI.  Below are a few examples of customizing the container configuration.  Please see the "Parameters" table below for a list of all supported options.

Custom Locale (Timezone):

<p><b> docker run -it -d --name=xteve --network=host --restart=always -e TZ=Europe/London -v $PATH/xteve:/home/xteve/conf dnsforge/xteve:latest</b></p>

Custom Port and Locale:
<p><b> docker run -it -d --name=xteve --network=host --restart=always -e TZ=Europe/London -e XTEVE_PORT=8080 -v $PATH/xteve:/home/xteve/conf dnsforge/xteve:latest</b></p>

<br>

<h2>Default container paths</h2>

This container is configured with the following default environmental variables,  for reference, here are the paths of the xTeVe installation:


<table class="paleBlueRows">
<thead>
<tr>
<th>Variable</th>
<th>Path</th>
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
<td>$XTEVE_HOME</td>
<td>/home/xteve</td>
</tr>
<tr>
<td>$XTEVE_BIN</td>
<td>/home/xteve/bin</td>
</tr>
<tr>
<td>$XTEVE_CONF</td>
<td>/home/xteve/conf</td>
</tr>
<tr>
<td>$XTEVE_CONF/data</td>
<td>/home/xteve/conf/data</td>
</tr>
<tr>
<td>$XTEVE_CONF/backup</td>
<td>/home/xteve/conf/backup</td>
</tr>
<tr>
<td>$GUIDE2GO_HOME</td>
<td>/home/xteve/guide2go</td>
</tr>
<tr>
<td>$GUIDE2GO_CONF</td>
<td>/home/xteve/guide2go/conf</td>
</tr>
</tbody>
</table>

<br>

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
<td>Set network type [ host | bridge ]</td>
</tr>
<tr>
<td>--restart</td>
<td>Enable auto restart for this container</td>
</tr>
<tr>
<td>-e TZ=Europe/London</td>
<td>Set custom Locale</td>
</tr>
<tr>
<td>-p 34400</td>
<td>Default container port mapping [ 127.0.0.1:34400:34400 ]</td>
</tr>
<tr>
<td>-e XTEVE_PORT=8080</td>
<td>Set custom xTeVe Port</td>
</tr>
<tr>
<td>-e XTEVE_BRANCH=beta</td>
<td>Set xTeVe git branch [ master|beta ] Default: master
</tr>
<tr>
<td>-e XTEVE_DEBUG=1</td>
<td>Set xTeVe debug level [ 0-3 ] Default: 0=OFF</td>
</tr>
<tr>
<td>-e XTEVE_API=0</td>
<td>Enable/Disable API [ beta ] Default: 1=ON</td>
</tr>
<tr>
<td>-e GUIDE2GO_SERVER_HOST=10.0.0.1</td>
<td>Guide2go Token server [ host | ip ] </td>
</tr>
<tr>
<td>-e GUIDE2GO_SERVER_PORT=31337</td>
<td>Guide2go Token port [ port ] </td>
</tr>
<tr>
<td>-v</td>
<td>Set volume mapping [ -v ~xteve:/home/xteve/conf ]</td>
</tr>
<tr>
<td>dnsforge/xteve:latest</td>
<td>Latest Docker image</td>
</tbody>
</table>

<br>
<br>

<h2 >Linux Shell (Bash)</h2>
To connect to the xTeVe container to run local commands, use the following docker command to start a bash shell:
<p><b>docker exec -it < container_name >  /bin/bash</b></p>

You will automatically be logged in as the root user.  Type <b>"su - xteve"</b> to change to the xTeve user.

<br>
<br>

<h2 >Linux</h2>

Run the container with the 'docker run' command with any desired parameters from the table above.

<p><b>mkdir -p $PATH/xteve</b>

<p><b>docker run -it -d --name=xteve --network=host --restart=always  -v $PATH/xteve:/home/xteve/conf dnsforge/xteve:latest</b>

<br>
<br>

<p>Linux with Guide2go:</p>

<p><b>mkdir -p $PATH/xteve</b>
<p><b>mkdir -p $PATH/guide2go</b>

<p><b>docker run -it -d --name=xteve --network=host --restart=always  -v $PATH/xteve:/home/xteve/conf -v $PATH/guide2go:/home/xteve/guide2go/conf dnsforge/xteve:latest</b>

<br>
<br>

<h2 >Synology</h2>

Run the container with the 'docker run' command with any desired parameters from the table above.  Alternatively you can launch this image in the
Synology Docker GUI which is equivalent to 'docker run'.

<p><b>mkdir /volume1/docker/xteve</b>

<p><b>docker run -it -d --name=xteve --network=host --restart=always  -v /volume1/docker/xteve:/home/xteve/conf dnsforge/xteve:latest</b>

<br>
<br>

<p>Synology with Guide2go:</p>

<p><b>mkdir /volume1/docker/xteve</b>
<p><b>mkdir /volume1/docker/guide2go</b>

<p><b>docker run -it -d --name=xteve --network=host --restart=always  -v /volume1/docker/xteve:/home/xteve/conf  -v /volume1/docker/guide2go:/home/xteve/guide2go/conf dnsforge/xteve:latest</b>

<br>
<br>

<h2 id="Guide2go Configuration">Guide2go Configuration</h2>

<p>To use this feature you will need to purchase a <a href="http://www.schedulesdirect.org">Schedules Direct</a> subscription for $25.00/yr. You can configure your guide2go lineup using the following command:</p

<p><b>guide2conf</b> <b>--username</b> < username > <b> --password</b> < password ><b> --max-days</b> < max_days [1-14] > <b>--name</b> < lineup_name ></p>

<p>When prompted configure your lineup and channels using these options:</p>

<br>
<br>

<p><b>Select "2. Add lineup" from the menu</b></p>

Choose Country

Choose Postcode

Choose Provider

<br>
<br>

<p><b>Select "4. Manage channels" from the menu</b></p>

Choose "ALL" for your selected lineup.  

<p> <b> NOTE: We do NOT recommend adding more than (1) Lineup to a single configuration file.  If you want to run multiple
lineups, follow the directions below for "Additional Guide2go Lineups".</b></p>

<p>Choose "0" to exit and then follow the prompts to run the initial lineup and automatically add a cron job to automate the guide2go data download..</p>

<br>

<br>


<h2 id="Guide2go Crontab">Guide2go Crontab</h2>

You can now use the new <b>guide2conf</b> command line utility to automatically create a daily cron job.  Alternatively you can manually modify the crontab by running  <b>'crontab -e -u xteve'</b> from a command prompt inside the container.  You will need to add the guide2go XMLTV file located in <b>$XTEVE_CONF/data/guide2go.xml</b>  to  <b>xTeVe->XMLTV</b> in the xTeVe UI once it has been generated on the first run.

<br>

<p><b>Manual crontab configuration:</b></p>

<p><b># Run Schedules Direct crontab daily at 1:15 AM EST</b></p>                                                                                              
<p><b>15  1  *  *  *   /home/xteve/bin/guide2conf --config /home/xteve/guide2go/conf/< lineup_name >.yaml</b></p>

<br>

<br>

<h2 id="Additional Guide2go Lineups">Additional Guide2go Lineups</h2>

You can have up to (4) separate guide2go lineups with one SD subscription.  If you choose to create additional lineups we recommend you create separate guide2go
configuration  (YAML) files for each one.  We also recommend staggering the lineup cron times, as Schedules Direct does limit how many concurrent connections you can have to their API at any one time. Follow the following steps to create additional lineups and crons.

<br>

<p><b>guide2conf</b> <b>--username</b> < username > <b>--password</b> < password ><b> --max-days</b> < max_days [1-14] > <b>--name</b> < lineup_name ></p>

<br>
<br>

<p><b>Select "2. Add lineup" from the menu</b></p>

Choose Country

Choose Postcode

Choose Provider

<br>
<br>

<p><b>Select "4. Manage channels" from the menu</b></p>

Choose "NONE" for your original lineup

Choose "ALL" for your new lineup

Choose "0" to exit

<br>

The YAML file will now be written to <b>$GUIDE2GO_CONF/< lineup_name >.yaml</b>

<br>
<br>

<p>Optionally automatically create a daily cron by following the prompts, otherwise you can manually add a cron later with the following command:</p>

<p><b>crontab -e -u xteve</b></p>

<br>

<p><b>Manual crontab configuration:</b></p>

<p><b># Run Schedules Direct crontab daily at 1:15 AM EST</b></p>                                                                                              
<p><b>15  1  *  *  *   /home/xteve/bin/guide2conf --config /home/xteve/guide2go/conf/< lineup_name >.yaml</b></p>

<br>

<br>

<h2 id="zap2XML Crontab">zap2XML Crontab</h2>

To create an automated lineup and cron to run the zap2XML configuration on a daily basis, you will need to sign up for a free <a href="https://tvlistings.zap2it.com">Zap2it</a> account.  You can then create the crontab using either the <b>guide2conf</b> utility or manually create the crontab by running the  <b>'crontab -e -u xteve'</b> command from a command prompt inside the container. You will need to add the zap2XML XMLTV file located in <b>$XTEVE_CONF/data/< lineup_name >.xml</b>  to <b>xTeVe->XMLTV</b> once it has been generated on the first run.

<br>

<p><b>guide2conf</b> <b>--username</b> < username@domain.com > <b>--password</b> < password ><b> --max-days</b> < max_days[1-14] ><b> --name</b> < lineup_name > </p>

<br>

<p><b>Manual crontab configuration:</b></p>

<p><b># Run zap2it crontab daily at 1:15 AM EST </b></p>
<p><b>15  1  *  *  * /home/xteve/bin/zap2xml.pl  -u username@domain.com -p  ******** -U -c $XTEVE_CACHE/zap2xml/< lineup_name> -o
$XTEVE_CONF/data/< lineup_name >.xml</b></p>

<br>
<p><b>NOTE: Support for the tvguide.com service is no longer available as the service was discontinued. </b></p>
<br>

Enjoy!

