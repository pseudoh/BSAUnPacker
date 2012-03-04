unit frmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, BSATypes, BSAUnpack, CodeSiteLogging;

type
  TForm5 = class(TForm)
    Button1: TButton;
    Open: TButton;
    ListBox1: TListBox;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure OpenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;
  bsa : TBSAUnpack;



implementation

{$R *.dfm}




procedure TForm5.Button1Click(Sender: TObject);
begin
  bsa.ExtractToFile(ListBox1.Items[ListBox1.ItemIndex], 'C:\');
end;

procedure TForm5.Button2Click(Sender: TObject);
begin
bsa.Close;
end;

procedure TForm5.FormCreate(Sender: TObject);
begin
  bsa := TBSAUnpack.Create;

end;

procedure TForm5.FormDestroy(Sender: TObject);
begin
bsa.Free;
end;

procedure TForm5.OpenClick(Sender: TObject);
begin
ListBox1.Clear;

bsa.Filename := 'C:\Program Files (x86)\The Elder Scrolls V Skyrim\Data\Skyrim - Sounds.bsa';

bsa.Open;
bsa.getFileList('\', ListBox1.Items);

end;

end.
