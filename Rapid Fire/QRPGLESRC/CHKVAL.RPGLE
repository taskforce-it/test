**FREE

//*-----------------------------------------------------------------------------------------*
//*                                                                                         *
//* Copyright (c) 2016 Task Force IT-Consulting GmbH, Waltrop (Germany)                     *
//* This software and the accompanying materials are made available                         *
//* under the terms of the GNU General Public License version 2.0 (GPLv2)                   *
//* which accompanies this distribution and is available at                                 *
//* http://www.gnu.org/licenses/gpl-2.0.html                                                *
//*                                                                                         *
//*-----------------------------------------------------------------------------------------*
//*                                                                                         *
//* Check Value                                                                             *
//*                                                                                         *
//*-----------------------------------------------------------------------------------------*
//*  >>PRE-COMPILER<<                                                                       *
//*    >>CRTCMD<< CRTRPGMOD    MODULE(&LI/&OB) +                                            *
//*                              SRCFILE(&SL/&SF) SRCMBR(&SM);                              *
//*    >>IMPORTANT<<                                                                        *
//*      >>PARM<<  DBGVIEW(*ALL);                                                           *
//*      >>PARM<<  OPTION(*EVENTF);                                                         *
//*      >>PARM<<  TGTRLS(&TR);                                                             *
//*    >>END-IMPORTANT<<                                                                    *
//*    >>EXECUTE<<                                                                          *
//*  >>END-PRE-COMPILER<<                                                                   *
//*-----------------------------------------------------------------------------------------*
//*                                                                                         *
//* Prozedurergebnis                                                                        *
//* ================                                                                        *
//*                                                                                         *
//* *INVALID   --> Der Objektname ist ung�ltig                                              *
//* *VALID     --> Der Objektname ist g�ltig                                                *
//*                                                                                         *
//*------------+--------+-------------------------------------------------------------------*
//*   Datum    I Progr. I Beschreibung                                                      *
//*------------+--------+-------------------------------------------------------------------*
//* 01.07.2014 I   FH   I Programm erstellt                                                 *
//*------------+--------+-------------------------------------------------------------------*

CTL-OPT NoMain;
CTL-OPT DatFmt(*Eur) TimFmt(*Eur) DecEdit('0,');
CTL-OPT Copyright('(C) Copyright Task Force IT-Consulting GmbH');
CTL-OPT ExtBinInt(*YES);

//*-----------------------------------------------------------------------------------------*

// Prozedurenprototyp f�r Prozedur 'ChkVal'

/Copy QCPYSRC,CHKVAL

// Konvertierung alphanumerisches Datum zu numerischem Datum

DCL-DS *N;
  ITAlpDate CHAR(8);
  ITNumDate ZONED(8) Overlay(ITAlpDate : 1);
END-DS;

// Sonstige Felddeklarationen

DCL-S ITName1 CHAR(1) Dim(29) CTData PerRcd(29);                         // G�ltige Zeichen
DCL-S ITName2 CHAR(1) Dim(41) CTData PerRcd(41);                         // G�ltige Zeichen
DCL-S ITCName1 CHAR(1) Dim(29) CTData PerRcd(29);                        // G�ltige Zeichen
DCL-S ITCName2 CHAR(1) Dim(39) CTData PerRcd(39);                        // G�ltige Zeichen
DCL-S ITSName1 CHAR(1) Dim(29) CTData PerRcd(29);                        // G�ltige Zeichen
DCL-S ITSName2 CHAR(1) Dim(40) CTData PerRcd(40);                        // G�ltige Zeichen
DCL-S ITHex CHAR(1) Dim(16) CTData PerRcd(16);                           // G�ltige Zeichen
DCL-S ITNum CHAR(1) Dim(10) CTData PerRcd(10);                           // G�ltige Zeichen
DCL-S ITVal CHAR(1) Based(ITValPtr);                                     // Wert
DCL-S ITValPtr POINTER;                                                  // Wert
DCL-S ITTime CHAR(6) Based(ITTimePtr);                                   // Zeit
DCL-S ITTimePtr POINTER;                                                 // Zeit
DCL-S ITDate CHAR(8) Based(ITDatePtr);                                   // Datum
DCL-S ITDatePtr POINTER;                                                 // Datum
DCL-S ITBlk CHAR(1);                                                     // Leerzeichen
DCL-S ITCnt ZONED(5);                                                    // Z�hler
DCL-S ITSep CHAR(1);                                                     // Separator
DCL-S ITLast CHAR(1);                                                    // Letztes Zeichen

