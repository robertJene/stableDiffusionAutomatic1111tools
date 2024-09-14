#!/bin/bash

while true; do
  # Clear the screen
  clear

  # Get GPU information with nvidia-smi
  GPU_INFO=$(nvidia-smi --query-gpu=index,gpu_name,memory.total,memory.used,memory.free,temperature.gpu --format=csv,noheader,nounits)

  # Extract the GPU names and find the length of the longest one
  LONGEST_GPU_NAME_LENGTH=0

  # Loop through each line of GPU_INFO
  while IFS=',' read -r index gpu_name memory_total memory_used memory_free temp_gpu; do
    # Strip leading/trailing spaces from gpu_name
    gpu_name=$(echo "$gpu_name" | sed 's/^[ \t]*//;s/[ \t]*$//')

    # Get the length of the gpu_name
    gpu_name_length=${#gpu_name}

    # Update LONGEST_GPU_NAME_LENGTH if current gpu_name is longer
    if (( gpu_name_length > LONGEST_GPU_NAME_LENGTH )); then
      LONGEST_GPU_NAME_LENGTH=$gpu_name_length
    fi
  done <<< "$GPU_INFO"

  # Print header row, adjusting column width for Model based on the longest GPU name
  printf "| %6s | %-${LONGEST_GPU_NAME_LENGTH}s | %9s | %9s | %9s | %9s |\n" "GPU ID" "Model" "Mem Total" "Mem Used" "Mem Free" "GPU Temp"
  printf "|--------|-%-${LONGEST_GPU_NAME_LENGTH}s-|-----------|-----------|-----------|-----------|\n" "--------------------"

  # Loop through each line (GPU) in the output
  while IFS=',' read -r GPU_ID MODEL MEMORY_TOTAL MEMORY_USED MEMORY_FREE GPU_TEMP; do
    # Remove the word "NVIDIA" from the model name and trim extra spaces
    MODEL=$(echo "$MODEL" | sed 's/^NVIDIA //' | sed -e 's/[[:space:]]*$//')

    # Remove trailing spaces and "C" from temperature
    GPU_TEMP=$(echo "$GPU_TEMP" | sed -e 's/^[[:space:]]*//; s/[[:space:]]*$//')
    GPU_TEMP=${GPU_TEMP%C}

    # Print data row with adjusted formatting for the GPU model length
    printf "| %6d | %-${LONGEST_GPU_NAME_LENGTH}s | %9d | %9d | %9d | %7d C |\n" "$GPU_ID" "$MODEL" "$MEMORY_TOTAL" "$MEMORY_USED" "$MEMORY_FREE" "$GPU_TEMP"
  done <<< "$GPU_INFO"

  echo ""

  # Wait 5 seconds before updating the data
  sleep 5
done
