unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, FileUtil, StrUtils;

type

  { TForm1 }

  TForm1 = class(TForm)
    Memo1: TMemo;
    quitButton: TButton;
    selectButton: TButton;
    convertButton: TButton;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    statusLabel: TLabel;
    procedure convertButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure quitButtonClick(Sender: TObject);
    procedure selectButtonClick(Sender: TObject);
  private

  public

  end;

const
  numMask: array[0..9] of string = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9');

var
  Form1: TForm1;
  selectedFolder, baseName, suffix: string;
  numberOfImages: integer;
  fileList: TStringList;

implementation



{$R *.lfm}

{ TForm1 }

procedure TForm1.selectButtonClick(Sender: TObject);
begin
  selectedFolder := ' ';
  numberOfImages := 0;
  statusLabel.Caption := ' ';
  fileList.Clear;
  if SelectDirectoryDialog1.Execute then
  begin
    selectedFolder := SelectDirectoryDialog1.FileName + PathDelim;
    (* Check for images in destination folder *)
    try
      FindAllFiles(fileList, selectedFolder, '*.png;*.jpg;*.gif', False);
      numberOfImages := fileList.Count;
      statusLabel.Caption := ' ' + IntToStr(numberOfImages) + ' images in folder';
    finally
      Memo1.Lines.Add(selectedFolder + ' selected.');
    end;
  end;
end;

procedure TForm1.convertButtonClick(Sender: TObject);
var
  i, minusOne: integer;
  zeroCount: string;
begin
  i := 0;
  minusOne := 1;
  zeroCount := '0';
  if numberOfImages = 0 then statusLabel.Caption := ' No images in selected folder'
  else
  begin
    (* Create a new directory *)
    if not DirectoryExists(selectedFolder + PathDelim + 'twos') then
      if not CreateDir(selectedFolder + PathDelim + 'twos') then
      begin
        statusLabel.Caption := 'Failed to create directory';
        exit;
      end;
    (* Remove file path *)
    for i := 0 to fileList.Count - 1 do
      fileList.Strings[i] := ExtractFileName(fileList.Strings[i]);
    (* Split filename *)
    baseName := LeftStr(fileList.Strings[0], 4);
    suffix := RightStr(fileList.Strings[0], 3);
  end;
  (* Duplicate files *)
  for i := 0 to (filelist.Count - 1) do
  begin
    minusOne := ((i + 1) * 2) - 1;
    if ((i + 1) < 10) then zeroCount := '00000'
    else if ((i + 1) < 100) then zeroCount := '0000'
    else if ((i + 1) < 1000) then zeroCount := '000'
    else if ((i + 1) < 10000) then zeroCount := '00';
    CopyFile(selectedFolder + PathDelim + fileList.Strings[i], selectedFolder + PathDelim + 'twos' + PathDelim + basename + '_' + zeroCount + IntToStr(minusOne) + '.' + suffix);
    CopyFile(selectedFolder + PathDelim + fileList.Strings[i], selectedFolder + PathDelim + 'twos' + PathDelim + basename + '_' + zeroCount + IntToStr((i + 1) * 2) + '.' + suffix);
    Memo1.Lines.Add(IntToStr(i + 1) + ' of ' + IntToStr(filelist.Count) + ' files copied.');
  end;
  Memo1.Lines.Add('Files written to ' + selectedFolder + 'twos' + PathDelim);
  statusLabel.Caption := 'Complete';
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  fileList.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  selectedFOlder := ' ';
  numberOfImages := 0;
  baseName := 'image';
  suffix := '.png';
  Memo1.Text := 'twos - frame duplicator by Chris Hawkins';
  fileList := TStringList.Create;
  statusLabel.Caption := ' Select a folder of images';
end;

procedure TForm1.quitButtonClick(Sender: TObject);
begin
  fileList.Free;
  Application.Terminate;
end;

end.
