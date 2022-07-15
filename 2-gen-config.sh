#!/bin/sh
set -e

vision_dir_name=${1:-"scene_graph_benchmark"}
files_suffix=${2:-"test"}

cd ${vision_dir_name}
cat ./tools/mini_tsv/tsv_demo.py | head -n56 > ./tools/mini_tsv/new_tsv_demo.py
sed -i "s+tools/mini_tsv/data/train+tools/mini_tsv/data/${files_suffix}+g" ./tools/mini_tsv/new_tsv_demo.py
python ./tools/mini_tsv/new_tsv_demo.py
sed -i "/#.*/d; s+ TEST:.*+ TEST: (\"test.yaml\",)+g; s+OUTPUT_DIR:.*+OUTPUT_DIR: \"output/\"+g" ./sgg_configs/vgattr/vinvl_x152c4.yaml
cd .. 

python gen-config.py 