#!/bin/bash

floor=0

#Création de la variable qui permettra ensuite de sélectionner aléatoirement un héros selon sa rareté

randomhero=$(($RANDOM % 15 + 1))

if [[ $randomhero -ge 1 ]] && [[ $randomhero -le 5 ]]; then
    chosenid=1
elif [[ $randomhero -ge 6 ]] && [[ $randomhero -le 9 ]]; then
    chosenid=2
elif [[ $randomhero -ge 10 ]] && [[ $randomhero -le 12 ]]; then
    chosenid=3
elif [[ $randomhero -ge 13 ]] && [[ $randomhero -le 14 ]]; then
    chosenid=4
elif [[ $randomhero -eq 15 ]]; then
    chosenid=5
fi

#Création de la variable qui permettra ensuite de sélectionner aléatoirement un ennemi selon sa rareté

randomennemy=$(($RANDOM % 40 + 1))

if [[ $randomennemy -ge 1 ]] && [[ $randomennemy -le 3 ]]; then
    ennemychosenid=1
elif [[ $randomennemy -eq 4 ]]; then
    ennemychosenid=2
elif [[ $randomennemy -ge 5 ]] && [[ $randomennemy -le 6 ]]; then
    ennemychosenid=3
elif [[ $randomennemy -ge 7 ]] && [[ $randomennemy -le 8 ]]; then
    ennemychosenid=4
elif [[ $randomennemy -eq 9 ]]; then
    ennemychosenid=5
elif [[ $randomennemy -ge 10 ]] && [[ $randomennemy -le 13 ]]; then
    ennemychosenid=6
elif [[ $randomennemy -ge 14 ]] && [[ $randomennemy -le 18 ]]; then
    ennemychosenid=7
elif [[ $randomennemy -ge 19 ]] && [[ $randomennemy -le 21 ]]; then
    ennemychosenid=8
elif [[ $randomennemy -ge 22 ]] && [[ $randomennemy -le 25 ]]; then
    ennemychosenid=9
elif [[ $randomennemy -ge 26 ]] && [[ $randomennemy -le 30 ]]; then
    ennemychosenid=10
elif [[ $randomennemy -ge 31 ]] && [[ $randomennemy -le 35 ]]; then
    ennemychosenid=11
elif [[ $randomennemy -ge 36 ]] && [[ $randomennemy -le 40 ]]; then
    ennemychosenid=12
fi
    
#Permet d'afficher l'interface et de l'actualiser

screen() {
    clear
    echo -e "------------------                                                                ------------------"
    echo -e "|                |                                                                |                |"
    echo -e "|   HP: $HP/$HPMAX    |                                                                |   HP: $OPPOHP/$OPPOHPMAX  |"
    echo -e "|                |                                                                |                |"
    echo -e "|   STR: $STR      |                                                                |   STR: $OPPOSTR      |"
    echo -e "|                |                                                                |                |"
    echo -e "|   HERO: \e[32m$allyname\e[0m   |                                                          | ENEMY: \e[31m$opponame\e[0m|"
    echo -e "|                |                                                                |                |"
    echo -e "---------------------------------                            ---------------------------------------"
    echo -e "$latestally |                           | $latestenemy"
    echo -e "---------------------------------                            ---------------------------------------"
    echo -e "                                                                                                    "
    echo -e "                                                                                                    "
    echo -e "                                                                                                    "
    echo -e "                                                                                                    "
    echo -e "                                                                                                    "
    echo -e "                                                                                                    "
    echo -e "                                                                                                    "
    echo -e "                                                                                                    "
    echo -e "                                                                                                    "
    echo -e "                                                                                                    "
    echo -e "===================================================================================================="
    echo -e "                                                                                                    "
    echo -e "                 FLOOR $floor                    ATTACK (a)                       HEAL (h)      "
    echo -e "                               $floorinfo                                                           "
    echo -e "===================================================================================================="
}

#Système de combat

combat() {
    latestally=$(echo -e "\e[32mYou \e[0mattack and deal $STR damages.")
    OPPOHP=$(printf "%02d" $(($OPPOHP - $STR)))
    latestenemy=$(echo -e "\e[31mOpponent \e[0mattacks and deals $OPPOSTR damages.")
    if [[ $OPPOHP -gt 0 ]]; then
	HP=$(($HP - $OPPOSTR))
    fi
}

