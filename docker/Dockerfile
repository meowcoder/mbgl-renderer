FROM ubuntu:focal-20200606

WORKDIR /app

# create local directory for tiles to prevent startup errors
# if this is not defined via a bind point to host
RUN mkdir /app/tiles

COPY package*.json /app/

RUN set -eu \
 && apt-get update \
 && apt-get -y install curl ca-certificates gnupg \
 && curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - \
 && echo "deb https://deb.nodesource.com/node_10.x focal main" \
    > /etc/apt/sources.list.d/node-10.list \
 && apt-get update \
 && apt-get -y install \
    nodejs \
    upx-ucl \
    binutils \
    libgl1-mesa-dri \
    libegl1-mesa \
    libgles2-mesa \
 && npm ci --only=production \
 # upx: 40M -> 15M, strip: 158M -> 10M
 && upx -qq /usr/bin/node \
 && strip /app/node_modules/@mapbox/mapbox-gl-native/lib/node-v64/mbgl.node \
 && apt-get purge -y binutils upx-ucl gnupg \
 && apt-get autoremove -y --purge \
 && apt-get clean \
 && rm -rf \
    /app/node_modules/@mapbox/tiletype/test \
    /app/node_modules/restify/benchmark \
    /app/node_modules/sharp/vendor/include \
    /usr/include/node \
    /usr/lib/python2.7 \
    /usr/lib/node_modules/npm/docs \
    /usr/share/info/* \
    /usr/share/doc/* \
    /root/.cache \
    /root/.npm \
    /var/cache/* \
    /var/lib/apt/lists/* \
 # replace hardlinks with symlinks for docker-slim
 && find /usr/lib/x86_64-linux-gnu \
   -samefile "/usr/lib/x86_64-linux-gnu/dri/i915_dri.so" \
   -exec ln -vsf "/usr/lib/x86_64-linux-gnu/dri/i915_dri.so" '{}' \; \
 && find /usr/lib/x86_64-linux-gnu \
   -samefile "/usr/lib/x86_64-linux-gnu/dri/swrast_dri.so" \
   -exec ln -vsf "/usr/lib/x86_64-linux-gnu/dri/swrast_dri.so" '{}' \;


EXPOSE 80
ENV EGL_PLATFORM surfaceless

# Copy just the compiled code
COPY ./dist/* /app/dist/

COPY ./docker/entrypoint.sh /root
RUN chmod +x /root/entrypoint.sh
ENTRYPOINT [ "/root/entrypoint.sh" ]
HEALTHCHECK CMD curl --fail http://localhost:80 || exit 1

