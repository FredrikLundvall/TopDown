object TopDownMainFrm: TTopDownMainFrm
  Left = 0
  Top = 0
  Caption = 'TopDown Main'
  ClientHeight = 742
  ClientWidth = 1099
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  Scaled = False
  OnCreate = FormCreate
  OnPaint = FormPaint
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ZombieActionLst: TListBox
    Left = 48
    Top = 64
    Width = 113
    Height = 49
    BevelInner = bvNone
    BevelKind = bkTile
    BevelOuter = bvRaised
    BevelWidth = 4
    BorderStyle = bsNone
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ItemHeight = 18
    Items.Strings = (
      'Stappla hit'
      'Attackera')
    ParentFont = False
    TabOrder = 0
    Visible = False
    OnClick = ZombieActionLstClick
    OnMouseMove = ZombieActionLstMouseMove
  end
end
