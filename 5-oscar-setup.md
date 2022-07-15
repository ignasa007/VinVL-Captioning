conda create --name oscar python=3.7
conda activate oscar

pip install torch==1.7.1+cu110 torchvision==0.8.2+cu110 -f https://download.pytorch.org/whl/torch_stable.html

bash ./oscar-setup.sh

pip install -r Oscar/requirements.txt