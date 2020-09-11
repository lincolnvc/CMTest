unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Generics.Collections, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Mask, REST.Json, REST.Json.Types;

type


  // Classe da Lista da Questão 1
  TProduto = Class
    Codigo : Integer;
    Descricao : String;
  End;

  // Classe da Questão 2
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
    procedure SetId(const Value: Integer);
    procedure SetNome(const Value: String);
    procedure SetPeso(const Value: Real);
    procedure SetDtNascimento(const Value: TDateTime);
    procedure SetCasado(const Value: Boolean);
  public
    property Id: Integer read FId write SetId;
    property Nome: String read FNome write SetNome;
    property Peso: Real read FPeso write SetPeso;
    property DtNascimento: TDateTime read FDtNascimento write SetDtNascimento;
    property Casado: Boolean read FCasado write SetCasado;
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
    procedure Button1Click(Sender: TObject);
    procedure btnGerarClick(Sender: TObject);
    procedure btnProcurarClick(Sender: TObject);
    procedure pgMainChange(Sender: TObject);
    procedure edtPesquisaKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure LimpaBusca;
    procedure btnJSONClick(Sender: TObject);
    procedure lblCodigoKeyPress(Sender: TObject; var Key: Char);
    procedure lblPesoKeyPress(Sender: TObject; var Key: Char);
    procedure lblNascimentoKeyPress(Sender: TObject; var Key: Char);
    // Métodos da lista (Dicionário) da questão 1
//    procedure KeyNotify(Sender: TObject; const Item: String; Action: TCollectionNotification);
//    procedure ValueNotify(Sender: TObject; const Item: TProduto; Action: TCollectionNotification);

  private
    { Private declarations }
  public
    DicProduto : TDictionary<String, TProduto>;
    Produto : TProduto;
//    EnumeratorPessoa: TEnumerator<TPair<String, TProduto>>;
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

procedure TFormMain.btnGerarClick(Sender: TObject);
var

  i : Integer;
  iniCarga: TDateTime;
  Value : TProduto;
  Key : String;

begin

  // Criação da Lista do Dicionário
//  DicProduto := TDictionary<String, TProduto>.Create;
  //  DicProduto.OnKeyNotify := KeyNotify;
  // DicProduto.OnValueNotify := ValueNotify;

  // Geração da lista com os 50000 registros
  For i := 1 to 50000 Do
    Begin
      Produto := TProduto.Create;
      Produto.Codigo := i;
      Produto.Descricao := 'Software CM' + FormatFloat('00000', i);
      DicProduto.Add(FormatFloat('00000', i), Produto);
    End;

  // Carrega lista

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
    mmJSON.Lines.Text := TJson.ObjectToJsonString(Pessoa);
  finally
    Pessoa.Free;
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
       LimpaBusca;
    End
  Else if pgMain.ActivePage = tsThread then
    Begin
       LimpaBusca;
    End;

end;

procedure TFormMain.LimpaBusca;
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

procedure TPessoa.SetCasado(const Value: Boolean);
begin
  FCasado := Value;
end;

end.
