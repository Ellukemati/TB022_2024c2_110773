#!/bin/bash

pokemon_csv=$(find . -name "pokemon.csv")
pokemon_abilities_csv=$(find . -name "pokemon_abilities.csv")
ability_names_csv=$(find . -name "ability_names.csv")

while true; do
  echo ""
  echo "> Ingrese el nombre de un Pokémon y se mostrará su información o ingrese 'Salir' para terminar:"
  read -r pokemon_nombre
  pokemon_nombre=$(echo "$pokemon_nombre" | tr '[:upper:]' '[:lower:]')  

  if [[ "$pokemon_nombre" == "salir" ]]; then
    echo ""
    echo "> Saliendo del programa..."
    echo ""
    exit 0
  fi

  pokemon_info=$(awk -F "," -v nombre="$pokemon_nombre" '$2 == nombre {print $0}' "$pokemon_csv")
  
  if [[ -z "$pokemon_info" ]]; then
    echo ""
    echo "> El Pokémon '$pokemon_nombre' no fue encontrado."
    echo ""
    continue
  fi

  pokemon_id=$(echo "$pokemon_info" | cut -d ',' -f 1)
  altura=$(echo "$pokemon_info" | cut -d ',' -f 4)
  peso=$(echo "$pokemon_info" | cut -d ',' -f 5)

  echo ""
  echo "---------------------"
  echo "Pokémon: $pokemon_nombre."
  echo "Altura: $((altura * 10)) centímetros."
  echo "Peso: $((peso / 10)) kilogramos."
  echo ""
  
  echo "Habilidades:"
  habilidades=$(awk -F "," -v poke_id="$pokemon_id" '$1 == poke_id {print $2}' "$pokemon_abilities_csv")
  
  for ability_id in $habilidades; do
    nombre_habilidad=$(awk -F "," -v a_id="$ability_id" '$1 == a_id && $2 == 7 {print $3}' "$ability_names_csv")
    echo " * $nombre_habilidad"
  done
  echo "---------------------"
done
