FROM ubuntu:20.04

ENV DEBIAN_FRONTEND="noninteractive"
ENV FORCE_UNSAFE_CONFIGURE=1

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install bc cpio file gcc g++ git make python rsync unzip wget -y  && \
    apt-get clean autoclean && \
    apt-get autoremove -y

RUN git clone https://github.com/MiyooCFW/buildroot.git /buildroot

WORKDIR /buildroot

RUN git checkout c77595adbd849f475096d46d7ab7fbbcb215e2a5

RUN echo BR2_PACKAGE_HOST_GDB=y >> /buildroot/.config
RUN echo BR2_PACKAGE_HOST_GDB_TUI=y >> /buildroot/.config
RUN echo BR2_PACKAGE_HOST_GDB_PYTHON=n >> /buildroot/.config
RUN echo BR2_PACKAGE_HOST_GDB_SIM=n >> /buildroot/.config
RUN echo BR2_GDB_VERSION_8_1=n >> /buildroot/.config
RUN echo BR2_GDB_VERSION_8_2=y >> /buildroot/.config
RUN echo BR2_GDB_VERSION_8_3=n >> /buildroot/.config
RUN echo BR2_GDB_VERSION=\"8.2.1\" >> /buildroot/.config

RUN make sdk


FROM ubuntu:20.04

COPY --from=0 /buildroot/output/host /opt/bittboy-toolchain

ENV PATH="/opt/bittboy-toolchain/bin:${PATH}"

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y cmake make ninja-build  && \
    apt-get clean autoclean && \
    apt-get autoremove -y
