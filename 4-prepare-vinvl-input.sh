#!/bin/sh
set -e

vision_dir_name=${1:-"scene_graph_benchmark"}
tsv_dir=${2:-"./tools/mini_tsv/data"}
type=${3:-"test"}
hw_fn=${4:-"test.hw.tsv"}
output_dir=${5:-"../vinvl_input"}
sg_tsv=${6:-"./output/inference/vinvl_vg_x152c4/predictions.tsv"}

cp prepare-vinvl-input.py ${vision_dir_name}
cd ${vision_dir_name}
python prepare-vinvl-input.py \
    --tsv_dir ${tsv_dir} \
    --type ${type} \
    --hw_fn ${hw_fn} \
    --output_dir ${output_dir} \
    --sg_tsv ${sg_tsv} 
rm prepare-vinvl-input.py
cd ..