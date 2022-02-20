unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ExtDlgs,
  Vcl.ComCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Panel1: TPanel;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    Button2: TButton;
    SaveDialog1: TSaveDialog;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Memo1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
  //驗證身分證正確
  function isrealID(id:string):boolean;
  const Encode : array[0..10] of integer=(1,9,8,7,6,5,4,3,2,1,1);
  var idcode:string;
      i,r:Integer;
  begin
    idcode:=IntToStr(ord(id[1])-55)+copy(id,2,9);
    if Length(idcode)<>11 then
    begin
      result:=False;
      Exit;
    end;
    r:=0;
    for i := 0 to 10 do
      r:=r+strtointdef(idcode[i+1],0)*encode[i];
    result:= r mod 10 = 0;
  end;
  //補0  EX 2,3 > 002  4,5 > 00004
  function ItoN(i,n:integer):string;
  begin
    Result:=IntToStr(i);
    while Length(Result)<n do
      Result:='0'+Result;
  end;
var i,N9,LastNum:integer;
    str_Temp:string;
begin
  str_Temp:='';
  //找中間空幾格
  LastNum:=10-length(LabeledEdit1.Text)-length(LabeledEdit2.Text); //身分證長度10碼
  for I := 1 to LastNum do
    str_Temp:=str_Temp+'9';

  N9:=StrToIntDef(str_Temp,-1);
  Memo1.Clear;
  for i := 0 to N9 do
  begin
    str_Temp:=LabeledEdit1.Text+ItoN(i,LastNum)+LabeledEdit2.Text;
    if isrealID(str_Temp) then
      Memo1.Lines.Append(str_Temp);
  end;
  ShowMessage('共'+IntToStr(Memo1.Lines.Count)+'筆資料');
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if not SaveDialog1.Execute then exit;
  Memo1.Lines.SaveToFile(SaveDialog1.FileName);
end;

procedure TForm1.Memo1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift=[ssCtrl]) and (key = 65) then
    memo1.SelectAll;
end;

end.
