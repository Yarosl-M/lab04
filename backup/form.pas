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
  RMin, RMax, scale: real;
begin
  cv.Clear;
  SetLength(RatioArr, n - 1);
  SetLength(OddEvenRatioArr, n - 2);
  for i := n - 1 downto 1 do
  begin
    RatioArr[i - 1] := data[i] / data[i - 1];
  end;
  for i := n - 1 downto 2 do
  begin
    OddEvenRatioArr[i - 2] := data[i] / data[i - 2];
  end;

  RMin := Min(phi, Min(MinValue(RatioArr), MinValue(OddEvenRatioArr)));
  RMax := Max(phi, Max(MaxValue(RatioArr), MaxValue(OddEvenRatioArr)));

  // Lazarus and Pascal in general is a shame for humanity
  // Did old fart Wirth think it would look "good" or be "better
  // for learning"? A student can start learning from Python
  // or even C++ just fine, without having to dance with
  // a tambourine just to get the WIDTH and HEIGHT of a canvas
  // from THE CANVAS ITSELF
  w := PanelCanvas.Canvas.Width;
  h := PanelCanvas.Canvas.Height;

  // I officially give up. This language sucks, this whole platform sucks
  // Why do I have to use something that looks like it was made in 2001
  // if I have tools that are not PITA to use and actually RETURN
  // THE WIDTH OF THE CANVAS ELEMENTS WHEN YOU NEED
  w := 792;
  h := 559;

  cv.Pen.Color := clRed;
  cv.Pen.Width := 2;
  cv.Pen.Style := psDash;

  cv.Line(0, h div 2, w - 1, h div 2);

  marginX := 15;
  marginY := 15;

  // or n - 3???
  cv.Pen.Color := clBlue;
  cv.Pen.Width := 5;
  cv.Pen.Style := psSolid;
  showmessage(FloatToStr(RMax) + ' ' + FloatToStr(RMin));
  for i := 0 to n - 2 do
  begin
    x := marginX + i * ((w - marginX * 2) div (n - 1));
    y := Round(oddEvenRatioArr[i] / RMax * (h - marginY * 2));

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

