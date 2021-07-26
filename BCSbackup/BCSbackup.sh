#!/usr/bin/env bash
# --------------------------------------------------------- #
# BCSbackup.sh                                              #
# --------------------------------------------------------- #
# Programa para realizar backup de arquivos.                #
# Modo de usar:                                             #
#	$ ./BCSbackup.sh -h                                 #
#	$ ./BCSbackup.sh --help                             #
# Essas opções fazem o programa exibir informações de ajuda #
# referente ao programa.                                    #
# --------------------------------------------------------- #
# Requisitos:                                               #
#	- BCSbackup.doc                                     #
#	- dialog                                            #
#	- Permissões de root                                #
# --------------------------------------------------------- #
# Author: Daniel Noronha (Daniels)                          #
#  Email: danielnoronha.sh@gmail.com                        #
# Versão: v1.0                                              #
# --------------------------------------------------------- #
# Changelog:                                                #
#	v0.1 - 22/07/2021                                   #
#		Criação do programa com dialog.             #
#	v0.2 - 22/07/2021                                   #
#		Corrigindo falha nas funções do dialog.     #
#       v1.0 - 23/07/2021                                   #
#		Adicionado a opção de execução do programa  #
#		de forma simples. Agora temos duas opções,  #
#               -d executando com o dialog ou -s [-sb|-sr]  #
#               executando o backup ou o restore direto do  #
#               terminal.                                   #
# --------------------------------------------------------- #
clear
# ---- TESTES --------------------------------------------- #
# Verifica a instalação do dialog
[[ ! -e "/usr/bin/dialog" ]] && {
	echo "Necessário a instalação do dialog para dar continuidade."
	exit 127
}

# Verifica se foi passado apenas um argumento e adiciona a uma variavel.
[[ "$#" = "1" ]] && { 
	OPCAO=$1
}

# Verifica se foi passado dois argumentos e os adiciona a variaveis.
[[ "$#" = "2" ]] && {
	OPCAO=$1
	ARQUIVO=$2
}

# Verifica se foi passado algum argumento a mais junto a opção -d.
[[ "$OPCAO" = "-d" ]] && [[ -n "$ARQUIVO" ]] && {
	echo "Argumento adicional está incorreto."
	echo "Para executar com modo gráfico adicione apenas -d."
	echo "	$0 -d"
	exit 127

}

# Verifica se a variavel ARQUIVO é valido.
[[ "$OPCAO" = "-sb" ]] || [[ "$OPCAO" = "-sr" ]] && [[ ! -e $ARQUIVO ]] && {
	echo "Informe um arquivo válido no diretório atual."
	exit 1
}

# Verifica se foi passado nenhum ou mais de dois argumentos e mostra uma ajuda.
[[ "$#" = "0" ]] || [[ "$#" > "2" ]] && {
	echo "Veja a documentação para saber como utilizar o programa."
	echo "Segue algumas formas de uso:"
	echo "	$0 -h          - Exibe ajuda."
	echo "	$0 -d          - Entra no modo completo com o Dialog."
	echo "	$0 -sb arquivo - Realiza o backup no modo simples."
	echo "	$0 -sr arquivo - Realiza o restore no modo simples."
	exit 127
}

# Verifica a ausência do arquivo de documentação.
[[ ! -e "BCSbackup.doc" ]] && {
	echo "Arquivo de documentação não disponível."
	exit 1
}

# Verifica se é root
[[ "$UID" != "0" ]] && {
	echo "Você não é root."
	exit 126
}
# --------------------------------------------------------- #
# ---- VARIAVEIS ------------------------------------------ #
DOCUMENTACAO="BCSbackup.doc"
# --------------------------------------------------------- #
# ---- FUNCOES -------------------------------------------- #
function ExibeDocumentacao()
{
	less $DOCUMENTACAO
	exit 0
}


function ModoSimplesBackup()
{
	echo "Executando backup..."

	data_agora=$(date +%d-%m-%Y_%H-%M-%S)
	tar cJpf backup-${data_agora}.tar.xz $ARQUIVO

}


function ModoSimplesRestore()
{
	echo "Executando o restore..."

	tar xf $ARQUIVO

}


