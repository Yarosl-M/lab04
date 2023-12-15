unit form;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Spin, StdCtrls, Grids,
  ExtCtrls, EpikTimer, Math, FibonacciBackend;

type

  { TForm1 }

  TForm1 = class(TForm)
    Timer: TEpikTimer;
    IterationButton: TButton;
    PanelCanvas: TPanel;
    RecursionButton: TButton;
    IterationScrollbox: TScrollBox;
    RecursionScrollbox: TScrollBox;
    IterationTable: TStringGrid;
    RecursionTable: TStringGrid;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    NInputIterative: TSpinEdit;
    NInputRecursive: TSpinEdit;
    StatsTable: TStringGrid;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure IterationButtonClick(Sender: TObject);
    procedure RecursionButtonClick(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

var
  cv: TCanvas;
  timer: TEpikTimer;
const
  phi = (Sqrt(5) + 1) / 2.0;

procedure DrawRatioRows(data: FibArr; n: integer);
var
  RatioArr, OddEvenRatioArr:  array of real;
  i: integer;
begin
  SetLength(RatioArr, n - 1);
  SetLength(OddEvenRatioArr, n - 2);
end;

procedure TForm1.IterationButtonClick(Sender: TObject);
var
  arr: FibArr;
  n, i: integer;
  table: TStringGrid;
  timeElapsed: extended;
  timeElapsedMicroseconds: real;
begin
  table := IterationTable;
  n := NInputIterative.Value;

  timer.Clear;
  timer.Start;
  arr := FibIterative(n);
  timer.Stop;
  timeElapsed := timer.Elapsed;
  timeElapsedMicroseconds := timeElapsed * 1000000.0;

  table.ColCount := 3;
  table.RowCount := n + 1;
  table.FixedRows := 1;

  table.Cells[0, 0] := 'n';
  table.Cells[1, 0] := 'F(n)';
  table.Cells[2, 0] := 'Соотношение';

  for i := 1 to n do
  begin
    table.Cells[0, i] := IntToStr(i);
    table.Cells[1, i] := IntToStr(arr[i - 1]);
    if (i <> 1) then
       table.Cells[2, i] := FloatToStr(arr[i - 1] / arr[i - 2])
    else
       table.Cells[2, i] := '—';
  end;

  StatsTable.Cells[1, 1] := IntToStr(n);
  StatsTable.Cells[1, 2] := IntToStr(Round(TimeElapsedMicroseconds));
end;

procedure TForm1.RecursionButtonClick(Sender: TObject);
var
  arr: FibArr;
  n, i: integer;
  discard: real;
  table: TStringGrid;
  timeElapsedMicroseconds: real;
  timeElapsed: extended;
begin
  table := RecursionTable;
  n := NInputRecursive.Value;

  timer.Clear;
  timer.Start;
  arr := FibRecursive(n);
  timer.Stop;
  timeElapsed := timer.Elapsed;
  timeElapsedMicroseconds := timeElapsed * 1000000.0;

  table.ColCount := 3;
  table.RowCount := n + 1;
  table.FixedRows := 1;

  table.Cells[0, 0] := 'n';
  table.Cells[1, 0] := 'F(n)';
  table.Cells[2, 0] := 'Соотношение';

  for i := 1 to n do
  begin
    table.Cells[0, i] := IntToStr(i);
    table.Cells[1, i] := IntToStr(arr[i - 1]);
    if (i <> 1) then
       table.Cells[2, i] := FloatToStr(arr[i - 1] / arr[i - 2])
    else
       table.Cells[2, i] := '—';
  end;
  StatsTable.Cells[2, 1] := IntToStr(n);
  StatsTable.Cells[2, 2] := IntToStr(Round(TimeElapsedMicroseconds));
end;

procedure TForm1.FormCreate(Sender: TObject);
var i: integer;
begin
  cv := PanelCanvas.Canvas;

  timer := TEpikTimer.Create(Application);
end;

end.

