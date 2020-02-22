#! /bin/bash -e

# This script downloads all required container images for CaaSP for airgapped deployment.

# External and Internal RMT are setup

# Execute the following in External RMT (as root)
# -------------------------------------
# sudo SUSEConnect -d -p sle-module-containers/15.1/x86_64
# sudo zypper in helm-mirror skopeo

CAASP_IMAGE_LIST_URL=https://documentation.suse.com/external-tree/en-us/suse-caasp/4/skuba-cluster-images.txt
LOCAL_DIR=/tmp/suse
LOCAL_CHART_URL=https://charts.suse.lab
LOCAL_REGISTRY_URL=https://registry.suse.lab:5000

# download the list of all images used by CaaSP4
mkdir -p $LOCAL_DIR
curl  $CAASP_IMAGE_LIST_URL -o $LOCAL_DIR/caasp-image-list.txt
awk '{print $NF}' $LOCAL_DIR/caasp-image-list.txt | cut -c 7- | sed '/^$/d' | sort -u > $LOCAL_DIR/caasp-image-download.txt
# use skopeo to transfer the full list of CaaSP images to local directory
mkdir $LOCAL_DIR/skopeodata
while read img; do
  skopeo copy docker://$img dir:$LOCAL_DIR/skopeodata/$img
done < $LOCAL_DIR/caasp-image-download.txt

# download all suse helm charts and run skopeo sync to fetch all images used by these charts and store them locally.
helm-mirror --new-root-url $LOCAL_CHART_URL https://kubernetes-charts.suse.com $LOCAL_DIR/suse-charts
helm-mirror inspect-images $LOCAL_DIR/suse-charts --ignore-errors -o skopeo=$LOCAL_DIR/suse-charts-images.txt
skopeo sync --source-yaml $LOCAL_DIR/suse-charts-images.txt dir:$LOCAL_DIR/skopeodata


# transfer all data in LOCAL_DIR to from External RMT to internal RMT
rsync -avP $LOCAL_DIR root@INTERNAL-RMT:$LOCAL_DIR


# Execute the following in Internal RMT
# -------------------------------------
# sudo SUSEConnect -d -p sle-module-containers/15.1/x86_64
# sudo zypper in skopeo

# upload all images from skopeo to local docker registry
skopeo sync dir:$LOCAL_DIR/skopeodata/registry.suse.com docker://$LOCAL_REGISTRY_URL
while read img; do
  skopeo copy dir:$LOCAL_DIR/skopeodata/$img docker://$LOCAL_REGISTRY_URL
done < $LOCAL_DIR/caasp-image-download.txt


