unit uProEntradaEstoque;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uTelaHeranca, Data.DB,
  ZAbstractRODataset, ZAbstractDataset, ZDataset, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.Mask, Vcl.ComCtrls, Vcl.DBCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
  TfrmProEntradaEstoque = class(TfrmTelaHeranca)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmProEntradaEstoque: TfrmProEntradaEstoque;

implementation

{$R *.dfm}

end.
