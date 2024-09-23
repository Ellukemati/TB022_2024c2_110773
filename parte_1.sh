#!/bin/bash

if [ $# -ne 2 ]; then
  exit 1
fi

padron=$1
directorio=$2

if [ ! -d "$directorio" ]; then
  mkdir -p "$directorio"
fi

numero_tipo=$(expr $padron % 18 + 1)
estadisticas_totales_minimas=$(expr $padron % 100 + 350)
echo "Buscando a todos los Pokémon de tipo número $numero_tipo y una suma de estadísticas mínima de $estadisticas_totales_minimas"

archivo_resultado="$directorio/resultado.txt"
> "$archivo_resultado"

pokemon_csv=$(find . -name "pokemon.csv")
pokemon_stats_csv=$(find . -name "pokemon_stats.csv")
pokemon_types_csv=$(find . -name "pokemon_types.csv")
pokemon_ids=()

while IFS=',' read -r pokemon_id type_id slot; do
  if [[ "$type_id" =~ ^[0-9]+$ && "$type_id" -eq "$numero_tipo" ]]; then
    pokemon_ids+=("$pokemon_id")
  fi
done < "$pokemon_types_csv"

for id in "${pokemon_ids[@]}"; do
  estadisticas_totales=$(awk -F ',' -v pokemon_id="$id" '$1 == pokemon_id {stats_totales+=$3} END {print stats_totales}' "$pokemon_stats_csv")
  if [ "$estadisticas_totales" -ge "$estadisticas_totales_minimas" ]; then
    nombre=$(awk -F ',' -v pokemon_id="$id" '$1 == pokemon_id {print $2}' "$pokemon_csv")
    echo "$nombre" >> "$archivo_resultado"
  fi
done

echo "Resultados guardados en $archivo_resultado"
