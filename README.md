# stableDiffusionAutomatic1111tools
some scripts to help with Stable Diffusion, Automatic1111, Forge, and Kohya

‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐

Support me

![image](https://github.com/robertJene/stableDiffusionAutomatic1111tools/assets/131090265/e7d99c48-a27a-421d-b488-e8ef5b01803f)

💲 My patreon:
https://www.patreon.com/RobertJene

🍵 Buy me a coffee:
https://www.buymeacoffee.com/robertjene

📺 Drop me a superchat on of my YouTube videos
https://www.youtube.com/watch?v=oSUusZZhQPU


‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐‐


1. embedding_inspector
use this to check the strength and loss of embeddings trained in the training tab of Automatic1111 and Forge
  **RECOMMENDED:**
    When training an embedding, set the value "Save a copy of embedding to log directory every N steps, 0 to disable"
    to 50 or 100 so that the scripts have enough data to read through

   **Files:**

    requirements.txt
   
      Run the commands in this file, they are required for the script:
      inspect_embedding_training.py
      from this REPO to work:
      https://github.com/Zyin055/Inspect-Embedding-Training

    GPU_Stats.bat
      This simply utilizes GPU_Stats.sh without having to run the code in an IDE or type a command
    
    GPU_Stats.sh
      This uses nvidia-smi to query your GPU during trainging to monitor VRAM usage and GPU temperature

    embedding-show_loss+inpspect.bat
      Purpose: programatically uses embedding_loss.vbs (provided in this repository) and inspect_embedding_training.py which is available here:
        https://github.com/Zyin055/Inspect-Embedding-Training
    
    Menu Options:
    f. Set/change the log folder where training data is
   
    ~ use this menu to set the folder where the embedding training output is
      (Automatic1111 Train Tab -> Train Tab -> Log directory)
    NOTE: MUST be full absolute path with NO DOUBLE QUOTES (") because the script adds them itself

    1. Show Loss (find loss values below threshold)

    ~ this uses mbedding_loss.vbs, see section for that file below

    2. Create Graphs

    ~ this uses inspect_embedding_training.py to create graphs

    3. Inspect Training (strength values over 0.2 may mean overtrained)

    ~ this uses inspect_embedding_training.py to show the strength values in the embedding files

    embedding_loss.vbs
      This script is utilized by embedding-show_loss+inpspect.bat when they are put in the same folder.
      You can also use it directly with a cscript command.
    
      Purpose: help you filter the results of a training to show values under a certain threshold
      run this script after or while training an embedding

      this script accepts 1 or 2 command line arguments:
      1: the path to textual_inversion_loss.csv after doing an embedding training
      2: the threhold of values to show (only show values lower than this)
      ~ if this value is not provided, it defaults to 0.6 for the threshold
  
    Example commands:
    csript.exe "~FULL_PATH_TO_LOG_FOLDER\Model_Name_512-4950-9800"
    csript.exe "~FULL_PATH_TO_LOG_FOLDER\Model_Name_512-4950-9800" 0.08
    csript.exe "~FULL_PATH_TO_LOG_FOLDER\Model_Name_512-4950-9800" ".04"
  
1. FFMPEG_Image_Converter
use this when setting up training data images to convert all, or some of the files to .PNG

   Purpose:
    to save tons of time when converting all files to PNG format.

    there is a benefit to having all files named in this format:
    instancePrompt (x).png
    where X is a number.
    there is a problem when you have duplicate file names with different extensions.
    
    Example:
      instancePrompt (10).png
      instancePrompt (10).jpg

      this will create a problem where there is one caption file for two images files.

      Furthermore, all files should be .PNG because of the quality.

     **Files:**

    FFMPEG_Image_Converter.bat
     ~this is the option-based batch file that calls a vbscript with arguments to perform the functions.


    FFMPEG_Image_Converter_Batch_Maker.vbs
      ~this is the vbscript that performs the functions.
      ~It uses FFmpeg under the LGPLv2.1

      Menu Options:
        F. Change the working path. The working path is the folder with image files you are working on.
        D. Check for duplicate hashes. This is one method to make sure you don't have duplicates. Will only work if two image file's hases are exactly the same.
          You should choose this option before converting and after.
        E. List extensions in the folder. This option counts how many of each image file type you have in the folder.
        Numbered options - use when you only want to convert a single file type to PNG
        P. Use when you want to convert all files to PNG


     ffmpeg.exe
      ~not included in this repo. You can download the zip from here, and extract the file:
      https://ffmpeg.org
        make sure you put ffmpeg.exe in the same folder as the above two scripts.



  
