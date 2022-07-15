conda create --name sg_benchmark python=3.7 -y
conda activate sg_benchmark

conda install ipython h5py nltk joblib jupyter pandas scipy opencv
pip install ninja yacs>=0.1.8 cython matplotlib tqdm numpy>=1.19.5
pip install torch==1.7.1+cu110 torchvision==0.8.2+cu110 -f https://download.pytorch.org/whl/torch_stable.html
pip install timm einops pycocotools cityscapesscripts
pip install -U PyYAML

bash ./vision-setup.sh