function ExecutaBackup()
{ 
	# Pega o caminho absoluto do arquivo
	caminho_backup=$(dialog --stdout \
		--title "Selecione um arquivo para backup." \
		--fselect / \
		20 90)
	
	# Se o caminho do arquivo foi escolhido com sucesso será capturado
	# onde o arquivo será salvo.
	[[ $? = "0" ]] && \
	destino_backup=$(dialog --stdout \
		--title "Selecione o diretório onde o arquivo será salvo." \
		--fselect / \
		20 90)

	[[ ! -d "$destino_backup" ]] || [[ ! -w "$destino_backup" ]] && {
	 	dialog --stdout --title "Erro" \
	 	--msgbox "Informe um diretório válido que você tenha permissão de gravação." \
	 	10 40
	}

	# Remove todas as barras no final do caminho caso exista.
	# Essa remoção é necessária para poder separar de forma correta o caminho do
	# arquivo de backup.
	caminho_backup=$(echo "$caminho_backup" | sed 's/\/$//g')

	# Para não termos problemas com falhas de segurança devido estar utilizando
	# o caminho absoluto, iremos nos movimentar para a pasta onde o arquivo se
	# encontra, iremos realizar o BKP e depois retornaremos para o diretório
	# onde estavamos anteriormente.

	diretorio_atual=$(pwd)

	# Iremos apagar tudo que está entre as / para poder pegar a quantidade de /
	# para então usando o cut conseguir separar o caminho do arquivo que será
	# salvaguardado.
	quantidade_diretorio="${caminho_backup//[^\/]}"
	quantidade_barras="${#quantidade_diretorio}"

	# Separando diretório do arquivo
	caminho_com_separador=$(echo $caminho_backup | sed "s/\//:/$quantidade_barras")
	arquivo_backup=$(echo $caminho_com_separador | cut -d : -f 2)
	dir_origem_backup=$(echo $caminho_com_separador | cut -d : -f 1)

	# Movendo para o diretório onde o arquivo se encontra.
	cd $dir_origem_backup

	# Realizando o backup
	data_agora=$(date +%d-%m-%Y_%Hh%Mm%Ss)
	tar cJpf ${destino_backup}backup-${data_agora}.tar.xz $arquivo_backup

	[[ "$?" = "0" ]] && {
		clear
		echo "Backup realizado com sucesso."
		echo "O arquivo se encontra no diretório: "
		echo "	$destino_backup"
	}

	# Movendo para o diretório anterior.
	cd $diretorio_atual
}


function ExecutaRestore()
{
	arquivo_restore=$(dialog --stdout \
		--title "Selecione um arquivo para restore." \
		--fselect / \
		20 90)

	destino_restore=$(dialog --stdout \
		--title "Selecione o diretório onde o arquivo será salvo" \
		--fselect / \
		20 90)

	[[ ! -d "$destino_restore" ]] || [[ ! -w "$destino_restore" ]] && {
	 	dialog --stdout --title "Erro" \
	 	--msgbox "Informe um diretório válido que você tenha permissão de gravação." \
	 	10 40
	}

	data_agora=$(date +%d-%m-%Y_%H-%M-%S)
	tar xf $arquivo_restore -C $destino_restore

	[[ "$?" = "0" ]] && {
		clear
		echo "Restore realizado com sucesso."
		echo "O arquivo se encontra no diretório: "
		echo "	$destino_restore"
	}
}


function ModoDialog()
{
	opcao=$(dialog --stdout --menu "BCS Backup" 0 0 0 1 "Backup" 2 "Restore")

	case "$opcao" in
		1) ExecutaBackup  ;;
		2) ExecutaRestore ;;
	esac
}


function Main()
{
	case "$OPCAO" in
		-sb)
			ModoSimplesBackup
		;;
		-sr)
			ModoSimplesRestore
		;;
		-d)
			ModoDialog
		;;
		-h | --help)
			ExibeDocumentacao
		;;
		*)
			echo "Opção inválida. Execute: $0 -h"
		;;
	esac
}

# --------------------------------------------------------- #
# ---- EXECUCAO ------------------------------------------- #
echo $OPCAO
Main
exit 0
# --------------------------------------------------------- #
