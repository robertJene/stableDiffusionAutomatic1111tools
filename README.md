# stableDiffusionAutomatic1111tools
some scripts to help with Stable Diffusion Automatic1111

**RECOMMENDED:**
  When training an embedding, set the value "Save a copy of embedding to log directory every N steps, 0 to disable"
  to 50 or 100 so that the scripts have enough data to read through

**Files:**

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
  
  
  
  
