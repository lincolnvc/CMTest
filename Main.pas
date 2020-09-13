unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Generics.Collections, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Mask, REST.Json, REST.Json.Types, System.Contnrs,
  Vcl.OleCtrls, SemaforoThread;

type

  // Classe da Questão 1
  TProduto = Class
    Codigo : Integer;
    Descricao : String;

  End;

  // Classes da Questão 2
  TFilhoPessoa = Class
  private
    FNome: String;
    FIdade: Integer;
    procedure SetNome(const Value: String);
    procedure SetIdade(const Value: Integer);
  public
    property Nome: String read FNome write SetNome;
    property Idade: Integer read FIdade write SetIdade;
  end;


  TPessoa = Class
  private
    [JSONNameAttribute('codigo')]
    FId: Integer;
    FNome: String;
    [JSONNameAttribute('kg')]
    FPeso: Real;
    [JSONMarshalledAttribute(False)]
    FDtNascimento: TDateTime;
    FCasado: Boolean;
    FFilhos: TObjectList<TFilhoPessoa>;
    procedure SetId(const Value: Integer);
    procedure SetNome(const Value: String);
    procedure SetPeso(const Value: Real);
    procedure SetDtNascimento(const Value: TDateTime);
    procedure SetCasado(const Value: Boolean);
    procedure SetFilhos(const Value: TObjectList<TFilhoPessoa>);
  public
    property Id: Integer read FId write SetId;
    property Nome: String read FNome write SetNome;
    property Peso: Real read FPeso write SetPeso;
    property DtNascimento: TDateTime read FDtNascimento write SetDtNascimento;
    property Casado: Boolean read FCasado write SetCasado;
    property Filhos: TObjectList<TFilhoPessoa> read FFilhos write SetFilhos;
  end;

  // Classes Questão 3
  TGravaListaThread = class(TThread)
    private
    FIndice : Integer;
    FThread : String;
    procedure EscreveLista();
    procedure FinalizarThread(Sender: TObject);
  protected
    procedure Execute; override;
  public
    constructor Create (const CreateSuspended : boolean; const IndiceThread : integer; const NomeThread : string);
  end;

  TLerListaThread = class(TThread)
    private
    FIndice : Integer;
    FThread : String;
    procedure LerLista();
    procedure FinalizarThread(Sender: TObject);
  protected
    procedure Execute; override;
  public
    constructor Create (const CreateSuspended : boolean; const IndiceThread : integer; const NomeThread : string);
  end;


  TFormMain = class(TForm)
    pnTop: TPanel;
    lblTop: TLabel;
    pgMain: TPageControl;
    tsBusca: TTabSheet;
    tsJSON: TTabSheet;
    tsThread: TTabSheet;
    pnBusca: TPanel;
    pnJSON: TPanel;
    pnThread: TPanel;
    btnGerar: TButton;
    Button1: TButton;
    mmBusca: TMemo;
    btnProcurar: TButton;
    edtPesquisa: TEdit;
    lblCodigo: TLabeledEdit;
    lblNome: TLabeledEdit;
    lblPeso: TLabeledEdit;
    lblNascimento: TLabeledEdit;
    chkCasado: TCheckBox;
    btnJSON: TButton;
    mmJSON: TMemo;
    btnThread: TButton;
    mmThread: TMemo;
    mmThread1: TMemo;
    mmThread2: TMemo;
    mmThread3: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure btnGerarClick(Sender: TObject);
    procedure btnProcurarClick(Sender: TObject);
    procedure edtPesquisaKeyPress(Sender: TObject; var Key: Char);
    procedure btnJSONClick(Sender: TObject);
    procedure lblCodigoKeyPress(Sender: TObject; var Key: Char);
    procedure lblPesoKeyPress(Sender: TObject; var Key: Char);
    procedure lblNascimentoKeyPress(Sender: TObject; var Key: Char);
    procedure btnThreadClick(Sender: TObject);
    procedure btnThreadLeituraClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure pgMainChange(Sender: TObject);


  private
    { Private declarations }
  public
    DicProduto : TDictionary<String, TProduto>;
    Produto : TProduto;
    { Public declarations }
  end;

var
  FormMain: TFormMain;
  ListaThread : TStringList;

implementation

{$R *.dfm}


constructor TGravaListaThread.Create(const CreateSuspended: boolean;
  const IndiceThread: integer; const NomeThread : string);
