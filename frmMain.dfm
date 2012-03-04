object Form5: TForm5
  Left = 0
  Top = 0
  Caption = 'Form5'
  ClientHeight = 459
  ClientWidth = 750
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 296
    Top = 390
    Width = 153
    Height = 51
    Caption = 'Extract Selected'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Open: TButton
    Left = 8
    Top = 367
    Width = 75
    Height = 25
    Caption = 'Open'
    TabOrder = 1
    OnClick = OpenClick
  end
  object ListBox1: TListBox
    Left = 8
    Top = 8
    Width = 734
    Height = 353
    ItemHeight = 13
    TabOrder = 2
  end
  object Button2: TButton
    Left = 8
    Top = 398
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 3
    OnClick = Button2Click
  end
end
