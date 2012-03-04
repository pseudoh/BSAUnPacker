unit BSANode;

interface

Type
TBSANode = class

  Private

  Public

end;

TBSAFolderNode = Class(TBSANode)

  Private
    fPath : String;
    fFilesCount : Integer;
    fId : Integer;
    fNodes : Array of TBSANode;

  Public
    Constructor Create(id : Integer; Path : String; filesCount : Integer);
    property Path : String read fPath;
    property filesCount : Integer read fFilesCount;
    property id : Integer read fId;
End;


implementation

{ TBSAFolderNode }



{ TBSAFolderNode }

constructor TBSAFolderNode.Create(id: Integer; path: String; filesCount : Integer);
begin
  fId := id;
  fPath := path;
  fFilesCount := filesCount;
end;

end.
