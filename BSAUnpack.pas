unit BSAUnpack;

interface
Uses Classes, SysUtils, BSATypes;


Type

TFilenameFrame = record
  name : String;
  path : String;
  folderId : Integer;
  fileId : Integer;
end;

TBSAUnpack = class

   Private
    fFilename: String;
    fStream : TFileStream;
    fBSAHeader : TBSAHeader;
    fBSAFolders : Array of TBSAFolder;
    fBSAFileBlocks : Array of TBSAFileBlock;
    fFilenameTable : Array of TFilenameFrame;
    fFileNamesOffset : Integer;

    function checkSignature() : Boolean;
    procedure parseHeader();
    procedure parseFolders();
    procedure parseFiles();
    procedure parseFilenames();

    function getFolderName(folderIndex : Integer) : String;
    function getFileRecord(filePath : String) : TBSAFile;

   Public

    Constructor Create();
    Destructor Destroy; override;


    //Properties
    property Filename : String read fFilename write fFilename;

    //Methods
    function Open : Boolean;
    procedure Close;
    procedure getFileList(path : String; const stringList : TStrings);
    procedure ExtractToFile(filePath : String; outputPath : String; overrideFileName : Boolean = false);
end;

implementation

{ TBSAUnpack }


function TBSAUnpack.checkSignature: Boolean;
var sign : TBSASignature;
begin
  fStream.Position := 0;
  fStream.Read(sign, SizeOf(TBSASignature));
  Result := sign = BSA_SIGNATURE;
end;



procedure TBSAUnpack.Close;
begin
if Assigned(fStream) then
  fStream.Free;
end;



constructor TBSAUnpack.Create;
begin
fFileNamesOffset := 0;
fFilename := '';
end;



destructor TBSAUnpack.Destroy;
begin
  Close();
end;



procedure TBSAUnpack.ExtractToFile(filePath, outputPath: String; overrideFileName : Boolean);
  var bsaFile : TBSAFile;
      outStream : TFileStream;
      savePath : String;



begin
  bsaFile := getFileRecord(filePath);

  if overrideFileName then
    savePath := outputPath
  else
  begin
    savePath := outputPath+ExtractFileName(filePath);
  end;

if (@bsaFile <> nil) then
 begin
  outStream := TFileStream.Create(savePath, fmCreate);
  fStream.Seek(bsaFile.offset, soFromBeginning);
  outStream.CopyFrom(fStream, bsaFile.size);
  outStream.Free;
 end;

end;


procedure TBSAUnpack.getFileList(path: String; const stringList: TStrings);
var fileIndex : Integer;
    fileFrame : TFilenameFrame;
    fullPath, fileName, filePath : String;
begin
  fullPath := '';

  for fileIndex := 0 to High(fFilenameTable) do
  begin
    fileFrame := fFilenameTable[fileIndex];

    fileName := fileFrame.name;

    filePath := fileFrame.path;
    Delete(filePath, Length(filePath), 1); //Remove null terminator

    if (AnsiPos(path, filePath+'\') = 1) OR (path = '\') then
    begin
      fullPath := filePath+'\'+fileName;
      stringList.Add(fullPath);
    end;
  end;

end;



function TBSAUnpack.getFileRecord(filePath: String): TBSAFile;
var fileIndex : Integer;
    fileFrame : TFilenameFrame;
    fPath, fName : String;
begin

  for fileIndex := 0 to High(fFilenameTable) do
  begin
    fileFrame := fFilenameTable[fileIndex];

    fName := fileFrame.name;

    fPath := fileFrame.path;
    Delete(fPath, Length(fPath), 1); //Remove null terminator

    fPath := fPath+'\'+fName;

    if (fPath = filePath) then
    begin
      Result := fBSAFileBlocks[fileFrame.folderId].filesRecords[
        fileFrame.fileId];
      Exit;
    end;
  end;


end;

function TBSAUnpack.getFolderName(folderIndex: Integer): String;
var folderName : TBSAFolderName;
    charIndex : Integer;
    returnName : String;
begin

  folderName := fBSAFileBlocks[folderIndex].name;
  returnName := '';
  for charIndex := 0 to High(folderName) do
   begin
    returnName := returnName + folderName[charIndex]
   end;

   Result := returnName;

end;



function TBSAUnpack.Open: Boolean;
var isValid : Boolean;
begin

if (FileExists(fFilename)) AND (fFilename <> '') then
begin

  if Assigned(fStream) then
    fStream.Free;

  fStream := TFileStream.Create(fFilename, fmOpenRead + fmShareExclusive);

  isValid := checkSignature(); //Check if valid BSA File

  if not isValid then
   begin
    Close();
    Result := FALSE;
   end
   else
   begin

    parseHeader();
    parseFolders();
    parseFiles();
    parseFilenames();

    Result := TRUE;
   end;

end
else
  Result := FALSE;
end;



procedure TBSAUnpack.parseFiles;
var folderIndex, fileIndex : Integer;

    procedure parseFolderName(folderIndex : Integer);
    var  charIndex : Integer;
         readByte : Byte;
         folderPathLen : Cardinal;
    begin

      fStream.Read(readByte, SizeOf(Byte));
      folderPathLen := ord(readByte);
      SetLength(fBSAFileBlocks[folderIndex].name, folderPathLen);

       for charIndex := 0 to folderPathLen - 1 do
       begin
         fStream.Read(readByte, sizeof(byte));
         fBSAFileBlocks[folderIndex].name[charIndex] := AnsiChar(chr(readByte));
       end;


    end;

begin

  for folderIndex := 0 to HIGH(fBSAFolders) do
    begin
      SetLength(fBSAFileBlocks, Length(fBSAFileBlocks) + 1);

       parseFolderName(folderIndex);


        for fileIndex := 0 to fBSAFolders[folderIndex].count - 1 do
        begin
        SetLength( fBSAFileBlocks[folderIndex].filesRecords, Length(fBSAFileBlocks[folderIndex].filesRecords) + 1);
         fStream.Read( fBSAFileBlocks[folderIndex].filesRecords[fileIndex],
           SizeOf(TBSAFile));
        end;

    end;


    fFileNamesOffset := fStream.Position;
end;



procedure TBSAUnpack.parseFolders;
begin
  SetLength(fBSAFolders, fBSAHeader.folderCount);
  fStream.Read(fBSAFolders[0], SizeOf(TBSAFolder) * fBSAHeader.folderCount);
end;



procedure TBSAUnpack.parseHeader;
begin
  fStream.Position := 0; //Make Sure we are at the beginning of the file
  fStream.Read(fBSAHeader, SizeOf(TBSAHeader));
end;



procedure TBSAUnpack.parseFilenames;
var curFolder, curFile : Integer;
    curFilename : String;
    readByte : Byte;
begin
   curFile := 0;
   FillChar(readByte, 1, #0);
   for curFolder := 0 to fBSAHeader.folderCount - 1 do
    begin

      while curFile <  Length(fBSAFileBlocks[curFolder].filesRecords) do
      begin
        fStream.Read(readByte, sizeof(byte));

        if char(readByte) = #0 then
        begin
         SetLength(fFilenameTable, Length(fFilenameTable) + 1);

         fFilenameTable[High(fFilenameTable)].name := curFilename;
         fFilenameTable[High(fFilenameTable)].path := getFolderName(curFolder);
         fFilenameTable[High(fFilenameTable)].folderId := curFolder;
         fFilenameTable[High(fFilenameTable)].fileId := curFile;

         curFilename := '';
         Inc(curFile);
        end
        else
         curFilename := curFilename + chr(readByte);

      end;

      curFile := 0;



    end;

end;

end.
