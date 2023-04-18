#!/bin/bash

while true
do
    # Clear the screen
    clear

    echo ""


    # Get GPU information with nvidia-smi
    GPU_INFO=$(nvidia-smi --query-gpu=index,gpu_name,memory.total,memory.used,memory.free,temperature.gpu --format=csv,noheader,nounits)

    # Determine column widths
    GPU_ID_WIDTH=$(echo "$GPU_INFO" | awk -F',' '{printf "%d", length($1)+2}')
    MODEL_WIDTH=$(echo "$GPU_INFO" | awk -F',' '{printf "%d", length($2)+2}')
    MEMORY_TOTAL_WIDTH=$(echo "$GPU_INFO" | awk -F',' '{printf "%d", length($3)+2}')
    MEMORY_USED_WIDTH=$(echo "$GPU_INFO" | awk -F',' '{printf "%d", length($3)+2}')
    MEMORY_FREE_WIDTH=$(echo "$GPU_INFO" | awk -F',' '{printf "%d", length($4)+2}')
    GPU_TEMP_WIDTH=$(echo "$GPU_INFO" | awk -F',' '{printf "%d", length($4)+2}')

    # Print header row
    printf "\t| %-${GPU_ID_WIDTH}s | %-${MODEL_WIDTH}s | %-${MEMORY_TOTAL_WIDTH}s | %-${MEMORY_USED_WIDTH}s | %-${MEMORY_FREE_WIDTH}s | %-${GPU_TEMP_WIDTH}s |\n" "GPU ID" "Model" "Mem Total" "Mem Used" "Mem Free" "GPU Temp"
    printf "\t|-%-${GPU_ID_WIDTH}s-|-%-${MODEL_WIDTH}s-|-%-${MEMORY_TOTAL_WIDTH}s-|-%-${MEMORY_USED_WIDTH}s-|-%-${MEMORY_FREE_WIDTH}s-|-%-${GPU_TEMP_WIDTH}s-|\n" "------" "-----" "---------" "--------" "--------" "--------"

    # Print data rows
    while read LINE
    do
        GPU_ID=$(echo "$LINE" | awk -F',' '{printf "%d", $1}' | sed -e 's/[[:space:]]*$//')
        MODEL=$(echo "$LINE" | awk -F',' '{printf "%s", $2}')
        MODEL=$(echo "$MODEL" | awk '{gsub(/ +$/,""); print}' | sed -e 's/[[:space:]]*$//')
        MEMORY_TOTAL=$(echo "$LINE" | awk -F',' '{printf "%d", $3}')
        MEMORY_USED=$(echo "$LINE" | awk -F',' '{printf "%d", $4}')
        MEMORY_FREE=$(echo "$LINE" | awk -F',' '{printf "%d", $5}')
        GPU_TEMP=$(echo "$LINE" | awk -F',' '{printf "%d", $6}')

        printf "\t| %-${GPU_ID_WIDTH}s\t | %-${MODEL_WIDTH}s | %-${MEMORY_TOTAL_WIDTH}s  | %-${MEMORY_USED_WIDTH}d | %-${MEMORY_FREE_WIDTH}d | %-${GPU_TEMP_WIDTH}d |\n" "$GPU_ID" "$MODEL" "$MEMORY_TOTAL" "$MEMORY_USED" "$MEMORY_FREE" "$GPU_TEMP"
    done <<< "$GPU_INFO"

    echo ""

    # Wait 5 seconds before updating the data
    sleep 5
done