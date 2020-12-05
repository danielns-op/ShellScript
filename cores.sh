#!/usr/bin/env bash
#
# cores.sh
#
# Autor: Daniel Noronha
# Email: danielnoronha.sh@gmail.com
#  Data: 02/12/2020
#
# Programa para mostrar os códigos e tipos de cores no shell.
# Os código das cores também funcionam para Python, quando 
# executado no terminal.
#

# ---- FUNÇÕES ----#
function CoresComFundo(){
	clear
	echo -e "\n"
	for letras in $(seq 0 7);
	do
		for estilo in "" "1;" "4;" "7;";
		do
			for fundo in $(seq 0 7);
			do
				echo -e "\033[${estilo}3${letras};4${fundo}m\c"
				echo -e " ${estilo:-  }3${letras};4${fundo}m \c"
				echo -e "\033[m\c"
			done
			echo ""
		done
	done
	exit 0
}

function CoresSemFundo(){
	clear
	echo -e "\n"
	for letras in $(seq 0 7);
	do
		for estilo in "" "1;" "4;" "7;";
		do
			echo -e "\033[${estilo}3${letras}m\c"
			echo -e " ${estilo:-  }3${letras}m \c"
			echo -e "\033[m\c"
		done
		echo ""
	done
	exit 0
}

function Ajuda(){
	clear
	echo """
	O programa exibe as cores em dois formatos:
		1 - Cores com fundo colorido
		2 - Cores com fundo padrão do terminal
	Utilização:
		$ ${0} [opção]
		-h, --help  - Mostra uma ajuda de como utilizar o programa.
		-cf - Mostra os códigos de cores com fundo.
		-c  - Mostra os códigos de cores sem fundo.

	O programa também pode ser utilizado sem parametros, dessa forma
	ele irá mostrar um menu de opções.
	"""
}

function Menu(){
	clear
	read -n1 -p """
	Escolha uma opção:
		[ 1 ] - Cores com fundo
		[ 2 ] - Cores sem fundo
		[ 3 ] - Ajuda
		Opção: """ opcao
	case $opcao in
		1) CoresComFundo ;;
		2) CoresSemFundo ;;
		3) Ajuda         ;;
	esac
}

# ---- EXECUÇÃO ----#
[[ -z $1 ]] && Menu

clear
case $1 in
	 -h | --help) Ajuda;;
	-cf) CoresComFundo ;;
	 -c) CoresSemFundo ;;
	  *) echo -e "\n\033[1;31mOpção inválida!\nUtilize: $ ${0} -h para ajuda." && exit 1 ;;
esac