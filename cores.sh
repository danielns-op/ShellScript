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
clear
# ---- VARIÁVEIS ----#
MENSAGEM_AJUDA="""
${0}\n\n
O programa exibe as cores em dois formatos:\n
\t1 - Cores com fundo colorido\n
\t2 - Cores com fundo padrão do terminal\n
\n\tUtilização: $ ${0} [opção]\n
\t\t-h, --help  - Mostra uma ajuda de como utilizar o programa.\n
\t\t-cf - Mostra os códigos de cores com fundo.\n
\t\t-c  - Mostra os códigos de cores sem fundo.\n\n

O programa também pode ser utilizado sem parametros, dessa forma\n
ele irá mostrar um menu de opções.\n"""
MENSAGEM_ERRO="\n\033[1;31mOpção inválida!\nUtilize: $ ${0} -h para ajuda.\033[m"

# ---- FUNÇÕES ----#
function coresComFundo(){
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

function coresSemFundo(){
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

function menu(){
	clear
	read -n1 -p """
	Escolha uma opção:
		[ 1 ] - Cores com fundo
		[ 2 ] - Cores sem fundo
		[ 3 ] - Ajuda
		Opção: """ opcao
	case $opcao in
		1) coresComFundo ;;
		2) coresSemFundo ;;
		3) clear && echo -e $MENSAGEM_AJUDA && exit 1 ;;
	esac
}

# ---- EXECUÇÃO ----#
[[ -z $1 ]] && menu

if [[ $1 == "-h" || $1 == "--help" ]]; then
	echo -e $MENSAGEM_AJUDA
elif [[ $1 == "-c" ]]; then
	coresSemFundo
elif [[ $1 == "-cf" ]]; then
	coresComFundo
else
	echo -e $MENSAGEM_ERRO && exit 1
fi

exit 0