// N�c�ssite un image liste ???
// Faire les lignes de s�paration
unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, ImgList;

type
   TDrawItem = procedure(Sender: TObject; ACanvas: TCanvas; ARect: TRect; Selected: Boolean) ;

type
  TForm1 = class(TForm)
    PopupMenu1: TPopupMenu;
    sssd1: TMenuItem;
    Button1: TButton;
    ImageList1: TImageList;
    cvx1: TMenuItem;
    xcvcvx1: TMenuItem;
    N1: TMenuItem;
    wwxwx1: TMenuItem;
    wwx1: TMenuItem;
    N2: TMenuItem;
    dddddd1: TMenuItem;
    dddd1: TMenuItem;
    MainMenu1: TMainMenu;
    cvcv1: TMenuItem;
    cvcv2: TMenuItem;
    cvc1: TMenuItem;
    cvcv3: TMenuItem;
    cvcv4: TMenuItem;
    dfd1: TMenuItem;
    N3: TMenuItem;
    dfdf1: TMenuItem;
    procedure DrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect;
      Selected: Boolean);
    procedure MeasureItem(Sender: TObject; ACanvas: TCanvas;
  var Width, Height: Integer);
    procedure FormCreate(Sender: TObject);
  private
    procedure MenueDrawItemX(xMenu: TMenu);
  public
  end;
procedure MenueDrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect;
  Selected: Boolean);
procedure MenueMeasureItem(Sender: TObject; ACanvas: TCanvas; var Width, Height: Integer);

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  MenueDrawItemX(Menu);
end;

procedure TForm1.DrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect;
  Selected: Boolean);
begin
  MenueDrawItem(Sender, ACanvas, ARect, Selected);
end;

procedure TForm1.MeasureItem(Sender: TObject; ACanvas: TCanvas;
  var Width, Height: Integer);
begin
  MenueMeasureItem(Sender, ACanvas, Width, Height);
end;


procedure TForm1.MenueDrawItemX(xMenu: TMenu);
var
  i: integer;
//  B: TBitmap;
begin
{  B := TBitmap.Create;
  B.Width := 1;
  B.Height := 1;
}
  for i := 0 to ComponentCount - 1 do
    if Components[i] is TMenuItem then
      begin
//        FMenuItem := TMenuItem(Components[i]);
        if (Components[i] as TmenuItem).Caption <> '-'
        then begin
            (Components[i] as TmenuItem).OnDrawItem := DrawItem ;
            (Components[i] as TmenuItem).OnMeasureItem := MeasureItem ;
        end ;
{        if (FMenuItem.ImageIndex = -1) and
           (FMenuItem.Bitmap.width = 0) and (xMenu <> nil) then
          if FMenuItem.GetParentComponent.Name <> xMenu.Name then
            FMenuItem.Bitmap.Assign(b);
}
      end;

//  B.Free;
  DrawMenuBar(handle);


end;


procedure MenueDrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect;
  Selected: Boolean);
var
  txt: string;
  B: TBitmap;

  IConRect, TextRect: TRect;
  FBackColor, FIconBackColor, FSelectedBkColor, FFontColor, FSelectedFontColor,
    FDisabledFontColor, FSeparatorColor, FCheckedColor: TColor;

  i, X1, X2: integer;
  TextFormat: integer;
  HasImgLstBitmap: boolean;
  FMenuItem: TMenuItem;
  FMenu: TMenu;

