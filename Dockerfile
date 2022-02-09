# Copyright 2017, 2019 the Velero contributors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM --platform=$BUILDPLATFORM golang:1.17-buster AS build
COPY . /go/src/velero-plugin-for-gcp
WORKDIR /go/src/velero-plugin-for-gcp
RUN CGO_ENABLED=0 GOOS=linux go build -v -o /go/bin/velero-plugin-for-gcp ./velero-plugin-for-gcp

FROM --platform=$BUILDPLATFORM busybox:1.34.1 AS busybox

FROM --platform=$BUILDPLATFORM gcr.io/distroless/base-debian10:nonroot
COPY --from=build /go/bin/velero-plugin-for-gcp /plugins/
COPY --from=busybox /bin/cp /bin/cp
USER nonroot:nonroot
ENTRYPOINT ["cp", "/plugins/velero-plugin-for-gcp", "/target/."]
