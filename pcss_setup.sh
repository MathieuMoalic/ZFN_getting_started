#!/bin/sh
wget https://repo.anaconda.com/miniconda/Miniconda3-py39_4.10.3-Linux-x86_64.sh
chmod +x Miniconda3-py39_4.10.3-Linux-x86_64.sh
./Miniconda3-py39_4.10.3-Linux-x86_64.sh -b
rm .bashrc
mkdir -p ~/grant_398/scratch/$USER
ln -s ~/grant_398/scratch/$USER ~/jobs
