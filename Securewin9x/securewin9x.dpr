{
  Copyright (C) 2002 MARTINEAU Emeric

  Ce programme est libre, vous pouvez le redistribuer et/ou le modifier selon
  les termes de la Licence Publique G�n�rale GNU publi�e par la Free Software
  Foundation version 2.

  Ce programme est distribu� car potentiellement utile, mais SANS AUCUNE
  GARANTIE, ni explicite ni implicite, y compris les garanties de
  commercialisation ou d'adaptation dans un but sp�cifique. Reportez-vous �
  la Licence Publique G�n�rale GNU pour plus de d�tails.
}
program securewin9x;

uses
  Forms,
  main in 'main.pas' {Form1},
  a_propos_de in 'a_propos_de.pas' {Form2};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'SecureWin9x';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
