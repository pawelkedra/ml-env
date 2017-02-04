from notebook.auth import passwd
import os

hash = passwd()

config_file = os.path.expanduser('~/.jupyter/jupyter_notebook_config.py')
with open(config_file, 'a') as f:
    f.write('\nc.NotebookApp.password = {!r}'.format(hash))
    f.write('\nc.NotebookApp.ip = \'*\'')