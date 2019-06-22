FROM alpine:latest
RUN apk update
RUN apk upgrade

MAINTAINER LeeD hostmaster@dnsforge.com

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/xteve/bin
ENV PERL_MM_USE_DEFAULT=1
ENV TZ America/New_York
ENV XTEVE_HOME=/home/xteve
ENV XTEVE_BIN=/home/xteve/bin
ENV XTEVE_CONF=/home/xteve/conf
ENV GUIDE2GO_HOME=/home/xteve/guide2go
ENV GUIDE2GO_CONF=/home/xteve/guide2go/conf
ENV XTEVE_PORT=34400

# Dependencies
RUN apk add ca-certificates

# Add Bash shell
RUN apk add --no-cache bash

# Timezone (TZ):  Add the tzdata package and configure for EST timezone.
# This will override the default container time in UTC.
RUN apk add --no-cache tzdata

# Install Perl for Zap2it support
RUN apk add --no-cache perl-dev build-base

# Setup repos and deps & install Perl modules
RUN echo "@edge http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
RUN echo "@edgetesting http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk add --no-cache \
perl-html-parser@edge \
perl-http-cookies@edge \
perl-json@edge \
perl-lwp-protocol-https@edge \
perl-lwp-useragent-determined@edge

# Pull the required binaries for XTeve, Guide2go and Zap2xml from the repos.
ADD /bin/xteve_starter.pl /home/xteve/bin/xteve_starter.pl
ADD /bin/xteve /home/xteve/bin/xteve
ADD /bin/guide2go /home/xteve/bin/guide2go
ADD /bin/guide2go.json /home/xteve/guide2go/conf/guide2go.json
ADD /bin/zap2xml.pl /home/xteve/bin/zap2xml.pl

# Set binary executable permissions.
RUN chmod +x /home/xteve/bin/xteve_starter.pl
RUN chmod +x /home/xteve/bin/xteve
RUN chmod +x /home/xteve/bin/guide2go
RUN chmod +x /home/xteve/bin/zap2xml.pl

# Guide2go: Configure the guide2go crontab to grab EPG data for (7) days at 01:15 AM Sundays. 
RUN printf '# Run Schedules Direct crontab every Sunday at 1:15 AM EST\n15  1  *  *  0   $XTEVE_BIN/guide2go -config /home/xteve/guide2go/conf/guide2go.json\n' > /etc/crontabs/root
RUN printf '# Run Zap2XML crontab every Sunday at 1:15 AM EST\n15  1  *  *  0    /usr/bin/perl $XTEVE_BIN/zap2xml.pl -u username@domain.com -p ************ -o $XTEVE_CONF/data/guide2go.xml\n' >> /etc/crontabs/root

# Configure container mappings
VOLUME /home/xteve/conf
VOLUME /tmp/xteve

# Expose Ports for Access
EXPOSE 34400

# Run the XteVe startup script
ENTRYPOINT ["/home/xteve/bin/xteve_starter.pl"]