begin
  Self.FIndice := IndiceThread;
  Self.FThread := NomeThread;
  Self.FreeOnTerminate  := true;
  Self.OnTerminate := FinalizarThread;
  inherited Create(CreateSuspended);
end;


constructor TLerListaThread.Create(const CreateSuspended: boolean;
  const IndiceThread: integer; const NomeThread : string);
begin
  Self.FIndice := IndiceThread;
  Self.FThread := NomeThread;
  Self.FreeOnTerminate  := true;
  Self.OnTerminate := FinalizarThread;
  inherited Create(CreateSuspended);
end;

procedure TGravaListaThread.EscreveLista;
var
  I: Integer;
begin

     //while not Terminated do
     // begin

       For I := 1 to 100 Do
        Begin
          ListaThread.Add(FThread + ' - ' + FormatFloat('000', i));
          SemaforoThread.SetLista(ListaThread);
        End;

     // end;

     Exit;

end;

procedure TLerListaThread.LerLista;
var
  I: Integer;
begin

      SemaforoThread.GetLista(ListaThread);

     // while not Terminated  do
     // begin
        for i:=0 to ListaThread.Count-1 do
        begin
          Synchronize(
                      procedure ()
                       Begin
                        If FIndice = 1 then
                          Begin
                             FormMain.mmThread1.Lines.Add(IntToStr(i+1) + ' - ' + ListaThread[i]);
                          End
                        Else If FIndice = 2 then
                          Begin
                             FormMain.mmThread2.Lines.Add(IntToStr(i+1) + ' - ' + ListaThread[i]);
                          End
                        Else If FIndice = 3 then
                          Begin
                             FormMain.mmThread3.Lines.Add(IntToStr(i+1) + ' - ' + ListaThread[i]);
                          End;
                       End
                     );

        end;

      //  end;

      Sleep(100000);

      Exit;

end;

procedure TGravaListaThread.Execute;
begin
  Self.NameThreadForDebugging('Thread Gravar ' + IntToStr(Self.FIndice));
  EscreveLista();
end;

procedure TGravaListaThread.FinalizarThread(Sender: TObject);
begin
  Terminate;
end;

procedure TLerListaThread.Execute;
begin
  Self.NameThreadForDebugging('Thread Ler ' + IntToStr(Self.FIndice));
  LerLista();
end;

procedure TLerListaThread.FinalizarThread(Sender: TObject);
begin
  Terminate;
end;

procedure TFormMain.btnGerarClick(Sender: TObject);
var

  i : Integer;
  iniCarga: TDateTime;
  Value : TProduto;
  Key : String;

begin

  if Assigned(DicProduto) And (DicProduto <> Nil) then
    Begin
      DicProduto.Clear;
    End
  Else
    Begin
      DicProduto := TDictionary<String, TProduto>.Create;
    End;

  mmBusca.Clear;

  mmBusca.Lines.Add('======================================');
  mmBusca.Lines.Add('Gerando Lista,aguarde!');
  mmBusca.Lines.Add('======================================');

  // Geração da lista com os 50000 registros
  For i := 1 to 50000 Do
    Begin
      Produto := TProduto.Create;
      Produto.Codigo := i;
      Produto.Descricao := 'Software CM' + FormatFloat('00000', i);
      DicProduto.Add(FormatFloat('00000', i), Produto);
    End;

  { // Retirado para não demorar
  // Carrega os registros
  iniCarga := now;
  mmBusca.Lines.Add('=================================');

  for Value in DicProduto.Values do
  begin
    mmBusca.Lines.Add('Codigo....: ' + FormatFloat('00000', Value.Codigo) + '  Descricao.: ' + Value.Descricao);
  end;
  }

  // Resumo da Carga
  mmBusca.Lines.Add('');
  mmBusca.Lines.Add('======================================');
  mmBusca.Lines.Add('Quantidade de Registros: ' + IntToStr(DicProduto.Count));
  mmBusca.Lines.Add('Inicio carga da lista:' + FormatDateTime('hh:mm:ss', iniCarga));
  mmBusca.Lines.Add('Fim da carga da lista: ' + FormatDateTime('hh:mm:ss', now));
  mmBusca.Lines.Add('Tempo Total da carga da lista: ' + FormatDateTime('hh:mm:ss', now - iniCarga));
  mmBusca.Lines.Add('======================================');

  mmBusca.Lines.Add('');
  mmBusca.Lines.Add('======================================');
  mmBusca.Lines.Add('Agora você já pode pesquisar!');
  mmBusca.Lines.Add('======================================');