#Système de heal

heal() {
    latestally=$(echo -e "\e[32mYou \e[0mhealed yourself for 30HP.")
    latestenemy=$(echo -e "\e[31mOpponent \e[0mattacks and deals $OPPOSTR damages.")
    HP=$(($HP + $HPMAX / 2))
    if [[ $HP -ge $HPMAX ]]; then
	HP=$HPMAX
    fi
    HP=$(($HP-$OPPOSTR))
}

#Utilisation des entrées de l'utilisateur pour lancer une attaque ou un heal

interact() {
    read response
        if [[ $response = "a" ]]; then
            floorinfo=""
	    combat
            screen
        elif [[ $response = "h" ]]; then
            floorinfo=""
            heal
            screen
        fi
}

#Texte qui s'affiche à la mort du joueur

death() {
    if [[ $HP -le 0 ]]; then
            echo "██    ██  ██████  ██    ██     ██████  ██ ███████ ██████  
 ██  ██  ██    ██ ██    ██     ██   ██ ██ ██      ██   ██ 
  ████   ██    ██ ██    ██     ██   ██ ██ █████   ██   ██ 
   ██    ██    ██ ██    ██     ██   ██ ██ ██      ██   ██ 
   ██     ██████   ██████      ██████  ██ ███████ ██████  
                                                          
                                                          "
	    exit
    fi
}

#Texte qui s'affiche lorsque le joueur bat le boss

win() {
    echo -e "\e[1m\e[32mCONGRATULATIONS! \e[0m"
    echo "You succeeded in saving Hyrule!"
}

#Effacer l'écran lorsque le jeu est lancé

clear

#Texte du menu

echo -e "\e[1m\e[96m\e[40m======== Welcome to the Hyrule Castle! ========\e[0m\nYou have to defeat the boss that has taken control of Hyrule...\nA series of floors filled with enemies await you.\n\e[5m\e[32mChoosing a random hero...\e[0m"

while IFS=',' read -r identifiant allyname hp mp str int def res spd luck race class rarity
do
        if [[ $identifiant -eq $chosenid ]]; then
            HP=$hp
	    HPMAX=$hp
	    STR=$str
            break
        fi
done < players.csv

while IFS=',' read -r identifiantennemi opponame oppohp mp oppostr int def res spd luck race class rarity
do
        if [[ $identifiantennemi -eq $ennemychosenid ]]; then
            OPPOHP=$oppohp
            OPPOHPMAX=$oppohp
            OPPOSTR=$oppostr
            break
        fi
done < enemies.csv

echo -e "You are going to play as \e[92m$allyname\e[0m.\nYou enter the castle and climb up to the first floor..."

floor=1
read -n 1 -s -r -p "Press any key to continue"
screen

#Boucle de jeu principale

while [[ $floor -lt 10 ]]
do      
	  
	#Apparition d'un nouvel ennemi et changement d'étage lorsque le précédent meurt
	
	  if [[ $OPPOHP -le 0 ]]; then
	      OPPOHP=$OPPOHPMAX
	      floor=$(($floor+1))

	    #Au dixième étage, génération du boss, et apparition d'un message spécial
	    
	    if [[ $floor -eq 10 ]]; then
		opponame="Ganon"
		OPPOHPMAX=150
		OPPOHP=150
		OPPOSTR=20
		floorinfo=$(echo -e "\e[96mYou climb up to floor" $floor". | \e[0m\e[91mBOSS BATTLE | $opponame\e[0m")
		screen
		while [[ $OPPOHP -gt 0 ]]
		do
		    death
		    interact
		done
		win
		exit 1
	    fi
	    floorinfo=$(echo -e "\e[96mYou climb up to floor" $floor".\e[0m")
	       screen
	  fi

	death
	interact
done

      floor=$(($floor+1))

    if [[ $floor = 10 ]]; then
	opponame="Ganon"
	OPPOHPMAX=150
	OPPOHP=150
	OPPOSTR=20
	screen
	while [[ $OPPOHP -gt 0 ]]
	do
            death
	    interact
	done
    fi
