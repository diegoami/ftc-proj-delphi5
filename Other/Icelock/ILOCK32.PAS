{ Delphi 2.0 Icelock component }
{ Copyright 1996,97 - B. Walker.  icebrakr@ix.netcom.com }
unit iLock32;

interface

uses
  Icelock, Classes;

procedure Register;

implementation

{==============================

   >>  procedure Register;

    >  Description : Registers the tIceLock component, on the
                     samples palette page.

 ==============================}
procedure Register;
begin
  RegisterComponents('Samples', [tIceLock]);
end;

end.
