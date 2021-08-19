FROM frolvlad/alpine-glibc:alpine-3.8
MAINTAINER zzz<xxx@qq.com>
ADD jdk-8u201-linux-x64.tar.gz /usr/local/
ENV JAVA_HOME /usr/local/jdk1.8.0_201
ENV PATH  ${PATH}:${JAVA_HOME}/bin
ENV CLASSPATH ${JAVA_HOME}/lib/dt.jar:${JAVA_HOME}/lib/tools.jar
COPY --from=hengyunabc/arthas:latest /opt/arthas /opt/arthas
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo 'Asia/Shanghai' >/etc/timezone


#FROM openjdk:8-jdk-alpine
#MAINTAINER zzz<xxx@qq.com>
#COPY --from=hengyunabc/arthas:latest /opt/arthas /opt/arthas
#RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
#RUN echo 'Asia/Shanghai' >/etc/timezone
#RUN apk add --no-cache tini
#RUN apk add --update font-adobe-100dpi ttf-dejavu fontconfig