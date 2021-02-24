## Windows nodes setup

winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'

python -m pip install --upgrade pip
pip install "pywinrm>=0.3.0"