//*-----------------------------------------------------------------------------------------*
//* Wert pr�fen                                                                             *
//*-----------------------------------------------------------------------------------------*

DCL-PROC ChkVal EXPORT;

  DCL-PI ChkVal CHAR(10);                                                  // <-- Fehler
    PITyp CHAR(10) Const;                                                  // --> Art
    PILen ZONED(5) Const;                                                  // --> L�nge
    PIValPtr POINTER Const;                                                // --> Wert
  END-PI;

  Select;
    // Wert zu Art *NAME pr�fen
  When PITyp = '*NAME';
    ExSr SR005;
    // Wert zu Art *CNAME pr�fen
  When PITyp = '*CNAME';
    ExSr SR010;
    // Wert zu Art *SNAME pr�fen
  When PITyp = '*SNAME';
    ExSr SR015;
    // Wert zu Art *XNAME pr�fen
  When PITyp = '*XNAME';
    ExSr SR020;
    // Wert zu Art *TIME pr�fen
  When PITyp = '*TIME';
    ExSr SR025;
    // Wert zu Art *HEX pr�fen
  When PITyp = '*HEX';
    ExSr SR030;
    // Wert zu Art *DATE pr�fen
  When PITyp = '*DATE';
    ExSr SR035;
    // Wert zu Art *PNAME pr�fen
  When PITyp = '*PNAME';
    ExSr SR040;
    // Wert zu Art *NUM pr�fen
  When PITyp = '*NUM';
    ExSr SR045;
    // Ung�ltige Art
  Other;
    Return '*INVALID';
  EndSl;
  // Der Wert enth�lt keine ung�ltigen Zeichen
  Return '*VALID';

  //*-----------------------------------------------------------------------------------------*
  //* Wert zu Art *NAME pr�fen                                                                *
  //*-----------------------------------------------------------------------------------------*

  BegSr SR005;
    // Zeiger initialisieren
    ITValPtr = PIValPtr;
    // Kz. Leerzeichen initialisieren
    ITBlk = 'N';
    // Zeichen �berpr�fen
    FOR ITCnt = 1 TO PILen;
      // Verarbeitung erstes Zeichen
      If ITCnt = 1;
        If %Lookup(ITVal : ITName1) = *Zero;
          Return '*INVALID';
        EndIf;
        // Verarbeitung �brige Zeichen
      Else;
        // Auf dem ersten vorhandenen Leerzeichen d�rfen nur noch Leerzeichen folgen
        If ITBlk = 'J' And
          ITVal <> *Blank;
          Return '*INVALID';
        EndIf;
        // Leerzeichen gefunden
        If ITVal = *Blank;
          ITBlk = 'J';
          // Anderes Zeichen als Leerzeichen gefunden
        Else;
          If %Lookup(ITVal : ITName2) = *Zero;
            Return '*INVALID';
          EndIf;
        EndIf;
      EndIf;
      // Zeiger um eins erh�hen
      If ITCnt < PILen;
        ITValPtr = ITValPtr + 1;
      EndIf;
    ENDFOR;
  EndSr;

  //*-----------------------------------------------------------------------------------------*
  //* Wert zu Art *CNAME pr�fen                                                               *
  //*-----------------------------------------------------------------------------------------*

  BegSr SR010;
    // Zeiger initialisieren
    ITValPtr = PIValPtr;
    // Kz. Leerzeichen initialisieren
    ITBlk = 'N';
    // Zeichen �berpr�fen
    FOR ITCnt = 1 TO PILen;
      // Verarbeitung erstes Zeichen
      If ITCnt = 1;
        If %Lookup(ITVal : ITCName1) = *Zero;
          Return '*INVALID';
        EndIf;
        // Verarbeitung �brige Zeichen
      Else;
        // Auf dem ersten vorhandenen Leerzeichen d�rfen nur noch Leerzeichen folgen
        If ITBlk = 'J' And
          ITVal <> *Blank;
          Return '*INVALID';
        EndIf;
        // Leerzeichen gefunden
        If ITVal = *Blank;
          ITBlk = 'J';
          // Anderes Zeichen als Leerzeichen gefunden
        Else;
          If %Lookup(ITVal : ITCName2) = *Zero;
            Return '*INVALID';
          EndIf;
        EndIf;
      EndIf;
      // Zeiger um eins erh�hen
      If ITCnt < PILen;
        ITValPtr = ITValPtr + 1;
      EndIf;
    ENDFOR;
  EndSr;

  //*-----------------------------------------------------------------------------------------*
  //* Wert zu Art *SNAME pr�fen                                                               *
  //*-----------------------------------------------------------------------------------------*

  BegSr SR015;
    // Zeiger initialisieren
    ITValPtr = PIValPtr;
    // Kz. Leerzeichen initialisieren
    ITBlk = 'N';
    // Zeichen �berpr�fen
    FOR ITCnt = 1 TO PILen;
      // Verarbeitung erstes Zeichen
      If ITCnt = 1;
        If %Lookup(ITVal : ITSName1) = *Zero;
          Return '*INVALID';
        EndIf;
        // Verarbeitung �brige Zeichen
      Else;
        // Auf dem ersten vorhandenen Leerzeichen d�rfen nur noch Leerzeichen folgen
        If ITBlk = 'J' And
          ITVal <> *Blank;
          Return '*INVALID';
        EndIf;
        // Leerzeichen gefunden
        If ITVal = *Blank;
          ITBlk = 'J';
          // Anderes Zeichen als Leerzeichen gefunden
        Else;
          If %Lookup(ITVal : ITSName2) = *Zero;
            Return '*INVALID';
          EndIf;
        EndIf;
      EndIf;
      // Zeiger um eins erh�hen
      If ITCnt < PILen;
        ITValPtr = ITValPtr + 1;
      EndIf;
    ENDFOR;
  EndSr;

  //*-----------------------------------------------------------------------------------------*
  //* Wert zu Art *XNAME pr�fen                                                               *
  //*-----------------------------------------------------------------------------------------*

  BegSr SR020;
    // Zeiger initialisieren
    ITValPtr = PIValPtr;
    // Das erste Zeichen darf kein Stern sein
    If ITVal = '*';
      Return '*INVALID';
    EndIf;
    // Das erste Zeichen darf kein Leerzeichen sein
    If ITVal = *Blank;
      Return '*INVALID';
    EndIf;
  EndSr;

  //*-----------------------------------------------------------------------------------------*
  //* Wert zu Art *TIME pr�fen                                                                *
  //*-----------------------------------------------------------------------------------------*

  BegSr SR025;
    // Zeiger initialisieren
    ITTimePtr = PIValPtr;
    // Die Uhrzeit ist nicht g�ltig
    If (%Subst(ITTime : 1 : 2) < '00' Or
      %Subst(ITTime : 1 : 2) > '23' Or
      %Subst(ITTime : 3 : 2) < '00' Or
      %Subst(ITTime : 3 : 2) > '59' Or
      %Subst(ITTime : 5 : 2) < '00' Or
      %Subst(ITTime : 5 : 2) > '59');
      Return '*INVALID';
    EndIf;
    // Nach den ersten 6 Stellen d�rfen nur Leerzeichen kommen
    If PILen > 6;
      ITCnt = 6;
      DoU ITCnt = PILen;
        ITCnt = ITCnt + 1;
        ITValPtr = PIValPtr + ITCnt - 1;
        If ITVal <> *Blank;
          Return '*INVALID';
        EndIf;
      EndDo;
    EndIf;
  EndSr;

  //*-----------------------------------------------------------------------------------------*
  //* Wert zu Art *HEX pr�fen                                                                 *
  //*-----------------------------------------------------------------------------------------*

  BegSr SR030;
    // Zeiger initialisieren
    ITValPtr = PIValPtr;
    // Kz. Leerzeichen initialisieren
    ITBlk = 'N';
    // Zeichen �berpr�fen
    FOR ITCnt = 1 TO PILen;
      // Die erste Stelle darf kein Leerzeichen sein
      If ITCnt = 1 And
        ITVal = *Blank;
        Return '*INVALID';
      EndIf;
      // Auf dem ersten vorhandenen Leerzeichen d�rfen nur noch Leerzeichen folgen
      If ITBlk = 'J' And
        ITVal <> *Blank;
        Return '*INVALID';
      EndIf;
      // Leerzeichen gefunden
      If ITVal = *Blank;
        ITBlk = 'J';
        // Anderes Zeichen als Leerzeichen gefunden
      Else;
        If %Lookup(ITVal : ITHex) = *Zero;
          Return '*INVALID';
        EndIf;
      EndIf;
      // Zeiger um eins erh�hen
      If ITCnt < PILen;
        ITValPtr = ITValPtr + 1;
      EndIf;
    ENDFOR;
  EndSr;

  //*-----------------------------------------------------------------------------------------*
  //* Wert zu Art *DATE pr�fen                                                                *
  //*-----------------------------------------------------------------------------------------*

  BegSr SR035;
    // Zeiger initialisieren
    ITDatePtr = PIValPtr;
    // Das Datum besteht nicht aus numerischen Zeichen
    If ITDate < '00000000' Or
      ITDate > '99999999';
      Return '*INVALID';
    EndIf;
    // Nach den ersten 8 Stellen d�rfen nur Leerzeichen kommen
    If PILen > 8;
      ITCnt = 8;
      DoU ITCnt = PILen;
        ITCnt = ITCnt + 1;
        ITValPtr = PIValPtr + ITCnt - 1;
        If ITVal <> *Blank;
          Return '*INVALID';
        EndIf;
      EndDo;
    EndIf;
    // Das Datum ist nicht g�ltig
    ITAlpDate = ITDate;
    Test(DE) *Eur ITNumDate;
    *IN99 = %ERROR;
    If *IN99 = *On;
      Return '*INVALID';
    EndIf;
  EndSr;

  //*-----------------------------------------------------------------------------------------*
  //* Wert zu Art *PNAME pr�fen                                                               *
  //*-----------------------------------------------------------------------------------------*

  BegSr SR040;
    // Zeiger initialisieren
    ITValPtr = PIValPtr;
    // Trennung initialisieren
    ITSep = 'N';
    // Letztes Zeichen initialisieren
    ITLast = *Blank;
    // Zeichen �berpr�fen
    FOR ITCnt = 1 TO PILen;
      // Verarbeitung erstes Zeichen
      If ITCnt = 1 And
        ITVal <> '/' And
        ITVal <> '\';
        Return '*INVALID';
      EndIf;
      // Folgende Zeichen d�rfen nicht verwendet werden
      If ITVal = ':' Or
        ITVal = '*' Or
        ITVal = '?' Or
        ITVal = '"' Or
        ITVal = '>' Or
        ITVal = '<' Or
        ITVal = '|';
        Return '*INVALID';
      EndIf;
      // Trennung
      If ITVal = '/' Or
        ITVal = '\';
        If ITSep = 'N';
          ITSep = 'Y';
        Else;
          Return '*INVALID';
        EndIf;
      Else;
        ITSep = 'N';
      EndIf;
      // Letztes Zeichen setzen
      If ITVal <> *Blank;
        ITLast = ITVal;
      EndIf;
      // Zeiger um eins erh�hen
      If ITCnt < PILen;
        ITValPtr = ITValPtr + 1;
      EndIf;
    ENDFOR;
    // Letztes Zeichen darf kein Separator sein
    If ITLast = '/' Or
      ITLast = '\';
      Return '*INVALID';
    EndIf;
  EndSr;

  //*-----------------------------------------------------------------------------------------*
  //* Wert zu Art *NUM pr�fen                                                                 *
  //*-----------------------------------------------------------------------------------------*

  BegSr SR045;
    // Zeiger initialisieren
    ITValPtr = PIValPtr;
    // Kz. Leerzeichen initialisieren
    ITBlk = 'N';
    // Zeichen �berpr�fen
    FOR ITCnt = 1 TO PILen;
      // Die erste Stelle darf kein Leerzeichen sein
      If ITCnt = 1 And
        ITVal = *Blank;
        Return '*INVALID';
      EndIf;
      // Auf dem ersten vorhandenen Leerzeichen d�rfen nur noch Leerzeichen folgen
      If ITBlk = 'J' And
        ITVal <> *Blank;
        Return '*INVALID';
      EndIf;
      // Leerzeichen gefunden
      If ITVal = *Blank;
        ITBlk = 'J';
        // Anderes Zeichen als Leerzeichen gefunden
      Else;
        If %Lookup(ITVal : ITNum) = *Zero;
          Return '*INVALID';
        EndIf;
      EndIf;
      // Zeiger um eins erh�hen
      If ITCnt < PILen;
        ITValPtr = ITValPtr + 1;
      EndIf;
    ENDFOR;
  EndSr;

END-PROC ChkVal;

//*-----------------------------------------------------------------------------------------*
** *NAME (1. Stelle) - 29
ABCDEFGHIJKLMNOPQRSTUVWXYZ$�#
** *NAME (> 1. Stelle) - 41
ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789._$�#
** *CNAME (1. Stelle) - 29
ABCDEFGHIJKLMNOPQRSTUVWXYZ$�#
** *CNAME (> 1. Stelle) - 39
ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789$�#
** *SNAME (1. Stelle) - 29
ABCDEFGHIJKLMNOPQRSTUVWXYZ$�#
** *SNAME (> 1. Stelle) - 40
ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_$�#
** *HEX - 16
0123456789ABCDEF
** *NUM - 10
0123456789