end;

procedure TFormMain.btnJSONClick(Sender: TObject);
var
  Pessoa: TPessoa;
  Filho: TFilhoPessoa;

begin

  if lblCodigo.Text = '' then
    Begin
      ShowMessage('Código deve ser preenchido!');
      Exit;
    End;

  if lblNome.Text = '' then
    Begin
      ShowMessage('Nome deve ser preenchid!o');
      Exit;
    End;

  if lblPeso.Text = '' then
    Begin
      ShowMessage('Peso deve ser preenchido!');
      Exit;
    End;

  if lblNascimento.Text = '' then
    Begin
      ShowMessage('Data de Nascimento deve ser preenchida!');
      Exit;
    End;

  if (Copy(lblNascimento.Text,3,1) <> '/') or (Copy(lblNascimento.Text,6,1) <> '/') then
    Begin
      ShowMessage('Data de Nascimento deve ser informada no formato DD/MM/AAAA!');
      Exit;
    End;

  if Length(lblNascimento.Text) <> 10 then
    Begin
      ShowMessage('Data de Nascimento deve ser informada no formato DD/MM/AAAA!');
      Exit;
    End;


  try

    Pessoa := TPessoa.Create;
    Pessoa.Id := StrToInt(lblCodigo.Text);
    Pessoa.Nome := lblNome.Text;
    Pessoa.Peso := StrToFloat(lblPeso.Text);
    Pessoa.DtNascimento := StrToDate(lblNascimento.Text);
    Pessoa.Casado := chkCasado.Checked;

    // Criação de 3 Filhos para compor o array
    Pessoa.Filhos := TOBjectList<TFilhoPessoa>.Create;

    Filho := TFilhoPessoa.Create;
    Filho.Nome := 'Salomao';
    Filho.Idade := 300;
    Pessoa.Filhos.Add(Filho);

    Filho := TFilhoPessoa.Create;
    Filho.Nome := 'Absalao';
    Filho.Idade := 258;
    Pessoa.Filhos.Add(Filho);

    Filho := TFilhoPessoa.Create;
    Filho.Nome := 'Adonias';
    Filho.Idade := 211;
    Pessoa.Filhos.Add(Filho);

    // Mostra resultados
    mmJSON.Lines.Text := TJson.ObjectToJsonString(Pessoa);

  finally
    Pessoa.Free;
    Filho.Free;
  end;

end;

procedure TFormMain.btnProcurarClick(Sender: TObject);
begin

  if Not (Assigned(DicProduto) And (DicProduto <> Nil)) then
    Begin
       ShowMessage('Gere e carregue a lista primeiro');
       Exit;
    End;

  If DicProduto.Count <= 0 Then
    Begin
       ShowMessage('Gere e carregue a lista primeiro');
       Exit;
    End;

  if edtPesquisa.Text = '' then
    Begin
       ShowMessage('Informe o código do produto para pesquisar');
       Exit;
    End;

  if (DicProduto.TryGetValue(FormatFloat('00000',StrToInt(edtPesquisa.Text)), Produto) = True) then
  begin
    mmBusca.Lines.Add('');
    mmBusca.Lines.Add('======================================');
    mmBusca.Lines.Add('Achei o Produto Código ' + IntToStr(Produto.Codigo) + ' -  Descrição = ' + Produto.Descricao );
    mmBusca.Lines.Add('======================================');
  end
  else
  begin
    mmBusca.Lines.Add('');
    mmBusca.Lines.Add('======================================');
    mmBusca.Lines.Add('Não achei o Produto ' + edtPesquisa.Text);
    mmBusca.Lines.Add('======================================');
  end;


end;

procedure TFormMain.btnThreadClick(Sender: TObject);
var
  Thread1, Thread2, Thread3 : TGravaListaThread;
  ThreadLer1, ThreadLer2,ThreadLer3 : TLerListaThread;

  iniCarga : TDateTime;
  i : integer;
