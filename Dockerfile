FROM alpine:latest
RUN apk update
RUN apk upgrade
RUN apk add --no-cache ca-certificates

MAINTAINER LeeD hostmaster@dnsforge.com

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/xteve/bin
ENV PERL_MM_USE_DEFAULT=1
ENV XTEVE_USER=xteve
ENV XTEVE_UID=31337
ENV XTEVE_GID=31337
ENV XTEVE_HOME=/home/xteve
ENV XTEVE_TEMP=/tmp/xteve
ENV XTEVE_BIN=/home/xteve/bin
ENV XTEVE_CONF=/home/xteve/conf
ENV XTEVE_PORT=34400
ENV XTEVE_LOG=/var/log/xteve.log
ENV GUIDE2GO_HOME=/home/xteve/guide2go
ENV GUIDE2GO_CONF=/home/xteve/guide2go/conf

# Set working directory
WORKDIR $XTEVE_HOME

# Add Bash shell & dependancies
RUN apk add --no-cache bash busybox-suid su-exec

# Timezone (TZ):  Add the tzdata package and configure for EST timezone.
# This will override the default container time in UTC.
RUN apk update && apk add --no-cache tzdata
ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install Perl for Zap2it support
RUN apk add --no-cache \
perl-dev \
build-base \
perl-html-parser \
perl-http-cookies \
perl-json \
perl-lwp-protocol-https \
perl-lwp-useragent-determined

# Pull the required binaries for xTeVe, Guide2go and Zap2XML from the repos.
ADD /bin/xteve_starter.pl $XTEVE_BIN/xteve_starter.pl
#ADD https://xteve.de:9443/download/?os=linux&arch=amd64&name=xteve&beta=false $XTEVE_BIN/xteve
ADD /bin/xteve $XTEVE_BIN/xteve
ADD /bin/guide2go $XTEVE_BIN/guide2go
ADD /bin/guide2go.json $GUIDE2GO_CONF/guide2go.json
ADD /bin/zap2xml.pl $XTEVE_BIN/zap2xml.pl

# Set binary executable permissions.
RUN chmod +x $XTEVE_BIN/xteve_starter.pl
RUN chmod +x $XTEVE_BIN/xteve
RUN chmod +x $XTEVE_BIN/guide2go
RUN chmod +rx $XTEVE_BIN/zap2xml.pl

# Guide2go: Configure the guide2go crontab to grab EPG data for (7) days at 01:15 AM Sundays. 
RUN printf '# Run Schedules Direct crontab every Sunday at 1:15 AM EST\n15  1  *  *  0   $XTEVE_BIN/guide2go -config $GUIDE2GO_CONF/guide2go.json\n' > /etc/crontabs/xteve
RUN printf '# Run Zap2XML crontab every Sunday at 1:15 AM EST\n15  1  *  *  0   /usr/bin/perl $XTEVE_BIN/zap2xml.pl -u username@domain.com -p ******** -U -o $XTEVE_CONF/data/zap2xml.xml\n' >> /etc/crontabs/xteve

# Configure container mappings
VOLUME $XTEVE_CONF
VOLUME $XTEVE_TEMP

# Set default container port 
EXPOSE 34400

# Run the xTeVe init script
ENTRYPOINT ["/home/xteve/bin/xteve_starter.pl"]
