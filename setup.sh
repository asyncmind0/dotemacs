#!/bin/sh
git submodule update --init --recursive
pip install --user --editable "git+https://github.com/jagguli/ropemacs.git#egg=ropemacs"
cd modules.d/Pymacs
make
python setup.py install --user

