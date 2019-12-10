#!/bin/sh
LC_ALL=C \
IFS='	
' \
n='
' \
tape_right=0 \
tape_left=0 \
val=0 \
prog= \
bak=

read_prog()
while read -r line || case $line in '')break; esac; do
	prog=$prog$line
done


case $# in 0)
	read_prog
;;*)
	read_prog < "$1" || exit
esac

IFS=
while case : in '')esac; do
	case $prog in
		'>'*)
			tape_left="$val $tape_left" \
			val=${tape_right%% *} \
			tape_right=${tape_right#* }
			;;
		'<'*)
			tape_right="$val $tape_right" \
			val=${tape_left%% *} \
			tape_left=${tape_left#* }
			;;
		'+'*)
			val=$(( val+1 & 255 ))
			;;
		'-'*)
			val=$(( val-1 & 255 ))
			;;
		'.'*)
			printf \\$(( val / 64 ))$(( val/8 & 7 ))$(( val & 7 ))
			;;
		','*)
			case $input in '')
				read -r input && input=$input$n
			esac

			case $input in ?*)
				case ${input%"${input#?}"} in
					'')val=1;;'')val=2;;'')val=3;;'')val=4;;'')val=5;;'')val=6;;'')val=7;;'')val=8;;'	')val=9;;"$n")val=10;;'')val=11;;'')val=12;;'
				esac
				input=${input#?}
			esac
			;;
		'['*)
			case $val in 0)
				depth=1
				while case $depth in 0)break; esac; do
					bak=${prog%"${prog#["><+-.,[]"]}"}$bak \
					prog=${prog#?}
					case $prog in
						']'*) depth=$(( depth - 1 )) ;;
						'['*) depth=$(( depth + 1 )) ;;
					esac
				done
			esac
			;;
		']'*)
			case $val in 0);;*)
				depth=1
				while case $depth in 0)break; esac; do
					case $bak in
						'['*) depth=$(( depth - 1 )) ;;
						']'*) depth=$(( depth + 1 )) ;;
					esac
					prog=${bak%"${bak#?}"}$prog \
					bak=${bak#?}
				done
			esac
			;;
		'')
			break
			;;
		*)
			prog=${prog#?}
			continue
	esac
	bak=${prog%"${prog#?}"}$bak \
	prog=${prog#?}
done