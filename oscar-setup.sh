#!/bin/sh
set -e

oscar_dir_name=${1:-"Oscar"}
model_save_dir=${2:-"./pretrained_model"}
model_task=${3:-"image_captioning"}
model_name=${4:-"coco_captioning_base_scst"}

if [ -d apex ]; then
    read -p "apex already exists. Do you wish to overwrite it? [y/n]: " overwrite_dir
    if [ ${overwrite_dir} == 'y' ] || [ ${overwrite_dir} == 'Y' ]; then
        rm -rf apex
    fi
fi
if [ ! -d apex ]; then
    git clone --recursive git@github.com:microsoft/Oscar.git apex
fi

if [ -d ${oscar_dir_name} ]; then
    read -p "${oscar_dir_name} already exists. Do you wish to overwrite it? [y/n]: " overwrite_dir
    if [ ${overwrite_dir} == 'y' ] || [ ${overwrite_dir} == 'Y' ]; then
        rm -rf ${oscar_dir_name}
    fi
fi
if [ ! -d ${oscar_dir_name} ]; then
    git clone --recursive git@github.com:microsoft/Oscar.git ${oscar_dir_name}
fi

cd ${oscar_dir_name}/coco_caption
if [ ! -f stanford-corenlp-full-2015-12-09.zip ]; then
    ./get_stanford_models.sh
fi
cd ..
python setup.py build develop

sed -i "s+return yaml.load(fp.*+return yaml.load(fp, Loader=yaml.FullLoader)+g" oscar/utils/misc.py

model_zoo="https://biglmdiag.blob.core.windows.net/vinvl/model_ckpts"
azcopy="/home/jasraj/apps/azcopy_linux_amd64_10.15.0/azcopy"

mkdir -p ${model_save_dir}/${model_task}
cd ${model_save_dir}/${model_task}
if [ ! -d ${model_name} ]; then
    ${azcopy} copy --recursive ${model_zoo}/${model_task}/${model_name} .
fi

cd ../..