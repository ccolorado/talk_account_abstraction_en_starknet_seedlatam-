FROM python:3.9-slim
RUN sudo apt-get update
# TODO: install nvm
RUN sudo apt-get install -y sudo git vim tmux tree gcc npm yarn curl fzf libgmp3-dev libgmp3-dev
RUN sudo apt-get install -y nodejs inotify-tools entr less tree
# Missing packages: python-pipenv openssh diff-so-fancy

RUN git clone https://github.com/ccolorado/configfiles.git ~/configfiles
RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1
RUN git clone https://github.com/starkware-libs/cairo ~/cairo_lang

RUN echo "full" > ~/.custom_system_type
RUN echo ". ~/.asdf/asdf.sh" >> ~/.bashrc
RUN echo ". ~/.asdf/completions/asdf.bash" >> ~/.bashrc
RUN bash ~/configfiles/bin/binder
# Installing scarb
# RUN asdf plugin add scarb && asdf install scarb 0.7.0 && asdf global scarb 0.7.0
# Installing rustup
# RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# Installing starkli
# RUN curl https://get.starkli.sh | sh
# Installing starkli
# RUN starkliup

WORKDIR /app
