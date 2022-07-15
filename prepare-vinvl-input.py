import base64
import os
import yaml
import json
import ast
import argparse

import numpy as np
import pandas as pd

parser = argparse.ArgumentParser()
parser.add_argument('--tsv_dir', type=str, default='./tools/mini_tsv/data')
parser.add_argument('--type', type=str, default='test')
parser.add_argument('--hw_fn', type=str, default='test.hw.tsv')
parser.add_argument('--output_dir', type=str, default='../vinvl_input')
parser.add_argument('--sg_tsv', type=str, default='./output/inference/vinvl_vg_x152c4/predictions.tsv')
args = parser.parse_args()

# Load height and width of every image
hw_df = pd.read_csv(
    os.path.join(args.tsv_dir, args.hw_fn), 
    sep='\t', 
    header=None, 
    converters={1:ast.literal_eval}, 
    index_col=0
)

# Directory of out predictions.tsv (bbox_id, class, conf, feature, rect)
df = pd.read_csv(args.sg_tsv,sep='\t',header = None,converters={1:json.loads})
df[1] = df[1].apply(lambda x: x['objects'])

# Help functions
def generate_additional_features(rect,h,w):
    mask = np.array([w,h,w,h],dtype=np.float32)
    rect = np.clip(rect/mask,0,1)
    res = np.hstack((rect,[rect[3]-rect[1], rect[2]-rect[0]]))
    return res.astype(np.float32)

def generate_features(x):
    # image_id, object data list of dictionary, number of detected objects
    idx, data,num_boxes = x[0],x[1],len(x[1])
    # read image height, width, and initialize array of features
    h,w,features_arr = hw_df.loc[idx,1][0]['height'],hw_df.loc[idx,1][0]['width'],[]

    # for every detected object in img
    for i in range(num_boxes):
        # read image region feature vector
        features = np.frombuffer(base64.b64decode(data[i]['feature']),np.float32)
        # add 6 additional dimensions
        pos_feat = generate_additional_features(data[i]['rect'],h,w)
        # stack feature vector with 6 additional dimensions
        x = np.hstack((features,pos_feat))
        features_arr.append(x.astype(np.float32))
        
    features = np.vstack(tuple(features_arr))
    features = base64.b64encode(features).decode('utf-8')
    return {'features':features, 'num_boxes':num_boxes}

def generate_labels(x):
    data = x[1]
    res = [{'class':el['class'].capitalize(),'conf':el['conf'], 'rect': el['rect']} for el in data] 
    return res

# Generate features from predictions.tsv
df['feature'] = df.apply(generate_features,axis=1)
df['feature'] = df['feature'].apply(json.dumps)

df['label'] = df.apply(generate_labels,axis=1)
df['label'] = df['label'].apply(json.dumps)

# Generate train/test/val.label.tsv and train/test/val.feature.tsv
LABEL_FILE = os.path.join(args.output_dir, args.type+'.label.tsv')
FEATURE_FILE = os.path.join(args.output_dir, args.type+'.feature.tsv')
if not os.path.exists(args.output_dir):
    os.makedirs(args.output_dir)
    print(f'path to {args.output_dir} created')

from maskrcnn_benchmark.structures.tsv_file_ops import tsv_writer
tsv_writer(df[[0,'label']].values.tolist(),LABEL_FILE)
tsv_writer(df[[0,'feature']].values.tolist(),FEATURE_FILE)

yaml_dict = {
    'label': args.type+'.label.tsv',
    'feature': args.type+'.feature.tsv'
}
with open(os.path.join(args.output_dir, args.type+'.yaml'), 'w') as file:
    yaml.dump(yaml_dict, file)