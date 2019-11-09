#!/bin/bash
compgen -u| xargs -I '{}' sudo crontab -l -u '{}'
