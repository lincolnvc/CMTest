unit SemaforoThread;

interface

uses
  Classes;

procedure GetLista(Leitor: TStringList);
procedure SetLista(Escritor: TStringList);

implementation

uses
  SysUtils;

var
  Data: TStringList;
  Semaforo: TMultiReadExclusiveWriteSynchronizer;

procedure GetLista(Leitor: TStringList);
begin
  Semaforo.BeginRead;
  try
    Leitor.Assign(Data);
  finally
    Semaforo.EndRead;
  end;
end;

procedure SetLista(Escritor: TStringList);
begin
  Semaforo.BeginWrite;
  try
    Data.Assign(Escritor);
  finally
    Semaforo.EndWrite;
  end;
end;

initialization
  Data := TStringList.Create;
  Semaforo := TMultiReadExclusiveWriteSynchronizer.Create;
finalization
  Semaforo.Free;
  Data.Free;
end.
