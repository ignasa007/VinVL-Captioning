#!/bin/sh
set -e

oscar_dir_name=${1:-"Oscar"}
data_dir=${2:-"../vinvl_input"}
config_yaml=${3:-"test.yaml"}
model_path=${4-"./pretrained_model/image_captioning/coco_captioning_base_scst/checkpoint-15-66405"}

cd ${oscar_dir_name}
python oscar/run_captioning.py \
    --do_test \
    --data_dir ${data_dir} \
    --test_yaml ${config_yaml} \
    --per_gpu_eval_batch_size 2 \
    --max_gen_length 70 \
    --eval_model_dir ${model_path} 
cd ..