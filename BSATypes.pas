unit BSATypes;

interface

  CONST
  BSA_SIGNATURE : array[0..3] of ansichar = ('B', 'S', 'A', #0);

  Type
  TBSASignature =  array[0..3] of ansichar;

  TBSAHeader = record
    fileId : TBSASignature;
    version : Cardinal;
    offset : Cardinal;
    archiveFlags : Cardinal;
    folderCount : Cardinal;
    fileCount : Cardinal;
    totalFolderNameLength : Cardinal;
    totalFileNameLength : Cardinal;
    fileFlags : Cardinal;
  end;


  TBSAFile = record
    nameHash : Array[0..1] of Cardinal;
    size : Cardinal;
    offset : Cardinal;
    //folder_id : Cardinal;
  end;

  TBSAFileRecords = Array of TBSAFile;
  TBSAFolderName = Array of ansichar;

  TBSAFileBlock = record
    name : TBSAFolderName;
    filesRecords : TBSAFileRecords;
  end;

  TBSAFolder = record
    nameHash : Array[0..1] of Cardinal;
    count : Cardinal;
    offset : Cardinal;
  end;

implementation

end.
