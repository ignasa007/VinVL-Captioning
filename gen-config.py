import os
import yaml
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--tsv_dir', type=str, default='./scene_graph_benchmark/tools/mini_tsv/data')
parser.add_argument('--obj_det_map', type=str, default='./tools/mini_tsv/data/VG-SGG-dicts-vgoi6-clipped.json')
args = parser.parse_args()

yaml_dict = {
    'img': 'test.tsv',
    'label':  'test.label.tsv',
    'hw': 'test.hw.tsv',
    'linelist': 'test.linelist.tsv',
    'jsondict': args.obj_det_map
}

with open(os.path.join(args.tsv_dir, 'test.yaml'), 'w') as file:
    yaml.dump(yaml_dict, file)