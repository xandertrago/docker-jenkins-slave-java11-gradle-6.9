FROM ubuntu:18.04
MAINTAINER Szczepan Kozioł <szczepankoziol@gmail.com>

# Make sure the package repository is up to date.
RUN apt-get update && apt-get -qy full-upgrade && apt-get -qy install \
    git \
    wget \
    unzip \
    apt-transport-https \
    build-essential \
# Install a basic SSH server
    openssh-server \
# Install lastest JDK
    default-jdk && \
# Install Gradle 6.3
    mkdir /opt/gradle && \
    wget https://downloads.gradle-dn.com/distributions/gradle-6.9-bin.zip && \
    unzip -d /opt/gradle gradle-6.9-bin.zip && \
    export PATH=$PATH:/opt/gradle/gradle-6.9/bin && \
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd && \
# Cleanup old packages
    apt-get -qy autoremove && \
# Add user jenkins to the image
    adduser --quiet jenkins && \
# Set password for the jenkins user (you may want to alter this).
    echo "jenkins:jenkins" | chpasswd
    
# Copy authorized keys
#COPY .ssh/authorized_keys /home/jenkins/.ssh/authorized_keys
#RUN chown -R jenkins:jenkins /home/jenkins/.m2/
    #chown -R jenkins:jenkins /home/jenkins/.ssh/

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
