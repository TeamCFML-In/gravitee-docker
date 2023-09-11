#!/bin/sh
#
# Copyright (C) 2015-2022 The Gravitee team (http://gravitee.io)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# generate configs
if [ -f "/usr/share/nginx/html/constants.json" ]; then
    envsubst < /usr/share/nginx/html/constants.json > /usr/share/nginx/html/constants.json.tmp
    mv /usr/share/nginx/html/constants.json.tmp /usr/share/nginx/html/constants.json
fi

if [ -f "/usr/share/nginx/html/assets/config.json" ]; then
    envsubst < /usr/share/nginx/html/assets/config.json > /usr/share/nginx/html/assets/config.json.tmp
    mv /usr/share/nginx/html/assets/config.json.tmp /usr/share/nginx/html/assets/config.json
fi

envsubst '\$HTTP_PORT \$HTTPS_PORT \$SERVER_NAME \$CONSOLE_BASE_HREF \$ALLOWED_FRAME_ANCESTOR_URLS \$PORTAL_BASE_HREF \$MGMT_BASE_HREF' < /etc/nginx/conf.d/default.conf > /etc/nginx/conf.d/default.conf.tmp
if [ "$FRAME_PROTECTION_ENABLED" = "false" ]; then
   grep -v "Content-Security-Policy" /etc/nginx/conf.d/default.conf.tmp > /etc/nginx/conf.d/defaultWithoutProtection.conf.tmp
   mv /etc/nginx/conf.d/defaultWithoutProtection.conf.tmp /etc/nginx/conf.d/default.conf.tmp
fi
mv /etc/nginx/conf.d/default.conf.tmp /etc/nginx/conf.d/default.conf

# start nginx foreground
exec /usr/sbin/nginx -g 'daemon off;'
