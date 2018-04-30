FROM fedora
LABEL maintainer="b00za@pm.me"

# Install the appropriate software
RUN dnf -y upgrade && \
    dnf -y install firefox \
                   xorg-x11-twm \
                   tigervnc-server && \
    dnf clean all

# Add non-privileged user.
RUN useradd --no-log-init -u 1024 user

# Add the xstartup file into the image and set the default password.
COPY ./xstartup /home/user/.vnc/
RUN chmod -v +x /home/user/.vnc/xstartup && \
    echo 123456 | vncpasswd -f > /home/user/.vnc/passwd && \
    chmod -v 600 /home/user/.vnc/passwd && \
    chown -R user:user /home/user/.vnc/

EXPOSE 5901

USER user
WORKDIR /home/user

CMD ["vncserver", "-fg" ]
