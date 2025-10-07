#!/bin/bash

homectl create arouene \
    --shell=/bin/zsh \
    --member-of=wheel \
    --timezone=Europe/Paris \
    --language=en_US.UTF-8 \
    --no-ask-password

# Disable service after first boot. We do not rely on the ConditionFirstBoot
# because it will not be set on the first boot of the qcow2 image
systemctl disable firstboot
