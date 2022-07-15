#!/bin/sh
set -e

vision_dir_name=${1:-"scene_graph_benchmark"}
model_save_dir=${2:-"./pretrained_model"}
model_name=${3:-"vinvl_vg_x152c4.pth"}
config_dir=${4:-"./tools/mini_tsv/data"}
obj_detection_mapping=${5:-"VG-SGG-dicts-vgoi6-clipped.json"}

if [ -d ${vision_dir_name} ]; then
    read -p "${vision_dir_name} already exists. Do you wish to overwrite it? [y/n]: " overwrite_dir
    if [ ${overwrite_dir} == 'y' ] || [ ${overwrite_dir} == 'Y' ]; then
        rm -rf ${vision_dir_name}
    fi
fi
if [ ! -d ${vision_dir_name} ]; then
    git clone https://github.com/microsoft/scene_graph_benchmark.git ${vision_dir_name}
fi
cd ${vision_dir_name}

vinvl_model_zoo="https://penzhanwu2.blob.core.windows.net/sgg/sgg_benchmark/vinvl_model_zoo"
azcopy="/home/jasraj/apps/azcopy_linux_amd64_10.15.0/azcopy"

mkdir -p ${model_save_dir}
if [ ! -f ${model_save_dir}/${model_name} ]; then
    ${azcopy} copy ${vinvl_model_zoo}/${model_name} ${model_save_dir}/
fi

mkdir -p ${config_dir}
if [ ! -f ${config_dir}/${obj_detection_mapping} ]; then
    ${azcopy} copy ${vinvl_model_zoo}/${obj_detection_mapping} ${config_dir}/
fi

python ./setup.py build develop
cd ..