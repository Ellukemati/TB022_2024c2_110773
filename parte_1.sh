#!/bin/bash

if [ $# -ne 2 ]; then
  echo "Entrada incorrecta. Ingresar un padrón y un nombre para el directorio del resultado."
  exit 1
fi

padron=$1
directorio=$2

if [ ! -d "$directorio" ]; then
  mkdir -p "$directorio"
fi

numero_tipo=$(expr $padron % 18 + 1)
estadisticas_totales_minimas=$(expr $padron % 100 + 350)
echo "Buscando a todos los Pokémon del tipo número $numero_tipo y suma de estadísticas mínima de $estadisticas_totales_minimas"

archivo_resultado="$directorio/resultado.txt"
> "$archivo_resultado" # Limpia el archivo resultado para sobrescribir

pokemon_csv=$(find . -name "pokemon.csv")
pokemon_stats_csv=$(find . -name "pokemon_stats.csv")
pokemon_types_csv=$(find . -name "pokemon_types.csv")

declare -A pokemon_stats # Arreglo asociativo = Hash de Bash

while IFS="," read -r pokemon_id type_id _; do # Guarda a los Pokémon del tipo buscado e inicializa sus stats totales en 0 
  if [[ "$type_id" != "type_id" && "$type_id" -eq "$numero_tipo" ]]; then
    pokemon_stats["$pokemon_id"]=0 
  fi
done < "$pokemon_types_csv"

while IFS="," read -r pokemon_id _ base_stat _; do # Suma todas las stats de los Pokémon seleccionados en una sola iteración
  if [[ -n "${pokemon_stats[$pokemon_id]}" ]]; then
    pokemon_stats["$pokemon_id"]=$((pokemon_stats["$pokemon_id"] + base_stat))
  fi
done < "$pokemon_stats_csv"

while IFS=',' read -r id name _; do # Escribe en el archivo a los Pokémon que cumplen los stats mínimos en una sola iteración
  if [[ "$id" != "id" && -n "${pokemon_stats[$id]}" && "${pokemon_stats[$id]}" -ge "$estadisticas_totales_minimas" ]]; then
    echo "$name" >> "$archivo_resultado"
  fi
done < "$pokemon_csv"

echo "Resultado guardado en $archivo_resultado"
