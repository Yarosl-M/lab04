unit FibonacciBackend;

{$mode ObjFPC}{$H+}

interface
uses
  Classes, SysUtils;

type
  NumType = DWord;
  FibArr = array of NumType;
function FibIterative(n: Integer): FibArr;
function FibRecursive(n: Integer): FibArr;


implementation
function FibIterative(n: Integer): FibArr;
var
  i: Integer;
  arr: FibArr;
begin
  SetLength(arr, n);
  arr[0] := 1;
  arr[1] := 1;
  for i := 2 to n do
  begin
    arr[i] := arr[i - 1] + arr[i - 2];
  end;
  FibIterative := arr;
end;

function CalculateFibRecursive(n: Integer; arr: FibArr): NumType;
var
  res: NumType;
begin
  if (n < 2) then
  begin
    res := 1;
    arr[n] := res;
    CalculateFibRecursive := res;
  end
  else
  begin
    res := CalculateFibRecursive(n - 1, arr) + CalculateFibRecursive(n - 2, arr);
    arr[n] := res;
    CalculateFibRecursive := res;
  end;
end;

function FibRecursive(n: Integer): FibArr;
var
  i: Integer;
  arr: FibArr;
begin
  SetLength(arr, n);
  for i := 0 to n - 1 do
  begin
    arr[i] := CalculateFibRecursive(i, arr);
  end;
  FibRecursive := arr;
end;

end.

