{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit codelibrarian;

{$warn 5023 off : no warning about unused units}
interface

uses
  CodeLibRegister, codelib, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('CodeLibRegister', @CodeLibRegister.Register);
end;

initialization
  RegisterPackage('codelibrarian', @Register);
end.
