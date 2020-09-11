unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Generics.Collections, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Mask, REST.Json, REST.Json.Types, System.Contnrs;

type

  // Classe da Lista da Questão 1
  TProduto = Class
    Codigo : Integer;
    Descricao : String;

  End;

  // Classe da Questão 2
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

  TGerenciadorRecurso = class
  private
    FRecurso : TObjectList;
    FMultiReadExclusiveWrite : TMultiReadExclusiveWriteSynchronizer;
  public
    function AdicionarObjeto(AObjeto : TObject):integer;
    function PegarObjeto(const AIdx : Integer): TObject;
    constructor Create;
    destructor Free;
  end;


  TGravaListaThread = class(TThread)
  private
    FIndice : Integer;
    FThread : String;
    procedure EscreveLista();
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
    lblEstimativa: TLabel;
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
    procedure Button1Click(Sender: TObject);
    procedure btnGerarClick(Sender: TObject);
    procedure btnProcurarClick(Sender: TObject);
    procedure pgMainChange(Sender: TObject);
    procedure edtPesquisaKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure Limpa(Aba : Integer);
    procedure btnJSONClick(Sender: TObject);
    procedure lblCodigoKeyPress(Sender: TObject; var Key: Char);
    procedure lblPesoKeyPress(Sender: TObject; var Key: Char);
    procedure lblNascimentoKeyPress(Sender: TObject; var Key: Char);
    procedure btnThreadClick(Sender: TObject);

  private
    { Private declarations }
  public
    DicProduto : TDictionary<String, TProduto>;
    Produto : TProduto;
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}


function TGerenciadorRecurso.AdicionarObjeto(AObjeto: TObject):integer;
begin
  Self.FMultiReadExclusiveWrite.BeginWrite();
  try
    Result := Self.FRecurso.Add(AObjeto);
  finally
    Self.FMultiReadExclusiveWrite.EndWrite();
  end;
end;


constructor TGerenciadorRecurso.Create;
begin
  Self.FRecurso := TObjectList.Create;
  Self.FRecurso.OwnsObjects := true;
  Self.FMultiReadExclusiveWrite := TMultiReadExclusiveWriteSynchronizer.Create;
end;

destructor TGerenciadorRecurso.Free;
begin
  Self.FRecurso.Free;
  Self.FMultiReadExclusiveWrite.Free;
end;

function TGerenciadorRecurso.PegarObjeto(const AIdx: Integer): TObject;
begin
  Self.FMultiReadExclusiveWrite.BeginRead();
  try
    Result := Self.FRecurso.Items[AIdx];
  finally
    Self.FMultiReadExclusiveWrite.EndRead();
  end;
end;


constructor TGravaListaThread.Create(const CreateSuspended: boolean;
  const IndiceThread: integer; const NomeThread : string);
begin
  Self.FIndice := IndiceThread;
  Self.FThread := NomeThread;
  Self.FreeOnTerminate  := true;
  inherited Create(CreateSuspended);
end;

procedure TGravaListaThread.EscreveLista;
var
  I: Integer;
begin

  FormMain.DicProduto := TDictionary<String, TProduto>.Create;

  For I := 1 to 100 Do
    Begin
      FormMain.Produto := TProduto.Create;
      FormMain.Produto.Codigo := I;
      FormMain.Produto.Descricao := FThread + ' - ' + FormatDateTime('hh:mm:ss',now);
      FormMain.DicProduto.Add(IntToStr(FIndice) + '-' + FormatFloat('000', i), FormMain.Produto);
    End;


end;

procedure TGravaListaThread.Execute;
begin
  EscreveLista();
end;

procedure TFormMain.btnGerarClick(Sender: TObject);
var

  i : Integer;
  iniCarga: TDateTime;
  Value : TProduto;
  Key : String;

begin


  // Geração da lista com os 50000 registros
  For i := 1 to 50000 Do
    Begin
      Produto := TProduto.Create;
      Produto.Codigo := i;
      Produto.Descricao := 'Software CM' + FormatFloat('00000', i);
      DicProduto.Add(FormatFloat('00000', i), Produto);
    End;


  // Carrega os registros
  iniCarga := now;
  mmBusca.Lines.Add('=================================');

  for Value in DicProduto.Values do
  begin
    mmBusca.Lines.Add('Codigo....: ' + FormatFloat('00000', Value.Codigo) + '  Descricao.: ' + Value.Descricao);
  end;

  // Resumo da Carga

  mmBusca.Lines.Add('=================================');
  mmBusca.Lines.Add('Quantidade de Registros: ' + IntToStr(DicProduto.Count));
  mmBusca.Lines.Add('Inicio carga da lista:' + FormatDateTime('hh:mm:ss', iniCarga));
  mmBusca.Lines.Add('Fim da carga da lista: ' + FormatDateTime('hh:mm:ss', now));
  mmBusca.Lines.Add('Tempo Total da carga da lista: ' + FormatDateTime('hh:mm:ss', now - iniCarga));
  mmBusca.Lines.Add('=================================');


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

  Pessoa := TPessoa.Create;

  try
    Pessoa.Id := StrToInt(lblCodigo.Text);
    Pessoa.Nome := lblNome.Text;
    Pessoa.Peso := StrToFloat(lblPeso.Text);
    Pessoa.DtNascimento := StrToDate(lblNascimento.Text);
    Pessoa.Casado := chkCasado.Checked;

  {
    // Criação de 3 Filhos para compor o array


    Filho := TFilhoPessoa.Create;
    Filho.Nome := 'Mickey';
    Filho.Idade := 30;
    Pessoa.Filhos[0] := Filho;

    Filho := TFilhoPessoa.Create;
    Filho.Nome := 'Pateta';
    Filho.Idade := 45;
    Pessoa.Filhos[1] := Filho;

    Filho := TFilhoPessoa.Create;
    Filho.Nome := 'Pluto';
    Filho.Idade := 10;
    Pessoa.Filhos[2] := Filho;
 }
    mmJSON.Lines.Text := TJson.ObjectToJsonString(Pessoa);
  finally
    Pessoa.Free;
    Filho.Free;
  end;