begin

  Try

    If Assigned(ListaThread) And (ListaThread <> Nil) Then FreeAndNil(ListaThread);

    ListaThread := TStringList.Create;

    Thread1 := TGravaListaThread.Create(false,1,'Thread 1');
    Thread2 := TGravaListaThread.Create(false,2,'Thread 2');
    Thread3 := TGravaListaThread.Create(false,3,'Thread 3');

    mmThread.Clear;
    mmThread1.Clear;
    mmThread2.Clear;
    mmThread3.Clear;

    mmThread.Refresh;
    mmThread1.Refresh;
    mmThread2.Refresh;
    mmThread3.Refresh;

    // Carrega os registros
    mmThread.Lines.Add('===================================');
    mmThread.Lines.Add('Gerando Lista via Threads, aguarde.');
    mmThread.Lines.Add('===================================');

    Sleep(1500) ;
    iniCarga := now;

    for i:=0 to ListaThread.Count-1 do
    begin
      mmThread.Lines.Add(IntToStr(i+1) + ' - ' + ListaThread[i]);
    end;


    // Resumo da Carga
    mmThread.Lines.Add('=================================');
    mmThread.Lines.Add('Quantidade de Registros: ' + IntToStr(ListaThread.Count));
    mmThread.Lines.Add('Inicio carga da lista:' + FormatDateTime('hh:mm:ss', iniCarga));
    mmThread.Lines.Add('Fim da carga da lista: ' + FormatDateTime('hh:mm:ss', now));
    mmThread.Lines.Add('Tempo Total da carga da lista: ' + FormatDateTime('hh:mm:ss', now - iniCarga));
    mmThread.Lines.Add('=================================');

    ThreadLer1 := TLerListaThread.Create(false,1,'Thread 1');
    ThreadLer2 := TLerListaThread.Create(false,2,'Thread 2');
    ThreadLer3 := TLerListaThread.Create(false,3,'Thread 3');

    Sleep(3000);

  Finally

    Thread1.Terminate;
    Thread2.Terminate;
    Thread3.Terminate;

  End;

end;

procedure TFormMain.btnThreadLeituraClick(Sender: TObject);
var
  ThreadLer1, ThreadLer2,ThreadLer3 : TLerListaThread;

begin


end;

procedure TFormMain.Button1Click(Sender: TObject);
begin
   Close;
end;

procedure TFormMain.edtPesquisaKeyPress(Sender: TObject; var Key: Char);
begin
  If Not (Key in ['0'..'9',#8])  Then
    Key := Char(0);

end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  TThread(Self).NameThreadForDebugging('Thread Principal');
end;

procedure TFormMain.lblCodigoKeyPress(Sender: TObject; var Key: Char);
begin
  If Not (Key in ['0'..'9',#8])  Then
    Key := Char(0);

end;

procedure TFormMain.lblNascimentoKeyPress(Sender: TObject; var Key: Char);
begin
  If Not (Key in ['0'..'9','/',#8])  Then
    Key := Char(0);

end;

procedure TFormMain.lblPesoKeyPress(Sender: TObject; var Key: Char);
begin
  If Not (Key in ['0'..'9',',',#8]) Then
    Key := Char(0);

end;

procedure TFormMain.pgMainChange(Sender: TObject);
begin

   // Limpa Aba Busca Performática
   edtPesquisa.Text := '';
   mmBusca.Clear;
   if Assigned(DicProduto) And (DicProduto <> Nil) then FreeAndNil(DicProduto);
   // Limpa Aba JSON
   mmJSON.Clear;
   if Assigned(DicProduto) And (DicProduto <> Nil) then
    Begin
      FreeAndNil(DicProduto);
    End;
   // Limpa Aba Thread
   If Assigned(ListaThread) And (ListaThread <> Nil) Then FreeAndNil(ListaThread);
   mmThread.Clear;
   mmThread1.Clear;
   mmThread2.Clear;
   mmThread3.Clear;

end;

procedure TFilhoPessoa.SetNome(const Value: String);
begin
  FNome := Value;
end;

procedure TFilhoPessoa.SetIdade(const Value: Integer);
begin
  FIdade := Value;
end;

procedure TPessoa.SetId(const Value: Integer);
begin
  FId := Value;
end;

procedure TPessoa.SetNome(const Value: String);
begin
  FNome := Value;
end;

procedure TPessoa.SetPeso(const Value: Real);
begin
  FPeso := Value;
end;

procedure TPessoa.SetDtNascimento(const Value: TDateTime);
begin
  FDtNascimento := Value;
end;

procedure TPessoa.SetFilhos(const Value: TObjectList<TFilhoPessoa>);
begin
  FFilhos := Value;
end;

procedure TPessoa.SetCasado(const Value: Boolean);
begin
  FCasado := Value;
end;



end.

