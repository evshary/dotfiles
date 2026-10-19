FROM ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive TERM=xterm-256color \
    RUSTUP_TERM_PROGRESS_WHEN=always
RUN apt-get update \
    && apt-get install -y sudo ca-certificates ncurses-term \
    && useradd --create-home --shell /bin/bash tester \
    && echo 'tester ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/tester \
    && chmod 0440 /etc/sudoers.d/tester

COPY --chown=tester:tester . /home/tester/dotfiles
USER tester
ENV HOME=/home/tester
WORKDIR /home/tester/dotfiles
ARG INSTALL_FULL=1
RUN if [ "$INSTALL_FULL" = "1" ]; then \
        ./ubuntu2604/install_full.sh; \
    else \
        ./ubuntu2604/install.sh; \
    fi
RUN INSTALL_FULL="$INSTALL_FULL" ./ubuntu2604/verify.sh
CMD ["/bin/bash"]