end;

procedure TFormMain.btnProcurarClick(Sender: TObject);
begin

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
    mmBusca.Lines.Add('=================================');
    mmBusca.Lines.Add('Achei o Produto Código ' + IntToStr(Produto.Codigo) + ' -  Descrição = ' + Produto.Descricao );
    mmBusca.Lines.Add('=================================');
    ShowMessage('Achei o Produto Código ' + IntToStr(Produto.Codigo) + ' -  Descrição = ' + Produto.Descricao)
  end
  else
  begin
    mmBusca.Lines.Add('=================================');
    mmBusca.Lines.Add('Não achei o Produto ' + edtPesquisa.Text);
    mmBusca.Lines.Add('=================================');
    ShowMessage('Não achei o Produto ' + edtPesquisa.Text);
  end;


end;

procedure TFormMain.btnThreadClick(Sender: TObject);
var
  Thread1 : TGravaListaThread;
  Thread2 : TGravaListaThread;
  Thread3 : TGravaListaThread;

  iniCarga : TDateTime;
  Value : TProduto;

begin
  Thread1 := TGravaListaThread.Create(false,1,'Thread 1');
  Thread2 := TGravaListaThread.Create(false,2,'Thread 2');
  Thread3 := TGravaListaThread.Create(false,3,'Thread 3');

  // Carrega os registros
  iniCarga := now;
  mmThread.Lines.Add('=================================');

  for Value in DicProduto.Values do
  begin
    mmThread.Lines.Add('Codigo....: ' + FormatFloat('00000', Value.Codigo) + '  Descricao.: ' + Value.Descricao);
  end;

  // Resumo da Carga

  mmThread.Lines.Add('=================================');
  mmThread.Lines.Add('Quantidade de Registros: ' + IntToStr(DicProduto.Count));
  mmThread.Lines.Add('Inicio carga da lista:' + FormatDateTime('hh:mm:ss', iniCarga));
  mmThread.Lines.Add('Fim da carga da lista: ' + FormatDateTime('hh:mm:ss', now));
  mmThread.Lines.Add('Tempo Total da carga da lista: ' + FormatDateTime('hh:mm:ss', now - iniCarga));
  mmThread.Lines.Add('=================================');

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
  // Criação da Lista do Dicionário
  DicProduto := TDictionary<String, TProduto>.Create;

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
  if pgMain.ActivePage = tsBusca then
    Begin
      DicProduto := TDictionary<String, TProduto>.Create;
    End
  Else if pgMain.ActivePage = tsJSON then
    Begin
      Limpa(1);
    End
  Else if pgMain.ActivePage = tsThread then
    Begin
      Limpa(1);
    End;

end;

procedure TFormMain.Limpa(Aba : Integer);
Begin

   if Aba = 1 then
     Begin
      //Esvazia a lista do dicionário
      DicProduto.Clear;
      //Libera a memória alocada para a lista do dicionário
      DicProduto.Destroy;
      // Limpa Memo Busca
      mmBusca.Lines.Clear;
      // Limpa Pesquisa;
      edtPesquisa.Text;
     End
   Else if Aba = 2 then
     Begin
      //Esvazia a lista do dicionário
      DicProduto.Clear;
      //Libera a memória alocada para a lista do dicionário
      DicProduto.Destroy;
      // Limpa Memo Busca
      mmBusca.Lines.Clear;
      // Limpa Pesquisa;
      edtPesquisa.Text;
     End
   Else if Aba = 3 then
     Begin
      //Esvazia a lista do dicionário
      DicProduto.Clear;
      //Libera a memória alocada para a lista do dicionário
      DicProduto.Destroy;
      // Limpa Memo Busca
      mmBusca.Lines.Clear;
      // Limpa Pesquisa;
      edtPesquisa.Text;
     End;


End;


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
