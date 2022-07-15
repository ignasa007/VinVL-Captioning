#!/bin/sh
set -e

vision_dir_name=${1:-"scene_graph_benchmark"}
config_file=${2:-"sgg_configs/vgattr/vinvl_x152c4.yaml"}
model_path=${3:-"pretrained_model/vinvl_vg_x152c4.pth"}
output_dir=${4-"output"}
data_dir=${5:-"tools/mini_tsv/data"}
label_map_file=${6-"tools/mini_tsv/data/VG-SGG-dicts-vgoi6-clipped.json"}

cd ${vision_dir_name}
python tools/test_sg_net.py \
    --config-file ${config_file} \
    TEST.IMS_PER_BATCH 1 \
    MODEL.WEIGHT ${model_path} \
    MODEL.ROI_HEADS.NMS_FILTER 1 \
    MODEL.ROI_HEADS.SCORE_THRESH 0.2 \
    TEST.OUTPUT_FEATURE True \
    OUTPUT_DIR ${output_dir} \
    DATA_DIR ${data_dir} \
    TEST.IGNORE_BOX_REGRESSION True \
    MODEL.ATTRIBUTE_ON True \
    DATASETS.LABELMAP_FILE ${label_map_file}
cd ..