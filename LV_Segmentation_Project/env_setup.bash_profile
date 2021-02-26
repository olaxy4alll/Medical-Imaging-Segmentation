#python path
export PYTHONPATH=${PYTHONPATH}:/usr/local/bin
# directory for virtualenvs created using virtualenvwrapper
export WORKON_HOME=/Users/mohammadalimirzaei/.virtualenvs
# name the python directory
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
# ensure all new environments are isolated from the site-packages directory
export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'
# makes pip detect an active virtualenv and install to it
export VIRTUALENVWRAPPER_VIRTUALENV=/usr/local/bin/virtualenv
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3 
source /usr/local/bin/virtualenvwrapper.sh