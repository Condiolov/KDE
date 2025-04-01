#!/bin/bash
#------------------------------------------------------------------------------
# Script : 0_instalador_scripts.sh
# Versão : 1.0 (/home/thiago/Documents/_Projetos/KDE/UTEIS/Scripts/0_instalador_scripts.sh)
# Autor  : Thiago Condé - @condiolov @diversalizando
# Data   : 31-03-2025 19:15:01
# Info   : Instala todos os scripts!
# Requis.: bash 0_instalador_scripts.sh
#------------------------------------------------------------------------------

grep -i 'alias criar=' $HOME/.bashrc 1>/dev/null || echo "alias criar='$PWD/criar.sh'" >>$HOME/.bashrc