begin
  FMenuItem := TMenuItem(Sender);
  FMenu := FMenuItem.Parent.GetParentMenu;

  { couleur de fond des item }
  FBackColor := clMenu ;// $00E1E1E1;
  { couleur de fond des icones }
  FIconBackColor := clMenu ;// ;$00D1D1D1;
  { Couleur de fond des item s�lectionn� }
  FSelectedBkColor := clHighLight ; // $00DCCFC7;
  { Couleur de la police }
  FFontColor := clMenuText ;
  { Couleur de la police s�lectionn�e }
  FSelectedFontColor := clHighLightText ; //clBlack;//clNavy;
  { Couleur de la police si item d�sactiv� }
  FDisabledFontColor := clGray;
  { couleur des s�parateurs }
  FSeparatorColor := clBtnFace ;// ;$00D1D1D1;
  { Couleur des item coch�s }
  FCheckedColor := clGray;

  { Suivant si le menu ce lit de droite � gauche }
  if FMenu.IsRightToLeft
  then begin
      X1 := ARect.Right - 20 ;
      X2 := ARect.Right;
  end
  else begin
      X1 := ARect.Left;
      X2 := ARect.Left + 20 ;
  end ;

  { Cr�er le fond de la zone zone correspondant � l'icone }
  IConRect := Rect(X1, ARect.Top, X2, ARect.Bottom);

  { Cr�er la zone de texte }
  TextRect := ARect;
  { Cr�er le texte }
  txt := ' ' + FMenuItem.Caption;

  { Cr�er l'image accueilant l'icone }
  B := TBitmap.Create;

  { Met le mode transparent }
//  if not Selected
//  then begin
      B.Transparent := True;
      B.TransparentMode := tmAuto;
//  end
//  else begin
//      B.Canvas.brush.Style := bsSolid;
//      B.Canvas.Pen.Color := clBlack ;
//      B.Canvas.Brush.Color := clBlack ;
//      B.Canvas.Rectangle(X1, X2, ARect.Top, ARect.Bottom) ;
//      B.Canvas.FillRect(IConRect);
//  end ;
  
  { Indique s'il y a une image d'une image liste }
  HasImgLstBitmap := false;

  if (FMenuItem.Parent.GetParentMenu.Images <>  nil)
  then begin
      if FMenuItem.ImageIndex <> -1
      then
          HasImgLstBitmap := true
      else
          HasImgLstBitmap := false;
  end;

  { S'il y a une image d'une image liste }
  if HasImgLstBitmap
  then begin
      { Lit l'image }
      FMenuItem.Parent.GetParentMenu.Images.GetBitmap(FMenuItem.ImageIndex, B) ;
  end
  else
      { Sinon, s'il }
      if FMenuItem.Bitmap.Width > 0
      then
          B.Assign(TBitmap(FMenuItem.Bitmap)) ;

  { Suivant si le menu ce lit de droite � gauche }
  if FMenu.IsRightToLeft then
    begin
      X1 := ARect.Left ;
      X2 := ARect.Right - 20 ;
    end
  else
    begin
      X1 := ARect.Left + 20;
      X2 := ARect.Right;
    end ;

  { Cr�er un rectangle contenant le texte }
  TextRect := Rect(X1, ARect.Top, X2, ARect.Bottom);

  { Ecrit le texte }
  ACanvas.brush.color := FBackColor;
  ACanvas.FillRect(TextRect);

  if not Selected
  then
      ACanvas.brush.color := FIconBackColor
  else
      ACanvas.brush.color := FSelectedBkColor ;
        
  ACanvas.FillRect(IconRect);

  ACanvas.Font.Color := FFontColor ;

  { Si on pointe sur l'item }
  if Selected
  then begin
      ACanvas.brush.Style := bsSolid;
      ACanvas.brush.color := FSelectedBkColor;
      ACanvas.FillRect(TextRect);
      ACanvas.Pen.color := FSelectedBkColor ;

      ACanvas.Brush.Style := bsClear ;
      ACanvas.Rectangle(TextRect.Left, TextRect.top, TextRect.Right, TextRect.Bottom);
  end;

  { Position l'icone }
  X1 := IConRect.Left + 2;

  { S'il y a une image, on l'a dessine }
  if B <> nil
  then
      ACanvas.Draw(X1, IConRect.top + 1, B) ;

  { Si c'est une barre de s�paration }
  if FMenuItem.Caption <> '-'
  then begin
      { Passe le fond en mode transparent }
      SetBkMode(ACanvas.Handle, TRANSPARENT);

     if Selected
     then
         ACanvas.Font.Color := FSelectedFontColor ;

      { Position le texte }
      if FMenu.IsRightToLeft
      then
          ACanvas.Font.Charset := ARABIC_CHARSET ;

      if FMenu.IsRightToLeft
      then
          TextFormat := DT_RIGHT or DT_RTLREADING or DT_VCENTER or DT_SINGLELINE
      else
          TextFormat := DT_VCENTER or DT_SINGLELINE ; //0 ;

      TextRect := Rect(TextRect.Left, TextRect.top, TextRect.Right, TextRect.Bottom) ;

      DrawtextEx(ACanvas.Handle,
                 PChar(txt),
                 Length(txt),
                 TextRect, TextFormat, nil);
  end
  else begin
      ACanvas.Pen.Color := FSeparatorColor ;
      ACanvas.MoveTo(ARect.Left + 10,
                     TextRect.Top +
                     Round((TextRect.Bottom - TextRect.Top) div 2));
      ACanvas.LineTo(ARect.Right - 2,
                     TextRect.Top +
                     Round((TextRect.Bottom - TextRect.Top) div 2))
  end ;

  B.free;
end;

//procedure MeasureItem(Sender: TObject; ACanvas: TCanvas;
//  var Width, Height: Integer);
procedure MenueMeasureItem(Sender: TObject; ACanvas: TCanvas; var Width, Height: Integer);
var
  s: string;
  W, H: integer;
  P: TPoint;
  IsLine: boolean;
begin
//  if FActive then
//  begin
    S := TMenuItem(Sender).Caption;
      //------
    if S = '-' then IsLine := true else IsLine := false;
    if IsLine then

      //------
      if IsLine then
        S := '';

//    if Trim(ShortCutToText(TMenuItem(Sender).ShortCut)) <> '' then
//      S := S + ShortCutToText(TMenuItem(Sender).ShortCut) + 'WWW';



//    ACanvas.Font.Assign(FFont);
    W := ACanvas.TextWidth(s);
    if pos('&', s) > 0 then
      W := W - ACanvas.TextWidth('&');

//    P := GetImageExtent(TMenuItem(Sender));

//    W := W + P.x + 10;

    if Width < W then
      Width := W;

    if IsLine then
      Height := 4
    else
    begin
      H := ACanvas.TextHeight(s) ; //+ Round(ACanvas.TextHeight(s) * 0.75);
//      if P.y + 4 > H then
//        H := P.y + 4;

      if Height < H then
        Height := H;
    end;
//  end;
end;
end.


end.
