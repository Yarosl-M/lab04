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
    procedure DrawRatioRows(data: FibArr; n: integer);
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

procedure TForm1.DrawRatioRows(data: FibArr; n: integer);
var
  RatioArr, OddEvenRatioArr: array of real;
  i, distance, marginX, marginY, w, h, x, y: integer;
  RMin, RMax, scale, phiY: real;
begin
  cv.Clear;
  SetLength(RatioArr, n - 1);
  SetLength(OddEvenRatioArr, n - 2);
  for i := 0 to n - 2 do
  begin
    RatioArr[i] := data[i + 1] / data[i];
  end;
  for i := 0 to n - 3 do
  begin
    // to "normalize", subtract 1
    OddEvenRatioArr[i] := (data[i + 2] / data[i]) - 1.0;
  end;

  //for i := n - 1 downto 1 do
  //begin
  //  RatioArr[i - 1] := data[i] / data[i - 1];
  //end;
  //for i := n - 1 downto 2 do
  //begin
  //  OddEvenRatioArr[i - 2] := data[i] / data[i - 2];
  //end;

  RMin := 1.0;
  RMax := 2.0;

  w := PanelCanvas.Canvas.Width;
  h := PanelCanvas.Canvas.Height;

  w := 792;
  h := 559;

  cv.Pen.Color := clRed;
  cv.Pen.Width := 2;
  cv.Pen.Style := psDash;

  marginX := 20;
  marginY := 20;

  phiY := (2 - phi) * (h - marginY * 2);

  cv.Line(0, marginY + Round(phiY), w - 1, marginY + Round(phiY));

  cv.Pen.Color := clBlue;
  cv.Pen.Width := 8;
  cv.Pen.Style := psSolid;

  for i := 0 to n - 2 do
  begin
    x := marginX + i * ((w - marginX * 2) div n);
    y := marginY + Round((2.0 - RatioArr[i]) * (h - marginY * 2));

    cv.Line(x, y, x, y);
  end;

  for i := 0 to n - 3 do
  begin
    if (odd(i)) then
       // чётные (1 и 3, 3 и 8)
         cv.Pen.Color := clPurple
    else
       // нечётные (1 и 2, 2 и 5)
       cv.Pen.Color := clGreen;
    x := marginX + i * ((w - marginX * 2) div (n - 1));

    // [1; 2] --> [1; 0]
    y := marginY + Round((2.0 - oddEvenRatioArr[i]) * (h - marginY * 2));

    cv.Line(x, y, x, y);
  end;

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
  DrawRatioRows(arr, n);
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
  DrawRatioRows(arr, n);
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

