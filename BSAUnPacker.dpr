program BSAUnPacker;

uses
  Forms,
  frmMain in 'frmMain.pas' {Form5},
  BSAUnpack in 'BSAUnpack.pas',
  BSATypes in 'BSATypes.pas',
  BSANode in 'BSANode.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm5, Form5);
  Application.Run;
end.
