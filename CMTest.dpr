program CMTest;

uses
  Vcl.Forms,
  Main in 'Main.pas' {FormMain},
  SemaforoThread in 'SemaforoThread.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
